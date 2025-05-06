# InSpec test for oracle-inventory-management RAC support

# Test for Grid Infrastructure home directory
describe file('/u01/app/19.3.0/grid') do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0755' }
  its('owner') { should eq 'oracle' }
  its('group') { should eq 'dba' }
end

# Test inventory structure for RAC
describe file('/opt/oracle/oraInventory/Oracle_RAC_Database_19c') do
  it { should exist }
  it { should be_directory }
end

# Test main inventory file has RAC nodes
describe file('/opt/oracle/oraInventory/Oracle_RAC_Database_19c/inventory.xml') do
  it { should exist }
  it { should be_file }
  its('content') { should match /<NODE NAME="rac-node1"\/>/ }
  its('content') { should match /<NODE NAME="rac-node2"\/>/ }
  its('content') { should match /<CLUSTER_CONFIG VALUE="TRUE"\/>/ }
end

# Test node-specific inventory files
%w(rac-node1 rac-node2).each do |node|
  describe file("/opt/oracle/oraInventory/Oracle_RAC_Database_19c/#{node}_inventory.xml") do
    it { should exist }
    it { should be_file }
    its('content') { should match /<NODE NAME="#{node}"/ }
    its('content') { should match /<HOME NAME="Oracle RAC Database Grid Infrastructure"/ }
  end
end

# Test for components file
describe file('/opt/oracle/oraInventory/Oracle_RAC_Database_19c/components.xml') do
  it { should exist }
  it { should be_file }
  its('content') { should match /<COMPONENT NAME="Oracle Clusterware"/ }
  its('content') { should match /<COMPONENT NAME="Oracle Automatic Storage Management"/ }
end