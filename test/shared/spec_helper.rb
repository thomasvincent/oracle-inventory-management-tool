require 'serverspec'
#required by serverspec
set : :backend, :exec

Rspec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin:/bin'
  end
end