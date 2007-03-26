##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

# Add remote connection information to the Database Data_Systems Table 
# to hold linke to remote physical systems for element values
#
class AddDataSystemConnection < ActiveRecord::Migration

  def self.up
    add_column  :data_systems, "adapter", :string, :limit => 50, :default => "mysql", :null => false
    add_column  :data_systems, "host"   , :string, :limit => 50, :default => "localhost", :null => true
    add_column  :data_systems, "username", :string, :limit => 50, :default => "root", :null => true
    add_column  :data_systems, "password", :string, :limit => 50, :default => "", :null => true
    add_column  :data_systems, "database", :string, :limit => 50, :default => "", :null => true
  end

  def self.down
    remove_column :data_systems, "adapter"
    remove_column :data_systems, "host"
    remove_column :data_systems, "username"
    remove_column :data_systems, "password"
    remove_column :data_systems, "database"
  end
  
end