##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
##
#Change data format to have a solid fk link to data_type
#
class ModifyDataFormat < ActiveRecord::Migration

  def self.up
    add_column  :data_formats, "data_type_id", :integer, :null => true
    remove_column  :data_formats, "data_type"
  end

  def self.down
    add_column  :data_formats, "data_type", :string, :null => true
    remove_column  :data_formats, "data_type_id"
  end

end
