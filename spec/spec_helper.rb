require 'chefspec'
require 'chefspec/berkshelf'
require 'support/constants'
require 'simplecov'

$LOAD_PATH.unshift File.absolute_path('libraries')

SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage 30
  maximum_coverage_drop 5
  coverage_dir 'test/coverage'
end

ChefSpec::Coverage.start!

RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks
  # config.cookbook_path = '/var/cookbooks'

  # Specify the path for Chef Solo to find roles
  # config.role_path = '/var/roles'

  # Specify the Chef log_level (default: :warn)
  config.log_level = :warn

  # Specify the path to a local JSON file with Ohai data
  # config.path = 'ohai.json'

  # Specify the operating platform to mock Ohai data from
  config.platform = 'centos'

  # Specify the operating version to mock Ohai data from
  config.version = '6.5'
end
