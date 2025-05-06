#
# Cookbook:: oracle-inventory-management
# Recipe:: test_rac
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#
# Test recipe for validating Oracle RAC support
#

include_recipe 'oracle-inventory-management::default'

# Create a basic RAC inventory entry for Oracle 19c
inventory_entry 'Oracle RAC Database 19c' do
  oracle_version '19c'
  product_version node['oracle']['versions']['19c']['full_version']
  oracle_home node['oracle']['versions']['19c']['default_oracle_home']
  oracle_base node['oracle']['versions']['19c']['default_oracle_base']
  installation_type 'EE'
  is_rac true
  rac_nodes ['rac-node1', 'rac-node2']
  grid_home node['oracle']['rac']['grid_home']['19c']
  components [
    { 'name' => 'Oracle Clusterware', 'version' => node['oracle']['versions']['19c']['full_version'] },
    { 'name' => 'Oracle Automatic Storage Management', 'version' => node['oracle']['versions']['19c']['full_version'] }
  ]
  action :register
end

# Create an inventory entry for an older RAC version (12.2)
inventory_entry 'Oracle RAC Database 12.2' do
  oracle_version '12.2'
  product_version node['oracle']['versions']['12.2']['full_version']
  oracle_home node['oracle']['versions']['12.2']['default_oracle_home']
  oracle_base node['oracle']['versions']['12.2']['default_oracle_base']
  installation_type 'EE'
  is_rac true
  rac_nodes ['rac-node1', 'rac-node2', 'rac-node3']  # Testing with 3 nodes
  grid_home node['oracle']['rac']['grid_home']['12.2']
  components [
    { 'name' => 'Oracle Clusterware', 'version' => node['oracle']['versions']['12.2']['full_version'] },
    { 'name' => 'Oracle Automatic Storage Management', 'version' => node['oracle']['versions']['12.2']['full_version'] }
  ]
  action :register
end