#
# Cookbook:: oracle-inventory-management
# Recipe:: default
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#
# This recipe creates the Oracle Inventory directory and configuration file,
# which are required for Oracle software installations.
#

Chef::Log.info('Oracle Inventory Management: Setup starting')

# Create the Oracle inventory group if enabled
if node['oracle']['inventory']['manage_users']
  group node['oracle']['inventory']['group'] do
    gid node['oracle']['inventory']['group_gid'] if node['oracle']['inventory']['group_gid']
    system true
    action :create
  end

  # Create the Oracle user account if enabled
  user node['oracle']['inventory']['user'] do
    uid node['oracle']['inventory']['user_uid'] if node['oracle']['inventory']['user_uid']
    gid node['oracle']['inventory']['group']
    shell node['oracle']['inventory']['user_shell']
    home node['oracle']['inventory']['user_home']
    system true
    manage_home true
    action :create
    password_lock node['oracle']['inventory']['lock_user']
  end
end

# Create the Oracle inventory directory with proper ownership/permissions
directory node['oracle']['inventory']['location'] do
  owner node['oracle']['inventory']['user']
  group node['oracle']['inventory']['group']
  recursive true
  mode node['oracle']['inventory']['dir_mode']
  action :create
end

# Create the Oracle inventory configuration file
template node['oracle']['inventory']['ora_inst_path'] do
  source 'orainst.loc.erb'
  owner node['oracle']['inventory']['user']
  group node['oracle']['inventory']['group']
  mode node['oracle']['inventory']['file_mode']
  variables(
    inventory_location: node['oracle']['inventory']['location'],
    group: node['oracle']['inventory']['group']
  )
  action :create
  sensitive true  # Don't show inventory details in logs
end

Chef::Log.info('Oracle Inventory Management: Setup completed successfully')
