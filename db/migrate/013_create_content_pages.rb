##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class CreateContentPages < ActiveRecord::Migration
  def self.up
    
    create_table "content_pages", :force => true do |t|
      t.column "title", :string
      t.column "name", :string, :default => "", :null => false
      t.column "markup_style_id", :integer
      t.column "content", :text
      t.column "permission_id", :integer, :default => 0, :null => false
      t.column "created_at",   :datetime,  :null => false, :default =>0
      t.column "updated_at",   :datetime,  :null => false, :default =>0
    end
    
    add_index "content_pages", ["permission_id"], :name => "fk_content_page_permission_id"
    add_index "content_pages", ["markup_style_id"], :name => "fk_content_page_markup_style_id"

    execute "INSERT INTO `content_pages` VALUES (1,'Home Page','home',1,'h1. Welcome to Goldberg!\r\n\r\nLooks like you have succeeded in getting Goldberg up and running.  Now you will probably want to customise your site.\r\n\r\n*Very important:* The default login for the administrator is \"admin\", password \"admin\".  You must change that before you make your site public!\r\n\r\nh2. Administering the Site\r\n\r\nAt the login prompt, enter an administrator username and password.  The top menu should change: a new item called \"Administration\" will appear.  Go there for further details.\r\n\r\n\r\n',3,'2006-06-11 14:31:56','2006-10-01 13:43:39')"
    execute "INSERT INTO `content_pages` VALUES (2,'Session Expired','expired',1,'h1. Session Expired\r\n\r\nYour session has expired due to inactivity.\r\n\r\nTo continue please login again.\r\n\r\n',3,'2006-06-11 14:33:14','2006-10-01 13:43:03')"
    execute "INSERT INTO `content_pages` VALUES (3,'Not Found!','notfound',1,'h1. Not Found\r\n\r\nThe page you requested was not found!\r\n\r\nPlease contact your system administrator.',3,'2006-06-11 14:33:49','2006-10-01 13:44:55')"
    execute "INSERT INTO `content_pages` VALUES (4,'Permission Denied!','denied',1,'h1. Permission Denied\r\n\r\nSorry, but you dont have permission to view that page.\r\n\r\nPlease contact your system administrator.',3,'2006-06-11 14:34:30','2006-10-01 13:41:24')"
    execute "INSERT INTO `content_pages` VALUES (6,'Contact Us','contact_us',1,'h1. Contact Us\r\n\r\nVisit the biorails.com project site ',3,'2006-06-12 00:13:47','2006-10-02 04:01:19')"
    execute "INSERT INTO `content_pages` VALUES (8,'Site Administration','site_admin',1,'h1. Goldberg Setup\r\n\r\nThis is where you will find all the specific administration ',1,'2006-06-21 11:32:35','2006-10-01 13:46:01')"
    execute "INSERT INTO `content_pages` VALUES (9,'Administration','admin',1,'h1. Site Administration\r\n\r\n',1,'2006-06-26 06:47:09','2006-10-01 13:38:20')"
    execute "INSERT INTO `content_pages` VALUES (10,'Credits and Licence','credits',1,'h1.',3,'2006-10-02 00:35:35','2006-10-02 03:59:02')"
    
  end

  def self.down
    drop_table :content_pages
    execute "drop table if exists content_page cascade"
   rescue
     nil
     
  end
end
