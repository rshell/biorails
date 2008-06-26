class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.column "name",               :string,   :limit => 50, :default => "", :null => false
      t.column "description",        :text
<% for attribute in attributes -%>
      t.column :<%= attribute.name %>, :<%= attribute.type %>
<% end -%>
      t.column "lock_version",       :integer,                :default => 0,  :null => false
      t.column "created_by_user_id", :integer,  :limit => 32, :default => 1,  :null => false
      t.column "created_at",         :datetime,                               :null => false
      t.column "updated_by_user_id", :integer,  :limit => 32, :default => 1,  :null => false
      t.column "updated_at",         :datetime,                               :null => false
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
