class CreateAnalysisSettings < ActiveRecord::Migration
  def self.up
    create_table :analysis_settings do |t|
      t.column "analysis_method_id",   :integer
      t.column "name",                 :string,   :limit => 62
      t.column "script_body",          :text
      t.column "options",              :text
      t.column "data_type_id",         :integer
      t.column "level_no",             :integer
      t.column "column_no",            :integer
      t.column "parameter_id",         :integer
      t.column "mode",                 :integer
      t.column "mandatory",            :string,                 :default => "N"
      t.column "default_value",        :string
      t.column "created_at",           :datetime,                                :null => false
      t.column "updated_at",           :datetime,                                :null => false
      t.column "updated_by_user_id",   :integer,                :default => 1,   :null => false
      t.column "created_by_user_id",   :integer,                :default => 1,   :null => false
    end
  end

  def self.down
    drop_table :analysis_settings
  end
end
