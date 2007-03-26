##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
##
# After some debate decided humans cant write regex expressions. Changed to use table of precooked 
# regex strings!
# 
class ModParameterDataFormats < ActiveRecord::Migration
  def self.up
    add_column  :study_parameters, "data_format_id", :integer, :null => true
    remove_column  :study_parameters, "format_regex"
    add_column  :parameters, "data_format_id", :integer, :null => true
    remove_column  :parameters, "format_regex"
  end

  def self.down
    remove_column  :study_parameters, "data_format_id"
    add_column  :study_parameters, "format_regex", :string, :null => true
    remove_column  :parameters, "data_format_id"
    add_column  :parameters, "format_regex", :string, :null => true
  end
end
