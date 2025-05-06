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
property :oracle_version, String, default: lazy { node['oracle']['default_version'] }
property :installation_type, String, default: 'EE'
property :installation_edition, String
property :installation_date, [String, Time], default: lazy { Time.now.strftime('%Y-%m-%d %H:%M:%S') }
property :installation_user, String, default: lazy { node['oracle']['inventory']['user'] }
property :components, Array, default: []
property :is_rac, [true, false], default: false
property :rac_nodes, Array, default: []
property :grid_home, String

default_action :register

action :register do
  # Resolve the installation edition based on installation_type if not explicitly set
  installation_edition = if new_resource.installation_edition
                           new_resource.installation_edition
                         elsif node['oracle']['versions'][new_resource.oracle_version] &&
                               node['oracle']['versions'][new_resource.oracle_version]['install_type'][new_resource.installation_type]
                           node['oracle']['versions'][new_resource.oracle_version]['install_type'][new_resource.installation_type]
                         else
                           "#{new_resource.installation_type} Edition"
                         end

  Chef::Log.info("Registering Oracle product #{new_resource.product_name} v#{new_resource.product_version} (#{installation_edition}) in inventory")
  
  # Validate that the Oracle version is supported
  raise "Unsupported Oracle version: #{new_resource.oracle_version}" unless node['oracle']['versions'][new_resource.oracle_version]
  
  # Ensure the inventory directory exists
  directory node['oracle']['inventory']['location'] do
    owner node['oracle']['inventory']['user']
    group node['oracle']['inventory']['group']
    recursive true
    mode node['oracle']['inventory']['dir_mode']
    action :create
  end
  
  # Create the Oracle Base directory if it doesn't exist
  directory new_resource.oracle_base do
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
  
  # If this is RAC, create Grid Home directory if provided
  if new_resource.is_rac && new_resource.grid_home
    directory new_resource.grid_home do
      owner node['oracle']['inventory']['user']
      group node['oracle']['inventory']['group']
      recursive true
      mode node['oracle']['inventory']['dir_mode']
      action :create
    end
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
  
  # Create an inventory entry file
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
      oracle_version: new_resource.oracle_version,
      installation_type: new_resource.installation_type,
      installation_edition: installation_edition,
      installation_date: new_resource.installation_date,
      installation_user: new_resource.installation_user,
      components: new_resource.components,
      is_rac: new_resource.is_rac,
      rac_nodes: new_resource.rac_nodes,
      grid_home: new_resource.grid_home,
      hostname: node['hostname']
    )
    action :create
    sensitive true
  end
  
  # For RAC configurations, create node-specific files
  if new_resource.is_rac && !new_resource.rac_nodes.empty?
    new_resource.rac_nodes.each do |rac_node|
      template ::File.join(product_dir, "#{rac_node}_inventory.xml") do
        source 'rac_node_inventory.xml.erb'
        cookbook 'oracle-inventory-management'
        owner node['oracle']['inventory']['user']
        group node['oracle']['inventory']['group']
        mode '0640'
        variables(
          product_name: new_resource.product_name,
          product_version: new_resource.product_version,
          oracle_home: new_resource.oracle_home,
          oracle_base: new_resource.oracle_base,
          oracle_version: new_resource.oracle_version,
          installation_type: new_resource.installation_type,
          installation_edition: installation_edition,
          node_name: rac_node,
          grid_home: new_resource.grid_home
        )
        action :create
        sensitive true
      end
    end
  end

  # Create or update the Oracle Components file if components are specified
  if !new_resource.components.empty?
    template ::File.join(product_dir, 'components.xml') do
      source 'components.xml.erb'
      cookbook 'oracle-inventory-management'
      owner node['oracle']['inventory']['user']
      group node['oracle']['inventory']['group']
      mode '0640'
      variables(
        product_name: new_resource.product_name,
        product_version: new_resource.product_version,
        components: new_resource.components
      )
      action :create
      sensitive true
    end
  end
  
  # Log entry for audit purposes
  if node['oracle']['inventory']['audit_changes']
    log_dir = ::File.dirname(node['oracle']['inventory']['audit_log'])
    
    directory log_dir do
      owner node['oracle']['inventory']['user']
      group node['oracle']['inventory']['group']
      recursive true
      mode '0750'
      action :create
    end
    
    file node['oracle']['inventory']['audit_log'] do
      content lazy {
        message = "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} - REGISTER - Oracle product #{new_resource.product_name} " \
                  "v#{new_resource.product_version} (#{installation_edition}) registered by Chef as user #{node['oracle']['inventory']['user']}\n"
        if ::File.exist?(node['oracle']['inventory']['audit_log'])
          ::File.read(node['oracle']['inventory']['audit_log']) + message
        else
          message
        end
      }
      owner node['oracle']['inventory']['user']
      group node['oracle']['inventory']['group']
      mode '0640'
      action :create
    end
  end
  
  # Notify success
  ruby_block "Oracle product #{new_resource.product_name} successfully registered" do
    block do
      Chef::Log.info("Oracle product #{new_resource.product_name} v#{new_resource.product_version} (#{installation_edition}) successfully registered in inventory")
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