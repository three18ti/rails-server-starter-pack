#
# Cookbook Name:: rails_server_starter_pack
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'rails-server-starter-pack::packages' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    
    %w(
      telnet postfix curl
      git-core zlib1g-dev libssl-dev
      libreadline-dev libyaml-dev libsqlite3-dev
      sqlite3 libxml2-dev libxslt1-dev libpq-dev
      build-essential tree nodejs libcurl4-openssl-dev
    ).each do |pkg|
      it "installs package #{pkg}" do
       expect( chef_run).to install_package(pkg)
      end
    end
  end
end
