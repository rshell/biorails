class CreateIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :identifiers do |t|
        t.column "name",       :string
        t.column "prefix",       :string
        t.column "postfix",       :string
        t.column "mask",       :string
        t.column "current_counter", :integer,  :default => 0
        t.column "current_step", :integer,  :default => 1
        t.column "lock_version",     :integer,                :default => 0,             :null => false
        t.column "created_by",       :string,   :limit => 32, :default => "sys",         :null => false
        t.column "created_at",       :datetime,                                          :null => false
        t.column "updated_by",       :string,   :limit => 32, :default => "sys",         :null => false
        t.column "updated_at",       :datetime,                                          :null => false
    end
  end

  def self.down
    drop_table :identifiers
  end
end
