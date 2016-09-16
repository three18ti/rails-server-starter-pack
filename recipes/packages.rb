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

# Install packages
# I'm lazy and hate to type the same thing over and over
# However, I belive it's good practice to be explicit,
# e.g. don't rely on default actions, specify them
node['rails-server-starter-pack']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end
