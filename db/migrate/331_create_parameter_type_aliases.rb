class CreateParameterTypeAliases < ActiveRecord::Migration
  def self.up
    create_table :parameter_type_aliases do |t|
      t.string  "name",                               :default => "", :null => false
      t.string  "description",        :limit => 1024,                                :default => "", :null => false
      t.integer "parameter_type_id",                  :precision => 11, :scale => 0,                 :null => false
      t.integer "parameter_role_id",                  :precision => 11, :scale => 0
      t.integer "data_format_id",                     :precision => 11, :scale => 0
      t.integer "data_element_id",                    :precision => 11, :scale => 0
      t.string  "display_unit",                       :default => ""
      t.string  "status" ,                            :default =>'new'
      t.integer "created_by_user_id",                 :precision => 11, :scale => 0, :default => 1,  :null => false
      t.integer "updated_by_user_id",                 :precision => 11, :scale => 0, :default => 1,  :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :parameter_type_aliases
  end
end
