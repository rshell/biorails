##
# Rename link which now points to study protocols also raname table to more logical protocol versions
# and following this to linked tables with rename of foreign key columns.
# Then final mark process_definitions as dead.
# 
class RestructureProcessInstance < ActiveRecord::Migration
  def self.up
    rename_column  :process_instances, "process_definition_id","study_protocol_id"
    
    rename_table   :process_instances,   :protocol_versions
    rename_table   :process_definitions, :dead_process_definition

    rename_column  :study_protocols,    "process_instance_id", "current_version_id"
    rename_column  :parameters,         "process_instance_id", "protocol_version_id"
    rename_column  :parameter_contexts, "process_instance_id", "protocol_version_id"
    rename_column  :experiments,        "process_instance_id", "protocol_version_id"
    rename_column  :tasks,              "process_instance_id", "protocol_version_id"
  end

  def self.down
    rename_table   :protocol_versions,       :process_instances
    rename_table   :dead_process_definition, :process_definitions
    
    rename_column  :process_instances, "study_protocol_id","process_definition_id"

    rename_column  :study_protocols,    "current_version_id"  ,"process_instance_id"
    rename_column  :parameters,         "protocol_version_id","process_instance_id"
    rename_column  :parameter_contexts, "protocol_version_id","process_instance_id"
    rename_column  :experiments,        "protocol_version_id","process_instance_id"
    rename_column  :tasks,              "protocol_version_id","process_instance_id"
  end
end
