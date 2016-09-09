
# the group user belongs to, and username of the user created
default['group'] = 'deployer'
default['user']['name'] = 'demo'

# this is the shadow hash of the password used for ssh login for the user created above
# type `openssl passwd -1 yourpasswordhere` in terminal to generate
# PLEASE CHANGE THIS
default['user']['password'] = '$1$aQEG8V7N$oQXPBNWquu0fvjB1KEkKH0'

default['ssh']['port'] = '2112'

default['ruby']['version'] = '2.3.1'

# gpg key required to download and install rvm
# don't change this unless the key is changed
default['rvm']['gpg_key'] = '409B6B1796C275462A1703113804BB82D39DC0E3'

default['passenger']['version'] = '5.0.29'

# extra configuration flag used for nginx installation
default['nginx']['extra_configure_flags'] = ''

default['nginx']['worker_processes'] = '1'
default['nginx']['worker_connections'] = '1024'

# database credential for Postgres
default['db']['root_password'] = 'correcthorsebatterystaple'
default['db']['user']['name'] = 'demo'
default['db']['user']['password'] = 'correcthorsebatterystaple'

# name of your rails app
# will be installed to /home/[your username]/[app name]
default['railsapp']['name'] = 'demo_app'

# domain name for the rails app
# Leave blank (i.e '') if you don't have a domain name, you can access it by typing your server ip address in that case.
default['railsapp']['server_name'] = 'demo_app.example.com'

# run `rake secret` and paste the output here, remember to change this
default['railsapp']['secret_key_base'] = '1c739858e1b55a7d57dbb2b9545c3bc503af4d337e8526b5c1438a444231820fb9338533237bcf696897d110abb7f3ab3ac0896b7cba9832b58e610758e2d116'

# custom post receive commands you want to run after the server repo receive git push
default['railsapp']['post_receive_commands'] = []