# == Schema Information
# Schema version: 123
#
# Table name: tmp_data
#
#  id :integer(10)   not null, primary key
#

# == Schema Information
# Schema version: 111
#
# Table name: tmp_data
#
#  id :integer(10)   not null, primary key
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

##
# Utiltiy class used from dynamic linkage to a remote schema.
# In this case the table_name and connection are changed to provide a 
# temporary mapping to get a list of Data Values in a DataElement.
# 
class DataValue < ActiveRecord::Base 
set_table_name 'tmp_data'
end

