class CreateAccessControlLists < ActiveRecord::Migration
  def self.up
    create_table :access_control_lists do |t|
      t.string   :content_hash
      t.integer  :team_id
    end
  end

  def self.down
    drop_table :access_control_lists
  end
end
