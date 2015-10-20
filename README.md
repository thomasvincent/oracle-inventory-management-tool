# acx-oracle-inventory

TODO: Enter the cookbook description here.

## Supported Platforms

* RHEL
* CentOS
* AWS

## Attributes

|Key|Type|Description|Default|
|---|:-:|---|---|
|`['acx-oracle-inventory']['bacon']`|Boolean|whether to include bacon|true|

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
