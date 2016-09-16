#
# Cookbook Name:: rails_server_starter_pack
# Spec:: users
#

require 'spec_helper'

describe 'rails-server-starter-pack::users' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.override['group'] = 'foo'
        node.override['user']['name'] = 'bar'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates group' do
      expect( chef_run ).to create_group('foo')
    end

    it 'sets sudo for group' do
      expect( chef_run ).to install_sudo('foo')
    end

    it 'creates user' do
      expect( chef_run ).to create_user('bar').with(
        'gid' => 'foo',
        'home' => '/home/bar',
        'shell' => '/bin/bash'
      )
    end
  end
end
