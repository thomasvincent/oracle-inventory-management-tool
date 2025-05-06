#
# Cookbook:: oracle-inventory-management
# Library:: inventory_helper
#
# Copyright:: 2023, Thomas Vincent, Apache-2.0
#
# Helper methods for Oracle inventory management
#

module OracleInventoryManagement
  module InventoryHelper
    # Parse the oraInst.loc file to get inventory location
    def inventory_location_from_file(ora_inst_path = '/etc/oraInst.loc')
      return nil unless ::File.exist?(ora_inst_path)
      
      inventory_loc = nil
      ::File.open(ora_inst_path, 'r') do |file|
        file.each_line do |line|
          if line.start_with?('inventory_loc=')
            inventory_loc = line.split('=', 2)[1].strip
            break
          end
        end
      end
      
      inventory_loc
    end
    
    # Parse the oraInst.loc file to get inventory group
    def inventory_group_from_file(ora_inst_path = '/etc/oraInst.loc')
      return nil unless ::File.exist?(ora_inst_path)
      
      inst_group = nil
      ::File.open(ora_inst_path, 'r') do |file|
        file.each_line do |line|
          if line.start_with?('inst_group=')
            inst_group = line.split('=', 2)[1].strip
            break
          end
        end
      end
      
      inst_group
    end
    
    # Check if oraInst.loc file exists and is valid
    def valid_inventory_file?(ora_inst_path = '/etc/oraInst.loc')
      return false unless ::File.exist?(ora_inst_path)
      
      # Check file permissions
      file_stat = ::File.stat(ora_inst_path)
      return false unless file_stat.mode.to_s(8)[-3..-1].to_i <= 664
      
      # Check file contents
      has_inventory_loc = false
      has_inst_group = false
      
      ::File.open(ora_inst_path, 'r') do |file|
        file.each_line do |line|
          has_inventory_loc = true if line.start_with?('inventory_loc=')
          has_inst_group = true if line.start_with?('inst_group=')
        end
      end
      
      has_inventory_loc && has_inst_group
    end
    
    # Get a list of registered Oracle homes from inventory
    def get_oracle_homes(inventory_loc = nil)
      inventory_loc ||= inventory_location_from_file
      return [] unless inventory_loc && ::File.directory?(inventory_loc)
      
      # In a real implementation, this would parse the inventory XML files
      # This is a simplified implementation for demo purposes
      oracle_homes = []
      
      Dir.glob("#{inventory_loc}/*_*/inventory.xml").each do |inventory_file|
        # Parse the inventory file (simplified)
        oracle_home = nil
        product_name = nil
        
        # Simple XML parsing without loading additional gems
        ::File.open(inventory_file, 'r') do |file|
          file.each_line do |line|
            if line =~ /HOME NAME="([^"]+)" LOC="([^"]+)"/
              product_name = Regexp.last_match(1)
              oracle_home = Regexp.last_match(2)
              break if product_name && oracle_home
            end
          end
        end
        
        oracle_homes << { name: product_name, home: oracle_home } if product_name && oracle_home
      end
      
      oracle_homes
    end
  end
end

Chef::Resource.include(OracleInventoryManagement::InventoryHelper)
Chef::Recipe.include(OracleInventoryManagement::InventoryHelper)