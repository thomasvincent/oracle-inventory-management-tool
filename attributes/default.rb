#
# Cookbook Name:: acx-oracle-inventory
# Attributes:: default
#
# Copyright (C) 2015 Acxiom Corporation
#
# All rights reserved - Do Not Redistribute
#

######################################################
# Group ownership of Oracle Inventory file
default['acx-oracle']['inventory']['group'] = 'dba'
# User ownership of Oracle Inventory file
default['acx-oracle']['inventory']['user'] = 'oracle'
# Oracle Inventory file location
default['acx-oracle']['inventory']['oraInst'] = '/etc/oraInst.loc'
# Oracle Inventory directory location
default['acx-oracle']['inventory']['location'] = '/opt/oracle/inventory'
