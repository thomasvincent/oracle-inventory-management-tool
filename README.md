# acx-oracle-inventory
====================

The cookbook installs the central inventory file and the Oracle inventory directory (oraInventory) stores an inventory of all software installed on the system. The central inventory file and the Oracle inventory directory (oraInventory) is required and shared by all Oracle software installations on a single system. At this point this cookbook does not have the ability to remove the inventory for this reason.  All Oracle software installations rely on this directory. Do not delete this directory unless you have completely removed all Oracle software from the system

## Supported Platforms

* RHEL
* CentOS
* AWS

## Attributes

| Key | Type | Description | Default |
|`['acx-oracle']['inventory']['group']` | string | Group ownership of Oracle Inventory file | dba |
|`['acx-oracle']['inventory']['user']` | string | User ownership of Oracle Inventory file |oracle|
|`['acx-oracle']['inventory']['oraInst']` | string | Oracle Inventory file location | /etc/oraInst.loc |
|`['acx-oracle']['inventory']['oraInst']` | string | Oracle directory location | /opt/oracle/inventory |

## Usage

### acx-oracle-inventory::default

Include `acx-oracle-inventory` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[acx-oracle-inventory::default]"
  ]
}
```

## Contributing

1. Fork the repository on Stash
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Acxiom Corporation (<ops_platform@acxiom.com>)
