name 'oracle-inventory-management'
maintainer 'Thomas Vincent'
maintainer_email 'info@thomasvincent.xyz'
license 'Apache-2.0'
description 'Installs and configures Oracle inventory file and directory'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.0'
chef_version '>= 14.0'
issues_url 'https://github.com/thomasvincent/oracle-inventory-management-tool/issues'
source_url 'https://github.com/thomasvincent/oracle-inventory-management-tool'

supports 'redhat', '>= 7.0'
supports 'centos', '>= 7.0'
supports 'oracle', '>= 7.0'
supports 'amazon', '>= 2.0'

# Dependencies
depends 'compat_resource', '>= 12.14.7'
