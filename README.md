# Oracle Inventory Management

[![Chef Cookbook](https://img.shields.io/cookbook/v/oracle-inventory-management.svg)](https://supermarket.chef.io/cookbooks/oracle-inventory-management)
[![Build Status](https://github.com/thomasvincent/oracle-inventory-management-tool/actions/workflows/ci.yml/badge.svg)](https://github.com/thomasvincent/oracle-inventory-management-tool/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

An enterprise-grade Chef cookbook that manages the Oracle central inventory file and directory structure. The Oracle inventory is required for all Oracle software installations, and this cookbook ensures it's properly configured according to best practices.

## Overview

The Oracle Inventory is a crucial component of Oracle software installations, storing metadata about all Oracle products installed on a system. This cookbook:

- Creates and manages the Oracle inventory configuration file (`oraInst.loc`)
- Sets up the Oracle inventory directory with correct permissions and ownership
- Provides custom resources for managing individual Oracle product entries
- Implements automated backups and recovery
- Ensures security best practices for inventory management
- Includes comprehensive audit logging and monitoring

## Requirements

### Platforms

- RHEL 7+
- CentOS 7+
- Oracle Linux 7+
- Amazon Linux 2+

### Chef

- Chef 14.0 or later

### Cookbooks

- `compat_resource` (>= 12.14.7)

## Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `node['oracle']['inventory']['group']` | String | Group ownership of Oracle Inventory | `'dba'` |
| `node['oracle']['inventory']['user']` | String | User ownership of Oracle Inventory | `'oracle'` |
| `node['oracle']['inventory']['ora_inst_path']` | String | Oracle Inventory file location | `'/etc/oraInst.loc'` |
| `node['oracle']['inventory']['location']` | String | Oracle Inventory directory location | `'/opt/oracle/oraInventory'` |
| `node['oracle']['inventory']['dir_mode']` | String | Permissions for the inventory directory | `'0775'` |
| `node['oracle']['inventory']['file_mode']` | String | Permissions for the inventory file | `'0664'` |
| `node['oracle']['inventory']['manage_users']` | Boolean | Whether to create the oracle user and group | `true` |
| `node['oracle']['inventory']['user_uid']` | Integer | UID for the oracle user | `nil` |
| `node['oracle']['inventory']['group_gid']` | Integer | GID for the oracle group | `nil` |
| `node['oracle']['inventory']['user_shell']` | String | Shell for oracle user | `'/bin/bash'` |
| `node['oracle']['inventory']['user_home']` | String | Home directory for oracle user | `'/home/oracle'` |
| `node['oracle']['inventory']['lock_user']` | Boolean | Whether to lock the oracle user password | `true` |
| `node['oracle']['inventory']['backup_dir']` | String | Directory to store backups | `nil` |
| `node['oracle']['inventory']['max_backups']` | Integer | Maximum number of backups to keep | `10` |
| `node['oracle']['inventory']['scheduled_backups']` | Boolean | Schedule automatic backups via cron | `false` |
| `node['oracle']['inventory']['backup_schedule']` | Hash | Cron schedule for backups | Various defaults |
| `node['oracle']['inventory']['enhanced_security']` | Boolean | Enable enhanced security checks | `true` |
| `node['oracle']['inventory']['validate_xml']` | Boolean | Validate inventory XML structure | `false` |
| `node['oracle']['inventory']['audit_changes']` | Boolean | Enable audit logging of changes | `true` |
| `node['oracle']['inventory']['audit_log']` | String | Path to audit log file | `'/var/log/oracle/inventory_audit.log'` |

See `attributes/default.rb` for more details.

## Recipes

### default

Sets up the Oracle inventory directory and configuration file with proper ownership and permissions.

### backup

Creates a backup of the Oracle inventory for disaster recovery purposes.

### schedule_backup

Sets up automated backups of the Oracle inventory using cron.

## Custom Resources

### inventory_entry

Registers an Oracle product with the central inventory.

#### Properties

- `product_name` - Name of the Oracle product (defaults to resource name)
- `product_version` - Version of the Oracle product (required)
- `oracle_home` - Oracle home directory path (required)
- `oracle_base` - Oracle base directory path (required)
- `installation_type` - Type of Oracle installation (default: 'Enterprise')
- `installation_date` - Date of installation (default: current time)
- `installation_user` - User who performed the installation (default: oracle user from attributes)

#### Actions

- `:register` - Register the product in the inventory (default)
- `:deregister` - Remove the product from the inventory

#### Examples

```ruby
# Register an Oracle database installation
inventory_entry 'Oracle Database' do
  product_version '19.0.0.0.0'
  oracle_home '/u01/app/oracle/product/19.0.0/dbhome_1'
  oracle_base '/u01/app/oracle'
  installation_type 'EE'
  action :register
end
```

## Usage

### Basic Usage

Include `oracle-inventory-management` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[oracle-inventory-management::default]"
  ]
}
```

### Using with Oracle Database Installation

First set up the inventory, then install Oracle database:

```ruby
include_recipe 'oracle-inventory-management::default'

# Your Oracle database installation code here
# ...

# Register the database in the inventory
inventory_entry 'Oracle Database' do
  product_version '19.0.0.0.0'
  oracle_home '/u01/app/oracle/product/19.0.0/dbhome_1'
  oracle_base '/u01/app/oracle'
end

# Set up automated backups
include_recipe 'oracle-inventory-management::schedule_backup'
```

## How It Works

### Inventory Structure

The Oracle Inventory consists of:

1. **oraInst.loc file** - Usually located at `/etc/oraInst.loc`, this file points to the inventory directory and defines the group ownership
2. **Inventory directory** - Contains XML files and other metadata about Oracle product installations

### Workflow

1. The cookbook first creates the Oracle user and group (if enabled)
2. It then creates the inventory directory with proper permissions
3. The oraInst.loc file is created to point to this directory
4. Additional features like backups can be configured as needed

## Enterprise Features

### Automated Backups

The cookbook includes comprehensive backup capabilities:

- On-demand backups via the `backup` recipe
- Scheduled backups via cron
- Rotation of backup files to manage disk space
- Backup verification

### Security

Security best practices implemented:

- Proper file and directory permissions
- User account lockdown options
- Enhanced security checks for inventory files
- Audit logging of all changes

### Monitoring

The cookbook produces detailed logs that can be integrated with enterprise monitoring solutions:

- Chef logs for setup and configuration
- Backup operation logs
- Audit logs for inventory changes

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Implement your changes
4. Run tests (`kitchen test`)
5. Commit your changes (`git commit -am 'Add new feature'`)
6. Push to the branch (`git push origin feature/new-feature`)
7. Create a new Pull Request

## Testing

```bash
# Run all tests
kitchen test

# Unit tests only
rake spec

# Linting
rake style

# Integration tests
kitchen verify
```

## License and Author

- Author: Thomas Vincent (<info@thomasvincent.xyz>)

```text
Copyright 2023, Thomas Vincent

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```