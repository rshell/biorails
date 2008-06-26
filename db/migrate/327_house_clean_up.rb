class HouseCleanUp < ActiveRecord::Migration
  def self.up
   begin
     remove_column :protocol_version,:expected_hours_of_work
     remove_column :protocol_version,:expected_length
     remove_column :protocol_version,:protocol_version_id
     remove_column :protocol_version,:how_to
   rescue
     p 'Did not find unwanted columns'
   end     
   begin
     drop_table :experiment_logs
     drop_table :log_messages
     drop_table :study_logs
     drop_table :transactions
   rescue
     p 'not everyone has this column wrongly named'
   end     
  end
  
  def self.down
       # not much we can do to restore deleted data
      raise IrreversibleMigration
  end
end
