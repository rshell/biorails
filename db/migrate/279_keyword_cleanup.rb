#
# A few Cleanup for Oracle as mode,session,action,owner are not good keywords
#
# Moving to real sqlplus creation scripts for oracle to do foriegn keys,indexes tablespaces etc. 
# but want to keep basic structure
#
class KeywordCleanup < ActiveRecord::Migration
  def self.up
    rename_column_if_needed :analysis_settings, :mode , :io_mode
    rename_column_if_needed :audits, :session, :session_id
    rename_column_if_needed :catalog_logs, :comment, :comments
    rename_column_if_needed :compounds, :updated_by, :updated_by_user_id
    rename_column_if_needed :compounds, :created_by, :created_by_user_id
    rename_column_if_needed :experiment_logs, :comment, :comments
    rename_column_if_needed :study_logs, :comment, :comments
    rename_column_if_needed :memberships,:owner,:is_owner

    drop_table_if_exists :task_files
    drop_table_if_exists :data_contexts
    drop_table_if_exists :authentication_systems
    drop_table_if_exists :work_status
    
  end

  def self.down
  end
end
