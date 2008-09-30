class CreateAccessControlElements < ActiveRecord::Migration
  def self.up
    create_table :access_control_elements do |t|
      t.integer :access_control_list_id 
      t.integer :owner_id 
      t.string :owner_type 
      t.integer :role_id 
    end
  end

  def self.down
    drop_table :access_control_elements
  end
end
