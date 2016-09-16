#
# Cookbook Name:: server-setup
# Recipe:: default
#
# Copyright 2016, SWEATSHOP SOLUTIONS
#
# All rights reserved - Do Not Redistribute
#
# update package database

# apt will update automatically, unnecessary to manually update.

node['rails-server-starter-pack']['run_list'].each do |_title, recipe|
  include_recipe recipe['name'] if recipe['managed']
end
