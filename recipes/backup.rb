#
# Cookbook:: oracle-inventory-management
# Recipe:: backup
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#
# This recipe creates backups of the Oracle inventory
#

Chef::Log.info('Oracle Inventory Management: Backup starting')

# Create backup directory
backup_dir = node['oracle']['inventory']['backup_dir'] || ::File.join(Chef::Config[:file_cache_path], 'oracle_inventory_backups')

directory backup_dir do
  owner node['oracle']['inventory']['user']
  group node['oracle']['inventory']['group']
  recursive true
  mode '0750'
  action :create
end

# Timestamp for the backup
backup_timestamp = Time.now.strftime('%Y%m%d%H%M%S')
backup_filename = "oracle_inventory_backup_#{backup_timestamp}.tar.gz"
backup_filepath = ::File.join(backup_dir, backup_filename)

# Get inventory location from oraInst.loc
inventory_location = inventory_location_from_file(node['oracle']['inventory']['ora_inst_path'])

if inventory_location && ::File.directory?(inventory_location)
  # Create a tar archive of the inventory
  execute 'backup_oracle_inventory' do
    command "tar -czf #{backup_filepath} -C #{::File.dirname(inventory_location)} #{::File.basename(inventory_location)}"
    user 'root'
    action :run
    not_if { ::File.exist?(backup_filepath) }
  end
  
  # Also backup the oraInst.loc file
  file ::File.join(backup_dir, "oraInst.loc_#{backup_timestamp}") do
    owner node['oracle']['inventory']['user']
    group node['oracle']['inventory']['group']
    mode '0640'
    content lazy { ::File.read(node['oracle']['inventory']['ora_inst_path']) }
    action :create
    only_if { ::File.exist?(node['oracle']['inventory']['ora_inst_path']) }
  end
  
  # Keep only a certain number of backups
  ruby_block 'cleanup_old_backups' do
    block do
      max_backups = node['oracle']['inventory']['max_backups'] || 10
      backups = Dir.glob(::File.join(backup_dir, 'oracle_inventory_backup_*.tar.gz')).sort
      
      if backups.size > max_backups
        backups_to_remove = backups[0...(backups.size - max_backups)]
        backups_to_remove.each do |old_backup|
          Chef::Log.info("Removing old Oracle inventory backup: #{old_backup}")
          ::File.unlink(old_backup)
        end
      end
    end
    action :run
    only_if { Dir.glob(::File.join(backup_dir, 'oracle_inventory_backup_*.tar.gz')).size > (node['oracle']['inventory']['max_backups'] || 10) }
  end
  
  Chef::Log.info("Oracle Inventory Management: Backup completed to #{backup_filepath}")
else
  Chef::Log.warn('Oracle Inventory Management: Backup skipped - inventory location not found')
end