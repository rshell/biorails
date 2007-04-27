class AddAuditingToStudyParameters < ActiveRecord::Migration
  def self.up
      add_column   :study_parameters , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :study_parameters , :updated_by_user_id,  :integer,  :default=>1,  :null=>false  
  end

  def self.down
      remove_column   :study_parameters , :created_by_user_id
      remove_column   :study_parameters , :updated_by_user_id
  end
end
