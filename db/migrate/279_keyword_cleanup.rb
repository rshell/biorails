#
# A few Cleanup for Oracle as mode,session,action,owner are not good keywords
#
# Moving to real sqlplus creation scripts for oracle to do foriegn keys,indexes tablespaces etc. 
# but want to keep basic structure
#
class KeywordCleanup < ActiveRecord::Migration
  def self.up
#    rename_column :analysis_settings, :mode , :io_mode
#    rename_column :audits, :session, :session_id
#    rename_column :audits, :action, :action_name
#    rename_column :catalog_logs, :comment, :comments
    rename_column :experiment_logs, :comment, :comments
#    rename_column :study_logs, :comment, :comments
#    drop_table :task_files
#    drop_table :data_contexts
#    drop_table :authentication_systems
#    drop_table :work_status
    rename_column :memberships,:owner,:is_owner
    
  end

  def self.down
  end
end
