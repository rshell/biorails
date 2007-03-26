class CreateListItems < ActiveRecord::Migration
  def self.up
    create_table :list_items do |t|
      t.column "list_id",:integer
      t.column "data_type", :string
      t.column "data_id", :integer
      t.column "data_name", :string
    end
  end

  def self.down
    drop_table :list_items
  end
end
