##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

#
# ok win prize as typo king should have called audit columns updated
# 
class ModifyProcessInstanceAudit < ActiveRecord::Migration
  def self.up
     rename_column :process_instances,:update_at,:updated_at
     rename_column :process_instances,:update_by,:updated_by
  end

  def self.down
     rename_column :process_instances,:updated_at,:update_at
     rename_column :process_instances,:updated_by,:update_by
  end
end
