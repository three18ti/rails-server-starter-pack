# Install Passenger open source
bash 'Installing Passenger Open Source Edition' do
  user node['user']['name']
  group node['group']
  cwd "/home/#{node['user']['name']}"

  code <<-EOH
  export HOME=/home/#{node['user']['name']}
  source /home/#{node['user']['name']}/.rvm/scripts/rvm
  gem install passenger -v #{node['passenger']['version']} --no-ri --no-rdoc
  EOH

  regex = Regexp.escape("passenger (#{node['passenger']['version']})")
  not_if { `bash -c "source /home/#{node['user']['name']}/.rvm/scripts/rvm && gem list"`.lines.grep(/^#{regex}/).count > 0 }
end

bash 'Increase swap space if memory is insufficient' do
  user 'root'

  # rubocop:disable Style/CaseIndentation,Lint/EndAlignment
  memory_in_megabytes = case node['os']
    when /.*bsd/
      node['memory']['total'].to_i / 1024 / 1024
    when 'linux'
      node['memory']['total'][/\d*/].to_i / 1024
    when 'darwin'
      node['memory']['total'][/\d*/].to_i
    when 'windows', 'solaris', 'hpux', 'aix'
      node['memory']['total'][/\d*/].to_i / 1024
  end
  # rubocop:enable Style/CaseIndentation,Lint/EndAlignment

  if memory_in_megabytes < 1000
    ## Do your thing!
    code <<-EOH
    dd if=/dev/zero of=/swap bs=1M count=1024
    mkswap /swap
    swapon /swap
    EOH
  end

  not_if { File.exist?('/swap') }
end

bash 'Installing passenger nginx module and nginx from source' do
  user node['user']['name']
  group node['group']

  code <<-EOH
  source /home/#{node['user']['name']}/.rvm/scripts/rvm
  rvmsudo passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download --extra-configure-flags="\"--with-http_gzip_static_module #{node['nginx']['extra_configure_flags']}\""
  EOH

  not_if { File.exist? '/opt/nginx/sbin/nginx' }
end

# Create the config file
passenger_root = "/home/#{node['user']['name']}/.rvm/gems/ruby-#{node['ruby']['version']}/gems/passenger-#{node['passenger']['version']}"
passenger_ruby = "/home/#{node['user']['name']}/.rvm/gems/ruby-#{node['ruby']['version']}/wrappers/ruby"
# passenger_root = "/usr/local/rvm/gems/ruby-#{node['passenger-nginx']['ruby_version']}/gems/passenger-#{node['passenger-nginx']['passenger']['version']}"
template '/opt/nginx/conf/nginx.conf' do
  source 'nginx.conf.erb'
  variables(passenger_root: passenger_root,
            passenger_ruby: passenger_ruby)
end

# Install the nginx control script
cookbook_file '/etc/init.d/nginx' do
  source 'nginx.initd'
  action :create
  mode 0755
end

# Add log rotation
cookbook_file '/etc/logrotate.d/nginx' do
  source 'nginx.logrotate'
  action :create
end

directory '/opt/nginx/conf/sites-enabled' do
  mode 0755
  action :create
  not_if { File.directory? '/opt/nginx/conf/sites-enabled' }
end

directory '/opt/nginx/conf/sites-available' do
  mode 0755
  action :create
  not_if { File.directory? '/opt/nginx/conf/sites-available' }
end

# Set up service to run by default
service 'nginx' do
  supports status: true, restart: true, reload: true
  action [:enable]
end

# Restart/start nginx
service 'nginx' do
  action :restart
  only_if { File.exist? '/opt/nginx/logs/nginx.pid' }
end

service 'nginx' do
  action :start
  not_if { File.exist? '/opt/nginx/logs/nginx.pid' }
end
