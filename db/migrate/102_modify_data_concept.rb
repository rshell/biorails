##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class ModifyDataConcept < ActiveRecord::Migration
  def self.up
    add_column  :data_concepts, "type", :string,:default=>'DataConcept', :null => false
  end

  def self.down
    remove_column  :data_concepts, "type"
  end
end
