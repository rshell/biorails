class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
    t.column "user_id",    :integer,  :default => 0, :null => false
    t.column "project_id", :integer,  :default => 0, :null => false
    t.column "role_id",    :integer,  :default => 0, :null => false
    t.column "owner",      :boolean,  :default => false
    t.column "created_by",     :string,   :limit => 32, :default => "sys",         :null => false
    t.column "created_at",     :datetime,                                          :null => false
    t.column "updated_by",      :string,   :limit => 32, :default => "sys",         :null => false
    t.column "updated_at",      :datetime,                                          :null => false
    end
  end

  def self.down
    drop_table :memberships
  end
end
