#
# A few Cleanup for Oracle as mode,session,action,owner are not good keywords
#
# Moving to real sqlplus creation scripts for oracle to do foriegn keys,indexes tablespaces etc. 
# but want to keep basic structure
#
class KeywordCleanup < ActiveRecord::Migration
  def self.up
    rename_column_if_needed :compounds, :updated_by, :updated_by_user_id
    rename_column_if_needed :compounds, :created_by, :created_by_user_id

    drop_table_if_exists :task_files
    
  end

  def self.down
  end
end
