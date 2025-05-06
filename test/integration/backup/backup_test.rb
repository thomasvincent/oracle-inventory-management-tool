# InSpec test for oracle-inventory-management backup recipe

# Basic tests from default
describe file('/etc/oraInst.loc') do
  it { should exist }
  it { should be_file }
  its('mode') { should cmp '0664' }
  its('owner') { should eq 'oracle' }
  its('group') { should eq 'dba' }
end

describe file('/opt/oracle/oraInventory') do
  it { should exist }
  it { should be_directory }
end

# Backup-specific tests
describe file('/var/backups/oracle_inventory') do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0750' }
  its('owner') { should eq 'oracle' }
  its('group') { should eq 'dba' }
end

# Check for backup script
describe file('/usr/local/bin/oracle_inventory_backup.sh') do
  it { should exist }
  it { should be_file }
  it { should be_executable }
  its('mode') { should cmp '0755' }
end

# Verify backup functionality (hard to test with InSpec since it may not have run yet)
# But we can check if the script has the expected content
describe file('/usr/local/bin/oracle_inventory_backup.sh') do
  its('content') { should match /tar -czf/ }
  its('content') { should match /oraInst\.loc/ }
end