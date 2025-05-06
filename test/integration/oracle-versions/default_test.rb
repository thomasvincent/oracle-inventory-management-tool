# InSpec test for oracle-inventory-management version support

# Test for Oracle 19c (default version)
describe file('/u01/app/oracle/product/19.0.0/dbhome_1') do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0755' }
  its('owner') { should eq 'oracle' }
  its('group') { should eq 'dba' }
end

# Check that versions attributes are properly loaded
control 'oracle-versions-attributes' do
  impact 1.0
  title 'Oracle Versions Attributes Verification'
  desc 'Verifies that Oracle versions attributes are properly defined'
  
  # Test that all main supported versions exist in attributes
  %w(19c 21c 18c 12.2 12.1 11.2).each do |version|
    describe file('/opt/oracle/oraInventory/Oracle_Database_' + version) do
      it { should exist }
      it { should be_directory }
    end
  end
end

# Test inventory file contents for a specific version
describe file('/opt/oracle/oraInventory/Oracle_Database_19c/inventory.xml') do
  it { should exist }
  it { should be_file }
  its('content') { should match /<VERSION VALUE="19.3.0.0.0"\/>/ }
  its('content') { should match /<INSTALLATION_TYPE VALUE="EE"\/>/ }
  its('content') { should match /<INSTALLATION_EDITION VALUE="Enterprise Edition"\/>/ }
  its('content') { should match /<ORACLE_VERSION VALUE="19c"\/>/ }
end

# Test inventory file contents for 12.2 version
describe file('/opt/oracle/oraInventory/Oracle_Database_12.2/inventory.xml') do
  it { should exist }
  it { should be_file }
  its('content') { should match /<VERSION VALUE="12.2.0.1.0"\/>/ }
  its('content') { should match /<INSTALLATION_TYPE VALUE="EE"\/>/ }
  its('content') { should match /<INSTALLATION_EDITION VALUE="Enterprise Edition"\/>/ }
  its('content') { should match /<ORACLE_VERSION VALUE="12.2"\/>/ }
end

# Test for audit log presence
describe file('/var/log/oracle/inventory_audit.log') do
  it { should exist }
  it { should be_file }
  its('content') { should match /REGISTER - Oracle product Oracle Database/ }
end