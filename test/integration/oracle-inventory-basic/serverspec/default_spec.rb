require 'serverspec'

set :backend, :exec

describe file('/etc/oraInst.loc') do
  it { should contain '/opt/oracle']
  it { should be_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'dba' }
  it should be_mode 754 }
end

describe file('/opt/oracle') do
  it { should be_directory }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'dba' }
  it should be_mode 754}
end