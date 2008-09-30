class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :name ,          :null => false
      t.string :description ,  :null => false
      t.boolean :is_default,   :default=>false
      t.integer :level_no,     :default=>0,  :null => false
      t.integer :position,     :default=>0,  :null => false
      t.column :lock_version,        :integer,                 :default => 0,  :null => false
      t.column :created_at,          :datetime,                                :null => false
      t.column :updated_at,          :datetime,                                :null => false
      t.column :updated_by_user_id,  :integer,                 :default => 1,  :null => false
      t.column :created_by_user_id,  :integer,                 :default => 1,  :null => false
    end
  end

  def self.down
    drop_table :states
  end
end
