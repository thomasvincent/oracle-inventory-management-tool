#
# Cookbook:: oracle-inventory-management
# Attributes:: default
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#

# Oracle Inventory Ownership
#
# Group ownership of Oracle Inventory file and directory
# This is typically 'dba' or 'oinstall' depending on your organization's standards
default['oracle']['inventory']['group'] = 'dba'

# User ownership of Oracle Inventory file
# This is typically 'oracle' but may be different in your environment
default['oracle']['inventory']['user'] = 'oracle'

# Oracle Inventory File Configuration
#
# Oracle Inventory file location
# This is typically '/etc/oraInst.loc' on Linux systems
default['oracle']['inventory']['ora_inst_path'] = '/etc/oraInst.loc'

# Oracle Inventory directory location
# This is typically '/opt/oracle/oraInventory' or '/u01/app/oraInventory'
default['oracle']['inventory']['location'] = '/opt/oracle/oraInventory'

# Oracle Inventory File Permissions
#
# Permissions for the inventory directory
default['oracle']['inventory']['dir_mode'] = '0775'

# Permissions for the inventory file
default['oracle']['inventory']['file_mode'] = '0664'

# User and Group Management
#
# Whether to create the oracle user and group if they don't exist
default['oracle']['inventory']['manage_users'] = true

# UID for the oracle user if it's being created
default['oracle']['inventory']['user_uid'] = nil

# GID for the oracle group if it's being created
default['oracle']['inventory']['group_gid'] = nil

# System Accounts Settings
# 
# Whether oracle user should have login shell access
default['oracle']['inventory']['user_shell'] = '/bin/bash'

# Home directory for oracle user
default['oracle']['inventory']['user_home'] = '/home/oracle'

# Oracle User Password Management
# 
# Whether to lock the oracle user password (security best practice)
default['oracle']['inventory']['lock_user'] = true

# Backup Configuration
#
# Directory to store Oracle inventory backups
# If not specified, backups will go to Chef's cache directory
default['oracle']['inventory']['backup_dir'] = nil

# Maximum number of inventory backups to keep
default['oracle']['inventory']['max_backups'] = 10

# Schedule automatic backups via cron (true/false)
default['oracle']['inventory']['scheduled_backups'] = false

# Cron schedule for backups (if enabled)
default['oracle']['inventory']['backup_schedule']['minute'] = '0'
default['oracle']['inventory']['backup_schedule']['hour'] = '2'
default['oracle']['inventory']['backup_schedule']['day'] = '*'
default['oracle']['inventory']['backup_schedule']['month'] = '*'
default['oracle']['inventory']['backup_schedule']['weekday'] = '0'

# Validation and Security
#
# Enable enhanced security checks for inventory files
default['oracle']['inventory']['enhanced_security'] = true

# Validate inventory XML structure (requires libxml)
default['oracle']['inventory']['validate_xml'] = false

# Enable audit logging of inventory changes
default['oracle']['inventory']['audit_changes'] = true

# Audit log path
default['oracle']['inventory']['audit_log'] = '/var/log/oracle/inventory_audit.log'
