# to create a new blank rails app

package 'git'

app_working_directory = "/home/#{node['user']['name']}/#{node['railsapp']['name']}"
app_git_directory = "/home/#{node['user']['name']}/repo/#{node['railsapp']['name']}.git"
rails_starter_project = 'git://github.com/cupnoodle/derpbox'

# install rails
bash 'Install rails gem and postgres gem' do
  user node['user']['name']
  group node['group']
  cwd "/home/#{node['user']['name']}"

  code <<-EOH
    export HOME=/home/#{node['user']['name']}
    source /home/#{node['user']['name']}/.rvm/scripts/rvm

    gem install rails --no-ri --no-rdoc
    gem install pg --no-ri --no-rdoc
  EOH
end

# create a folder to store the git version control only
directory "/home/#{node['user']['name']}/repo" do
  owner node['user']['name']
  group node['group']
  mode '0755'
  action :create

  not_if { File.exist?("/home/#{node['user']['name']}/repo") }
end

# create the working directory inside the user home directory
# directory app_working_directory do
#  owner node['user']['name']
#  group node['group']
#  mode '0755'
#  action :create
#
#  not_if { File.exists?(app_working_directory) }
# end

# bash 'Create a new empty rails project located in app working directory' do
#  user node['user']['name']
#  group node['group']
#  cwd "/home/#{node['user']['name']}"
#
#  code <<-EOH
#    export HOME=/home/#{node['user']['name']}
#    source /home/#{node['user']['name']}/.rvm/scripts/rvm
#
#    rails new #{node['railsapp']['name']}
#  EOH
#
#  not_if { File.exists?(app_working_directory) }
#
# end

bash 'Git clone a starter rails project to the app working directory' do
  user node['user']['name']
  group node['group']
  cwd "/home/#{node['user']['name']}"

  code <<-EOH
    export HOME=/home/#{node['user']['name']}
    source /home/#{node['user']['name']}/.rvm/scripts/rvm

    git clone --depth=1 --branch=master #{rails_starter_project} #{node['railsapp']['name']}
    rm -rf #{node['railsapp']['name']}/.git
  EOH

  not_if { File.exist?(app_working_directory) }
end

bash 'Run bundle install for the starter rails project' do
  user node['user']['name']
  group node['group']
  cwd app_working_directory

  code <<-EOH
    export HOME=/home/#{node['user']['name']}
    source /home/#{node['user']['name']}/.rvm/scripts/rvm

    bundle install
    rake assets:precompile RAILS_ENV=production
  EOH

  only_if { File.exist?(app_working_directory) }
end

# create the git directory inside the user home directory/repo
directory app_git_directory do
  owner node['user']['name']
  group node['group']
  mode '0755'
  action :create

  not_if { File.exist?(app_git_directory) }
end

# initialize the git repository of the app
bash 'Initializing the git repo of the app' do
  user node['user']['name']
  group node['group']
  cwd app_git_directory

  code <<-EOH
    git init --bare
  EOH

  not_if { File.exist?("#{app_git_directory}/hooks") }
end

# add post receive hook to the git repository
template "#{app_git_directory}/hooks/post-receive" do
  # OWNER  GROUP   WORLD
  # r w x  r w x   r w x
  # 1 1 1  1 0 1   1 0 1
  #  7      5       5
  #  |______|_______|
  #         |
  #        755

  # let it be executable

  mode 0755
  action :create

  source 'post-receive.erb'

  variables(
    git_dir: app_git_directory,
    work_tree: app_working_directory
  )

  user node['user']['name']
  group node['group']
end

# create the nginx config file for the rails app

template "/opt/nginx/conf/sites-available/#{node['railsapp']['name']}" do
  mode 0744
  action :create

  source 'nginx_app.conf.erb'

  variables(
    working_dir: app_working_directory
  )
end

# Symlink the conf
link "/opt/nginx/conf/sites-enabled/#{node['railsapp']['name']}" do
  to "/opt/nginx/conf/sites-available/#{node['railsapp']['name']}"
end

# Create the ruby gemset
# if node['passenger-nginx']['ruby_version'] && app['ruby_gemset']
#  bash "Create Ruby Gemset" do
#    code <<-EOF
#    source #{node['passenger-nginx']['rvm']['rvm_shell']}
#    rvm ruby-#{node['passenger-nginx']['ruby_version']} do rvm gemset create #{app['ruby_gemset']}
#    EOF
#    user "root"
#    not_if { File.directory? "/usr/local/rvm/gems/ruby-#{node['passenger-nginx']['ruby_version']}@#{app['ruby_gemset']}" }
#  end
# end

# Restart/start nginx
service 'nginx' do
  action :restart
  only_if { File.exist? '/opt/nginx/logs/nginx.pid' }
end

service 'nginx' do
  action :start
  not_if { File.exist? '/opt/nginx/logs/nginx.pid' }
end
