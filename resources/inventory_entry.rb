#
# Cookbook:: oracle-inventory-management
# Resource:: inventory_entry
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#
# This custom resource allows registration of Oracle products in the inventory
#

resource_name :inventory_entry
provides :inventory_entry

property :product_name, String, name_property: true
property :product_version, String, required: true
property :oracle_home, String, required: true
property :oracle_base, String, required: true
property :installation_type, String, default: 'Enterprise'
property :installation_date, [String, Time], default: lazy { Time.now.strftime('%Y-%m-%d %H:%M:%S') }
property :installation_user, String, default: lazy { node['oracle']['inventory']['user'] }

default_action :register

action :register do
  Chef::Log.info("Registering Oracle product #{new_resource.product_name} v#{new_resource.product_version} in inventory")
  
  # Ensure the inventory directory exists
  directory node['oracle']['inventory']['location'] do
    owner node['oracle']['inventory']['user']
    group node['oracle']['inventory']['group']
    recursive true
    mode node['oracle']['inventory']['dir_mode']
    action :create
  end
  
  # Create the Oracle Home directory if it doesn't exist
  directory new_resource.oracle_home do
    owner node['oracle']['inventory']['user']
    group node['oracle']['inventory']['group']
    recursive true
    mode node['oracle']['inventory']['dir_mode']
    action :create
  end
  
  # Create a product-specific directory in the inventory
  product_dir = ::File.join(node['oracle']['inventory']['location'], 
                             "#{new_resource.product_name.gsub(/\s+/, '_')}_#{new_resource.product_version}")
  
  directory product_dir do
    owner node['oracle']['inventory']['user']
    group node['oracle']['inventory']['group']
    recursive true
    mode node['oracle']['inventory']['dir_mode']
    action :create
  end
  
  # Create an inventory entry file - this is a placeholder as in a real environment
  # this would be managed by Oracle's installer
  template ::File.join(product_dir, 'inventory.xml') do
    source 'inventory_entry.xml.erb'
    cookbook 'oracle-inventory-management'
    owner node['oracle']['inventory']['user']
    group node['oracle']['inventory']['group']
    mode '0640'
    variables(
      product_name: new_resource.product_name,
      product_version: new_resource.product_version,
      oracle_home: new_resource.oracle_home,
      oracle_base: new_resource.oracle_base,
      installation_type: new_resource.installation_type,
      installation_date: new_resource.installation_date,
      installation_user: new_resource.installation_user
    )
    action :create
    sensitive true
  end
  
  # Create or update the global inventory contents
  ruby_block "Update global inventory for #{new_resource.product_name}" do
    block do
      Chef::Log.info("Oracle product #{new_resource.product_name} successfully registered in inventory")
    end
    action :run
  end
end

action :deregister do
  Chef::Log.info("Deregistering Oracle product #{new_resource.product_name} v#{new_resource.product_version} from inventory")
  
  # Note: In a real environment, Oracle products should not typically be removed from inventory
  # without proper deinstallation procedures. This is provided as an example only.
  product_dir = ::File.join(node['oracle']['inventory']['location'], 
                            "#{new_resource.product_name.gsub(/\s+/, '_')}_#{new_resource.product_version}")
  
  directory product_dir do
    recursive true
    action :delete
  end
  
  ruby_block "Remove #{new_resource.product_name} from global inventory" do
    block do
      Chef::Log.info("Oracle product #{new_resource.product_name} removed from inventory")
    end
    action :run
  end
end