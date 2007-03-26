##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddDataElementFlag < ActiveRecord::Migration
  def self.up
    add_column  :data_elements, "estimated_count", :integer
    add_column  :data_elements, "type", :string
  end

  def self.down
    remove_column  :data_elements, "estimated_count"
    remove_column  :data_elements, "type"
  end
end
