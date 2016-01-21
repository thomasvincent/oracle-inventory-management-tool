#
# Cookbook Name:: acx-oracle-inventory
# Recipe:: default
#
# Copyright (C) 2015 Acxiom Corporation
#
# All rights reserved - Do Not Redistribute
#
################################################################################
# TODO: Enter the recipe description here.
################################################################################

Chef::Log.info('{acx-oracle-inventory->default} - start')

group node['acx-oracle']['inventory']['user'] do
  gid node['oracle']['inventory']['group']
end

directory node['acx-oracle']['inventory']['location'] do
  owner node['acx-oracle']['inventory']['user']
  group node['acx-oracle']['inventory']['group']
  recursive true
  mode 00775
end

template node['acx-oracle']['inventory']['oraInst'] do
  mode 00774
  source 'oraInst.loc.erb'
  user node['acx-oracle']['inventory']['user']
  group node['acx-oracle']['inventory']['group']
  variables(
      inventory_location: node['acx-oracle']['inventory']['location'],
      group: node['acx-oracle']['inventory']['group']
  )
end

Chef::Log.info('{acx-oracle-inventory->default} - end')
