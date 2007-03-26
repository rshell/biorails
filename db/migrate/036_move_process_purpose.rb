##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

##
# Rethink of text imformation with processes
# changed to only have one text field with definition and 
# moved purpose down to implementation as a standard operational procedure (how to use it!)
# 
class MoveProcessPurpose < ActiveRecord::Migration
  def self.up
     remove_column :process_definitions,:purpose
     add_column :process_instances,:how_to, :text
  end

  def self.down
     add_column :process_definitions,:purpose, :text
     remove_column :process_instances,:how_to
  end
end
