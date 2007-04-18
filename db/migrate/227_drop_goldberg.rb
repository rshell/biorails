class DropGoldberg < ActiveRecord::Migration
  def self.up
   
    execute 'alter table batches drop FOREIGN KEY batches_compound_fk;'
    execute 'alter table content_pages drop FOREIGN KEY fk_content_page_markup_style_id;'
    execute 'alter table content_pages drop FOREIGN KEY fk_content_page_permission_id;'    
    execute 'alter table data_elements drop FOREIGN KEY data_element_fk2;'
    execute 'alter table data_environments drop FOREIGN KEY data_environments_fk1;'    
    execute 'alter table data_relations drop FOREIGN KEY data_relations_from_fk;'
    execute 'alter table data_relations drop FOREIGN KEY data_relations_role_fk;'
    execute 'alter table data_relations drop FOREIGN KEY data_relations_to_fk;'   
#    execute 'alter table data_environments drop FOREIGN KEY data_environments_fk1;'
    execute 'alter table dead_controller_actions drop FOREIGN KEY fk_controller_action_permission_id;'
    execute 'alter table dead_controller_actions drop FOREIGN KEY fk_controller_action_site_controller_id;'
    execute 'alter table dead_site_controllers drop FOREIGN KEY   fk_site_controller_permission_id;'  
    execute 'alter table menu_items drop FOREIGN KEY fk_menu_item_content_page_id;'
    execute 'alter table menu_items drop FOREIGN KEY fk_menu_item_controller_action_id;'
    execute 'alter table menu_items drop FOREIGN KEY fk_menu_item_parent_id;'  
    execute 'alter table roles drop FOREIGN KEY fk_role_default_page_id;'
    execute 'alter table roles drop FOREIGN KEY fk_role_parent_id;'   
    execute 'alter table roles_permissions drop FOREIGN KEY fk_roles_permission_permission_id;'
    execute 'alter table roles_permissions drop FOREIGN KEY fk_roles_permission_role_id;'    
    execute 'alter table users drop FOREIGN KEY fk_user_role_id;'
     
    drop_table :content_pages
    drop_table :dead_site_permissions     
    drop_table :dead_controller_actions
    drop_table :dead_site_controllers
    drop_table :dead_markup_styles
  end

  def self.down
  end
end
