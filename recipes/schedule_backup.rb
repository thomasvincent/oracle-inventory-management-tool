#
# Cookbook:: oracle-inventory-management
# Recipe:: schedule_backup
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#
# This recipe schedules regular Oracle inventory backups via cron
#

# Only set up scheduled backups if enabled
if node['oracle']['inventory']['scheduled_backups']
  Chef::Log.info('Oracle Inventory Management: Setting up scheduled backups')
  
  # Create log directory if audit logging is enabled
  if node['oracle']['inventory']['audit_changes']
    log_dir = ::File.dirname(node['oracle']['inventory']['audit_log'])
    
    directory log_dir do
      owner node['oracle']['inventory']['user']
      group node['oracle']['inventory']['group']
      recursive true
      mode '0750'
      action :create
    end
  end
  
  # Create wrapper script for the backup
  cookbook_file '/usr/local/bin/oracle_inventory_backup.sh' do
    source 'oracle_inventory_backup.sh'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
  
  # Set up cron job for regular backups
  cron 'oracle_inventory_backup' do
    minute node['oracle']['inventory']['backup_schedule']['minute']
    hour node['oracle']['inventory']['backup_schedule']['hour']
    day node['oracle']['inventory']['backup_schedule']['day']
    month node['oracle']['inventory']['backup_schedule']['month']
    weekday node['oracle']['inventory']['backup_schedule']['weekday']
    command "/usr/local/bin/oracle_inventory_backup.sh #{node['oracle']['inventory']['ora_inst_path']} #{node['oracle']['inventory']['backup_dir'] || ::File.join(Chef::Config[:file_cache_path], 'oracle_inventory_backups')} #{node['oracle']['inventory']['max_backups']}"
    user 'root'
    action :create
  end
  
  Chef::Log.info('Oracle Inventory Management: Scheduled backups configured')
else
  Chef::Log.info('Oracle Inventory Management: Scheduled backups not enabled')
  
  # Remove cron job if it exists but is disabled
  cron 'oracle_inventory_backup' do
    action :delete
  end
end