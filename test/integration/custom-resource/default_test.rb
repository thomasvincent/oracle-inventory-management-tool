# InSpec test for inventory_entry custom resource

# Test basic custom resource usage
control 'inventory-entry-basic' do
  impact 1.0
  title 'Basic Custom Resource Test'
  desc 'Verifies that the inventory_entry resource works correctly'
  
  describe file('/opt/oracle/oraInventory/TestDB_19.3.0.0.0/inventory.xml') do
    it { should exist }
    it { should be_file }
    its('content') { should match /<PRODUCT NAME="TestDB">/ }
    its('content') { should match /<VERSION VALUE="19.3.0.0.0"\/>/ }
    its('content') { should match /<INSTALLATION_TYPE VALUE="EE"\/>/ }
    its('content') { should match /<INSTALLATION_EDITION VALUE="Enterprise Edition"\/>/ }
  end
end

# Test custom resource with components
control 'inventory-entry-components' do
  impact 1.0
  title 'Custom Resource Components Test'
  desc 'Verifies that the inventory_entry resource correctly handles components'
  
  describe file('/opt/oracle/oraInventory/TestDB_Comp_19.3.0.0.0/components.xml') do
    it { should exist }
    it { should be_file }
    its('content') { should match /<COMPONENT NAME="RDBMS"/ }
    its('content') { should match /<COMPONENT NAME="Oracle Text"/ }
  end
end

# Test custom resource RAC configuration
control 'inventory-entry-rac' do
  impact 1.0
  title 'Custom Resource RAC Test'
  desc 'Verifies that the inventory_entry resource correctly handles RAC configuration'
  
  describe file('/opt/oracle/oraInventory/TestRAC_19.3.0.0.0/inventory.xml') do
    it { should exist }
    it { should be_file }
    its('content') { should match /<CLUSTER_CONFIG VALUE="TRUE"\/>/ }
  end
  
  # Check RAC node files
  %w(racnode1 racnode2).each do |node|
    describe file("/opt/oracle/oraInventory/TestRAC_19.3.0.0.0/#{node}_inventory.xml") do
      it { should exist }
      it { should be_file }
    end
  end
end

# Test deregister action
control 'inventory-entry-deregister' do
  impact 1.0
  title 'Custom Resource Deregister Test'
  desc 'Verifies that the inventory_entry resource deregister action works correctly'
  
  describe file('/opt/oracle/oraInventory/TestRemove_19.3.0.0.0') do
    it { should_not exist }
  end
end