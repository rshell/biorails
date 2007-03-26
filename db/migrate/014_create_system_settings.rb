##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class CreateSystemSettings < ActiveRecord::Migration
  def self.up
    create_table "system_settings", :force => true do |t|
      t.column "site_name", :string, :default => "", :null => false
      t.column "site_subtitle", :string
      t.column "footer_message", :string, :default => ""
      t.column "public_role_id", :integer, :default => 0, :null => false
      t.column "session_timeout", :integer, :default => 0, :null => false
      t.column "default_markup_style_id", :integer, :default => 0
      t.column "site_default_page_id", :integer, :default => 0, :null => false
      t.column "not_found_page_id", :integer, :default => 0, :null => false
      t.column "permission_denied_page_id", :integer, :default => 0, :null => false
      t.column "session_expired_page_id", :integer, :default => 0, :null => false
      t.column "menu_depth", :integer, :default => 0, :null => false
    end
  
    add_index "system_settings", ["public_role_id"], :name => "fk_system_settings_public_role_id"
    add_index "system_settings", ["site_default_page_id"], :name => "fk_system_settings_site_default_page_id"
    add_index "system_settings", ["not_found_page_id"], :name => "fk_system_settings_not_found_page_id"
    add_index "system_settings", ["permission_denied_page_id"], :name => "fk_system_settings_permission_denied_page_id"
    add_index "system_settings", ["session_expired_page_id"], :name => "fk_system_settings_session_expired_page_id"

    execute "INSERT INTO `system_settings` VALUES (1,'BioRails','A website development tool for Ruby on Rails','A <a href=\"http://goldberg.rubyforge.org\">Goldberg</a> site',1,7200,1,1,3,4,2,3)"

    execute "create view view_controller_actions as  select controller_actions.id, \
            site_controllers.id as site_controller_id, \
            site_controllers.name as site_controller_name, \
            controller_actions.name,  Coalesce(controller_actions.permission_id, \
             site_controllers.permission_id) as permission_id from site_controllers \
             inner join controller_actions on site_controllers.id = controller_actions.site_controller_id "

  end

  def self.down
      execute "drop view view_controller_actions"
      drop_table :system_settings
  rescue
     nil
  end
end
