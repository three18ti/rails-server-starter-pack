#
# Cookbook Name:: server-setup
# Recipe:: default
#
# Copyright 2016, SWEATSHOP SOLUTIONS
#
# All rights reserved - Do Not Redistribute
#
# update package database
execute "update packages" do
  command "apt-get update"
end

# install packages
package "telnet"
package "postfix"
package "curl"
package "git-core"
package "zlib1g-dev"
package "libssl-dev"
package "libreadline-dev"
package "libyaml-dev"
package "libsqlite3-dev"
package "sqlite3"
package "libxml2-dev"
package "libxslt1-dev"
package "libpq-dev"
package "build-essential"
package "tree"
package "nodejs"
package "libcurl4-openssl-dev"