# Rails server starter pack Cookbook

This cookbook will :

1. Create a user with sudo permission without requiring password for deploying purpose
2. Change system SSH port (optional)
3. Installs RVM and Ruby
4. Installs Passenger and Nginx module
5. Installs PostgreSQL 
6. Set up a placeholder Rails app repo in your server which you can git push later and the deployment task will be run from the post-receive hook

## Requirements

List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.


### Platforms

- Ubuntu 12.04 or later

### Chef

- Chef 11.16 or later
- Chef-Solo (knife-solo), I used chef-solo for easier configuration

### Cookbooks

Optional, I recommend using `fail2ban` official cookbooks to setup fail2ban.

- `fail2ban` - Ban an ip address after too many fail login attempt to prevent someone bruteforce your server

## Attributes.

| Key                                     | Type            | Description                              | Default                                  |
| --------------------------------------- | --------------- | ---------------------------------------- | ---------------------------------------- |
| `['group']`                             | String          | The name of the group with sudo permission which the new user will belongs to | deployer                                 |
| `['user']['name']`                      | String          | The username of the new user that will be created | demo                                     |
| `['user']['password']`                  | String          | The shadow hash of the password of the new user. Shadow hash can be generated using `openssl passwd -1 yourpasswordhere` | $1$aQEG8V7N$oQXPBNWquu0fvjB1KEkKH0       |
| `['ssh']['port']`                       | String          | The port number used by ssh              | 2112                                     |
| `['ruby']['version']`                   | String          | Version of ruby that will be installed   | 2.3.1                                    |
| `['rvm']['gpg_key']`                    | String          | GPG key used to verify the identity of RVM before installation, no need to modify this usually | 409B6B1796C275462A1703113804BB82D39DC0E3 |
| `['passenger']['version']`              | String          | Version of Passenger that will be installed | 5.0.29                                   |
| `['nginx']['extra_configure_flags']`    | String          | Extra configutation flag used for Nginx module installation | _blank_                                  |
| `['nginx']['worker_processes']`         | String          | Number of worker processes that will be spawned for Nginx | 1                                        |
| `['nginx']['worker_connections']`       | String          | Number of simultaneous connections for Nginx | 1024                                     |
| `['db']['root_password']`               | String          | Password for the PostgreSQL database root user | correcthorsebatterystaple                |
| `['db']['user']['name']`                | String          | Username for the new PostgreSQL user     | demo                                     |
| `['db']['user']['password']`            | String          | Password for the new PostgreSQL user     | correcthorsebatterystaple                |
| `['railsapp']['name']`                  | String          | Name of your rails app, this app will be installed to **/home/[username]/[app_name]** directory | demo_app                                 |
| `['railsapp']['server_name']`           | String          | Domain name used to access the rails app (if left blank then will tied to the localhost ip address) | demo_app.example.com                     |
| `['railsapp']['secret_key_base']`       | String          | Secret key base used by the rails app    | 1c739858e1b55a7d57dbb2b9545c3bc503af4d337e8526b5c1438a444231820fb9338533237bcf696897d110abb7f3ab3ac0896b7cba9832b58e610758e2d116 |
| `['railsapp']['post_receive_commands']` | Array of String | Custom post receive commands you want to run after the rails app repository received git push | []                                       |





## Usage

### rails-server-starter-pack::default


Include `rails-server-starter-pack`  's recipes with the following order in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[rails-server-starter-pack::default]",
    "recipe[rails-server-starter-pack::users]",
    "recipe[rails-server-starter-pack::ssh]",
    "recipe[rails-server-starter-pack::rvm]",
    "recipe[rails-server-starter-pack::passenger]",
    "recipe[rails-server-starter-pack::postgres]",
    "recipe[rails-server-starter-pack::railsapp]"
  ]
}
```



Run `knife solo prepare root@YOUR_SERVER_IP` , then edit the **YOUR_SERVER_IP.json** inside **nodes** folder to include the run_list and variables. Then run `knife solo cook root@YOUR_SERVER_IP`.

## Note
The **railsapp** recipe is using a starter rails template from this repository : https://github.com/cupnoodle/derpbox .  


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


## License and Authors

Authors: [soulchild](https://littlefox.es)

