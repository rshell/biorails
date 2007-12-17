class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column "name",               :string,   :limit => 30, :default => "", :null => false
      t.column "description",        :text,                   :default => "", :null => false
      t.column "status_id",          :integer,                :default => 0,  :null => false
      t.column "public_role_id",     :integer,                :null => false
      t.column "external_role_id",   :integer,                :null => true
      t.column "email",              :string
      t.column "lock_version",       :integer,              :default => 0,    :null => false
      t.column "created_at",         :datetime,             :null => false
      t.column "created_by_user_id", :integer,              :default => 1,  :null => false      
      t.column "updated_at",         :datetime,             :null => false
      t.column "updated_by_user_id", :integer,              :default => 1,  :null => false
    end
  end

  def self.down
    drop_table :teams
  end
end
