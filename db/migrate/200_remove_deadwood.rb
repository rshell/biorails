###
# This rename all unused tables to dead_xxxxxxx to that they can easy be removed by the 
# DBA at a later stage. (Simply deleting them makes rollback hell and unsafe.
# 
class RemoveDeadwood < ActiveRecord::Migration
  def self.up
    rename_table :site_controllers, :dead_site_controllers  
    rename_table :controller_actions, :dead_controller_actions
    rename_table :markup_styles, :dead_markup_styles
    rename_table :permissions, :dead_site_permissions 
    rename_table :system_settings, :dead_system_settings
    rename_table :engine_schema_info, :dead_engine_schema_info
  end

  def self.down
    rename_table :dead_site_controllers,:site_controllers  
    rename_table :dead_controller_actions,:controller_actions
    rename_table :dead_markup_styles,:markup_styles
    rename_table :dead__permissions,:permissions 
    rename_table :dead_system_settings,:system_settings
    rename_table :dead_engine_schema_info,:engine_schema_info 
  end
end
