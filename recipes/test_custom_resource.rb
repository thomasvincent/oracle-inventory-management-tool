#
# Cookbook:: oracle-inventory-management
# Recipe:: test_custom_resource
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#
# Test recipe for validating inventory_entry custom resource
#

include_recipe 'oracle-inventory-management::default'

# Test basic functionality
inventory_entry 'TestDB' do
  oracle_version '19c'
  product_version '19.3.0.0.0'
  oracle_home '/u01/app/oracle/product/19.0.0/dbhome_1'
  oracle_base '/u01/app/oracle'
  installation_type 'EE'
  action :register
end

# Test with components
inventory_entry 'TestDB Comp' do
  oracle_version '19c'
  product_version '19.3.0.0.0'
  oracle_home '/u01/app/oracle/product/19.0.0/dbhome_comp'
  oracle_base '/u01/app/oracle'
  installation_type 'EE'
  components [
    { 'name' => 'RDBMS', 'version' => '19.3.0.0.0' },
    { 'name' => 'Oracle Text', 'version' => '19.3.0.0.0', 'options' => ['Basic', 'Advanced'] }
  ]
  action :register
end

# Test RAC configuration
inventory_entry 'TestRAC' do
  oracle_version '19c'
  product_version '19.3.0.0.0'
  oracle_home '/u01/app/oracle/product/19.0.0/dbhome_rac'
  oracle_base '/u01/app/oracle'
  installation_type 'EE'
  is_rac true
  rac_nodes ['racnode1', 'racnode2']
  grid_home '/u01/app/19.3.0/grid'
  action :register
end

# Test to be removed (for testing deregister action)
inventory_entry 'TestRemove' do
  oracle_version '19c'
  product_version '19.3.0.0.0'
  oracle_home '/u01/app/oracle/product/19.0.0/dbhome_tmp'
  oracle_base '/u01/app/oracle'
  installation_type 'EE'
  action :register
end

# Test deregister action
inventory_entry 'TestRemove' do
  oracle_version '19c'
  product_version '19.3.0.0.0'
  oracle_home '/u01/app/oracle/product/19.0.0/dbhome_tmp'
  oracle_base '/u01/app/oracle'
  action :deregister
end