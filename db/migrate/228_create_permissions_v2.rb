##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreatePermissionsV2 < ActiveRecord::Migration
  def self.up
    create_table "permissions", :force => true do |t|
      t.column "checked", :boolean, :default => false, :null => false
      t.column "subject", :string, :default => "", :null => false
      t.column "action", :string, :default => "", :null => false
    end
  end

  def self.down
    drop_table :permissions
  end
end
