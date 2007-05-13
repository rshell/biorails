class CreateAnalysisMethods < ActiveRecord::Migration
  def self.up
    create_table :analysis_methods do |t|
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "description", :text      
      t.column "class_name", :string , :null => false
      t.column "protocol_version_id", :integer
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_at",           :datetime,                                :null => false
      t.column "updated_at",           :datetime,                                :null => false
      t.column "updated_by_user_id",   :integer,                :default => 1,   :null => false
      t.column "created_by_user_id",   :integer,                :default => 1,   :null => false
    end
  end

  def self.down
    drop_table :analysis_methods
  end
end
