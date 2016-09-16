# create group
group node['group']

# give group sudo privileges
# Use sudo cookbook
# https://github.com/chef-cookbooks/sudo
sudo node['group'] do
  group node['group']
end

# create user
user node['user']['name'] do
  gid node['group']
  home "/home/#{node['user']['name']}"
  password node['user']['password']
  shell '/bin/bash'
  supports manage_home: true # need for /home creation
end
