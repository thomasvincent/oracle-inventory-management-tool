#
# Cookbook:: oracle-inventory-management
# Attributes:: oracle_versions
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#

# This file defines attributes related to Oracle database versions
# and their specific inventory requirements

# Oracle 19c (19.3.0) - Current Long Term Release
default['oracle']['versions']['19c']['full_version'] = '19.3.0.0.0'
default['oracle']['versions']['19c']['short_version'] = '19.3'
default['oracle']['versions']['19c']['install_type'] = {
  'EE' => 'Enterprise Edition',
  'SE2' => 'Standard Edition 2',
  'XE' => 'Express Edition'
}
default['oracle']['versions']['19c']['default_oracle_base'] = '/u01/app/oracle'
default['oracle']['versions']['19c']['default_oracle_home'] = '/u01/app/oracle/product/19.0.0/dbhome_1'

# Oracle 21c (21.3.0) - Innovation Release
default['oracle']['versions']['21c']['full_version'] = '21.3.0.0.0'
default['oracle']['versions']['21c']['short_version'] = '21.3'
default['oracle']['versions']['21c']['install_type'] = {
  'EE' => 'Enterprise Edition',
  'SE2' => 'Standard Edition 2',
  'XE' => 'Express Edition'
}
default['oracle']['versions']['21c']['default_oracle_base'] = '/u01/app/oracle'
default['oracle']['versions']['21c']['default_oracle_home'] = '/u01/app/oracle/product/21.0.0/dbhome_1'

# Oracle 18c (18.3.0) - Extended Support through 2024
default['oracle']['versions']['18c']['full_version'] = '18.3.0.0.0'
default['oracle']['versions']['18c']['short_version'] = '18.3'
default['oracle']['versions']['18c']['install_type'] = {
  'EE' => 'Enterprise Edition',
  'SE2' => 'Standard Edition 2',
  'XE' => 'Express Edition'
}
default['oracle']['versions']['18c']['default_oracle_base'] = '/u01/app/oracle'
default['oracle']['versions']['18c']['default_oracle_home'] = '/u01/app/oracle/product/18.0.0/dbhome_1'

# Oracle 12c Release 2 (12.2.0) - Extended Support through 2023
default['oracle']['versions']['12.2']['full_version'] = '12.2.0.1.0'
default['oracle']['versions']['12.2']['short_version'] = '12.2'
default['oracle']['versions']['12.2']['install_type'] = {
  'EE' => 'Enterprise Edition',
  'SE2' => 'Standard Edition 2'
}
default['oracle']['versions']['12.2']['default_oracle_base'] = '/u01/app/oracle'
default['oracle']['versions']['12.2']['default_oracle_home'] = '/u01/app/oracle/product/12.2.0/dbhome_1'

# Oracle 12c Release 1 (12.1.0) - Extended Support through 2022
default['oracle']['versions']['12.1']['full_version'] = '12.1.0.2.0'
default['oracle']['versions']['12.1']['short_version'] = '12.1'
default['oracle']['versions']['12.1']['install_type'] = {
  'EE' => 'Enterprise Edition',
  'SE2' => 'Standard Edition 2',
  'SE' => 'Standard Edition'
}
default['oracle']['versions']['12.1']['default_oracle_base'] = '/u01/app/oracle'
default['oracle']['versions']['12.1']['default_oracle_home'] = '/u01/app/oracle/product/12.1.0/dbhome_1'

# Oracle 11g Release 2 (11.2.0) - Extended Support through 2021
default['oracle']['versions']['11.2']['full_version'] = '11.2.0.4.0'
default['oracle']['versions']['11.2']['short_version'] = '11.2'
default['oracle']['versions']['11.2']['install_type'] = {
  'EE' => 'Enterprise Edition',
  'SE' => 'Standard Edition'
}
default['oracle']['versions']['11.2']['default_oracle_base'] = '/u01/app/oracle'
default['oracle']['versions']['11.2']['default_oracle_home'] = '/u01/app/oracle/product/11.2.0/dbhome_1'

# Oracle RAC Specific paths
default['oracle']['rac']['grid_base'] = '/u01/app/grid'
default['oracle']['rac']['grid_home'] = {
  '19c' => '/u01/app/19.3.0/grid',
  '21c' => '/u01/app/21.3.0/grid',
  '18c' => '/u01/app/18.3.0/grid',
  '12.2' => '/u01/app/12.2.0/grid',
  '12.1' => '/u01/app/12.1.0/grid',
  '11.2' => '/u01/app/11.2.0/grid'
}

# Default Oracle version to use if not specified
default['oracle']['default_version'] = '19c'