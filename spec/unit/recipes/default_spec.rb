#
# Cookbook Name:: acx-oracle-inventory
# Spec:: default
#

require 'spec_helper'

describe 'acx-oracle-inventory::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      Recipe::Attributes.setup(node)
    end.converge(described_recipe)
  end

  it 'installs the default package' do
    skip 'please implement'
    # expect(chef_run).to install_package(Recipe::Literal::SERVICE)
  end
end
