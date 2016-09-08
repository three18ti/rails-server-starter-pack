# referenced from http://vladigleba.com/blog/2014/08/12/provisioning-a-rails-server-using-chef-part-2-writing-the-recipes/

package "postgresql"
package "postgresql-contrib"
package "libpq-dev"

# change postgres password
execute "change postgres password" do
  user "postgres"
  command "psql -c \"alter user postgres with password '#{node['db']['root_password']}';\""
end

# create new postgres user
execute "create new postgres user" do
  user "postgres"
  command "psql -c \"create user #{node['db']['user']['name']} with password '#{node['db']['user']['password']}';\""
  not_if { `sudo -u postgres psql -tAc \"SELECT * FROM pg_roles WHERE rolname='#{node['db']['user']['name']}'\" | wc -l`.chomp == "1" }
end

# create new postgres database
execute "create new postgres database" do
  user "postgres"
  command "psql -c \"create database #{node['railsapp']['name']}_production owner #{node['db']['user']['name']};\""
  not_if { `sudo -u postgres psql -tAc \"SELECT * FROM pg_database WHERE datname='#{node['railsapp']['name']}_production'\" | wc -l`.chomp == "1" }
end