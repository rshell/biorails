##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table "menu_items", :force => true do |t|
      t.column "parent_id", :integer
      t.column "name", :string, :default => "", :null => false
      t.column "label", :string, :default => "", :null => false
      t.column "seq", :integer
      t.column "controller_action_id", :integer
      t.column "content_page_id", :integer
    end
  
    add_index "menu_items", ["controller_action_id"], :name => "fk_menu_item_controller_action_id"
    add_index "menu_items", ["content_page_id"], :name => "fk_menu_item_content_page_id"
    add_index "menu_items", ["parent_id"], :name => "fk_menu_item_parent_id"
    
    execute "INSERT INTO `menu_items` VALUES (1,NULL,'home','Home',1,NULL,1)"
    execute "INSERT INTO `menu_items` VALUES (2,NULL,'contact_us','Contact Us',3,NULL,6)"
    execute "INSERT INTO `menu_items` VALUES (3,NULL,'admin','Administration',2,NULL,9)"
    execute "INSERT INTO `menu_items` VALUES (5,9,'setup/permissions','Permissions',3,4,NULL)"
    execute "INSERT INTO `menu_items` VALUES (6,9,'setup/roles','Roles',2,3,NULL)"
    execute "INSERT INTO `menu_items` VALUES (7,9,'setup/pages','Content Pages',5,8,NULL)"
    execute "INSERT INTO `menu_items` VALUES (8,9,'setup/controllers','Controllers / Actions',4,9,NULL)"
    execute "INSERT INTO `menu_items` VALUES (9,3,'setup','Setup',1,NULL,8)"
    execute "INSERT INTO `menu_items` VALUES (11,9,'setup/menus','Menu Editor',6,11,NULL)"
    execute "INSERT INTO `menu_items` VALUES (12,9,'setup/system_settings','System Settings',7,12,NULL)"
    execute "INSERT INTO `menu_items` VALUES (13,9,'setup/users','Users',1,15,NULL)"
    execute "INSERT INTO `menu_items` VALUES (14,2,'credits','Credits &amp; Licence',1,NULL,10)"

    execute "create view view_menu_items as \
        select  \
        	cast(menu_items.id as unsigned) as menu_item_id, \
        	menu_items.name as menu_item_name, \
        	menu_items.label as menu_item_label, \
        	menu_items.seq as menu_item_seq, \
        	menu_items.parent_id as menu_item_parent_id, \
        	view_controller_actions.site_controller_id, \
        	view_controller_actions.site_controller_name, \
        	view_controller_actions.id as controller_action_id, \
        	view_controller_actions.name as controller_action_name, \
        	content_pages.id as content_page_id, \
        	content_pages.name as content_page_name, \
        	content_pages.title as content_page_title, \
        	permissions.id as permission_id, \
        	permissions.name as permission_name \
        from menu_items \
        left outer join view_controller_actions \
        	on menu_items.controller_action_id = view_controller_actions.id \
        left outer join content_pages \
        	on menu_items.content_page_id = content_pages.id \
        	and menu_items.controller_action_id is Null \
        left outer join markup_styles \
        	on content_pages.markup_style_id = markup_styles.id \
        inner join permissions  \
        	on (coalesce(view_controller_actions.permission_id, content_pages.permission_id)) = permissions.id "

  end

  def self.down
    execute "drop view view_menu_items"
    drop_table :menu_items
  rescue
     nil
  end
end
