##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

##
# ok thinking about user data entry of Parameter need a few rules
#
class ModifyParameters < ActiveRecord::Migration
  def self.up
    add_column  :parameters, "mandatory", :string, :null => true, :default => "N"
    add_column  :parameters, "default_value", :string, :null => true
    add_column  :parameters, "format_regex", :string, :null => true
    add_column  :parameters, "data_type", :string, :null => true
  end

  def self.down
    remove_column  :parameters, "mandatory"
    remove_column  :parameters, "default_value"
    remove_column  :parameters, "format_regex"
    remove_column  :parameters, "data_type"
  end
end
