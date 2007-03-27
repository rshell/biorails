class CreateRepositories < ActiveRecord::Migration
  def self.up
    create_table :repositories do |t|
    t.column "name",           :string,   :limit => 30, :default => "",   :null => false
    t.column "description",    :string,                 :default => "",   :null => false
    t.column "url",            :string,                 :default => "",   :null => false
    t.column "type",           :string,                 :default => "",   :null => false
    t.column "created_by",     :string,   :limit => 32, :default => "sys",         :null => false
    t.column "created_at",     :datetime,                                          :null => false
    t.column "updated_by",      :string,   :limit => 32, :default => "sys",         :null => false
    t.column "updated_at",      :datetime,                                          :null => false
    end
  end

  def self.down
    drop_table :repositories
  end
end
