class RestructureProtocolDefinition < ActiveRecord::Migration
  def self.up
    add_column  :study_protocols, "process_style", :string, :limit => 128, :default => "Entry", :null => false
    add_column  :study_protocols, "name", :string, :limit => 128, :default => "", :null => false
    add_column  :study_protocols, "description", :text      
    add_column  :study_protocols, "literature_ref", :text  
    add_column  :study_protocols, "protocol_catagory", :string, :limit => 20, :null => true
    add_column  :study_protocols, "protocol_status", :string, :limit => 20, :null => true
    add_column  :study_protocols, "lock_version", :integer, :default => 0, :null => false
    add_column  :study_protocols, "created_by", :string, :limit => 32, :default => "", :null => false
    add_column  :study_protocols, "created_at", :datetime, :null => false
    add_column  :study_protocols, "updated_by", :string, :limit => 32, :default => "", :null => false
    add_column  :study_protocols, "updated_at", :datetime, :null => false    
  end

  def self.down
    remove_column  :study_protocols, "process_style"
    remove_column  :study_protocols, "name"
    remove_column  :study_protocols, "protocol_catagory"
    remove_column  :study_protocols, "protocol_status"
    remove_column  :study_protocols, "description"
    remove_column  :study_protocols, "literature_ref"
    remove_column  :study_protocols, "lock_version"
    remove_column  :study_protocols, "created_by"
    remove_column  :study_protocols, "created_at"
    remove_column  :study_protocols, "updated_by"
    remove_column  :study_protocols, "updated_at"
  end
  

end
