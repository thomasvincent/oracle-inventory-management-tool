# InSpec test for oracle-inventory-management default recipe

# Oracle Inventory File
describe file('/etc/oraInst.loc') do
  it { should exist }
  it { should be_file }
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  its('mode') { should cmp '0664' }
  its('owner') { should eq 'oracle' }
  its('group') { should eq 'dba' }
  its('content') { should match /inventory_loc/ }
  its('content') { should match /inst_group/ }
end

# Oracle Inventory Directory
describe file('/opt/oracle/oraInventory') do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0775' }
  its('owner') { should eq 'oracle' }
  its('group') { should eq 'dba' }
end

# Oracle User
describe user('oracle') do
  it { should exist }
  its('groups') { should include 'dba' }
  its('shell') { should eq '/bin/bash' }
  its('home') { should eq '/home/oracle' }
end

# Oracle Group
describe group('dba') do
  it { should exist }
end