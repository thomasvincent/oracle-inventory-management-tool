#
# Cookbook:: oracle-inventory-management
# Recipe:: test_versions
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#
# Test recipe for validating Oracle version support
#

include_recipe 'oracle-inventory-management::default'

# Create a basic inventory entry for Oracle 19c
inventory_entry 'Oracle Database 19c' do
  oracle_version '19c'
  product_version node['oracle']['versions']['19c']['full_version']
  oracle_home node['oracle']['versions']['19c']['default_oracle_home']
  oracle_base node['oracle']['versions']['19c']['default_oracle_base']
  installation_type 'EE'
  action :register
end

# Create a basic inventory entry for Oracle 12.2
inventory_entry 'Oracle Database 12.2' do
  oracle_version '12.2'
  product_version node['oracle']['versions']['12.2']['full_version']
  oracle_home node['oracle']['versions']['12.2']['default_oracle_home']
  oracle_base node['oracle']['versions']['12.2']['default_oracle_base']
  installation_type 'EE'
  action :register
end

# Test different installation types
inventory_entry 'Oracle Database 21c Standard' do
  oracle_version '21c'
  product_version node['oracle']['versions']['21c']['full_version']
  oracle_home node['oracle']['versions']['21c']['default_oracle_home']
  oracle_base node['oracle']['versions']['21c']['default_oracle_base']
  installation_type 'SE2'
  action :register
end

# Test with 11g to ensure our support for older versions works
inventory_entry 'Oracle Database 11.2' do
  oracle_version '11.2'
  product_version node['oracle']['versions']['11.2']['full_version']
  oracle_home node['oracle']['versions']['11.2']['default_oracle_home']
  oracle_base node['oracle']['versions']['11.2']['default_oracle_base']
  installation_type 'EE'
  action :register
end