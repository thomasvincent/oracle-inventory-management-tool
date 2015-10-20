# rubocop:disable Style/SingleSpaceBeforeFirstArg
name             'acx-oracle-inventory'
maintainer       'Acxiom Corporation'
maintainer_email 'ops_platform@acxiom.com'
license          'all_rights'
description      'Installs/Configures acx-oracle-inventory'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

%w(
  redhat
  centos
).each do |os|
  supports os
end

{
}.each do |dependency, version|
  depends dependency, version
end
