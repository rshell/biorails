##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddCatalogLogIndexes < ActiveRecord::Migration
  def self.up
    add_index "catalog_logs", ["user_id"]
    add_index "catalog_logs", ["auditable_type","auditable_id"]
    add_index "catalog_logs", ["created_at"]
  end

  def self.down
    remove_index "catalog_logs", ["user_id"]
    remove_index "catalog_logs", ["auditable_type","auditable_id"]
    remove_index "catalog_logs", ["created_at"]
  end
end
