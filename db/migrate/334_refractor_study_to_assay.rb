class RefractorStudyToAssay < ActiveRecord::Migration
  def self.up

    rename_column :experiments,      :study_id, :assay_id
    rename_column :study_parameters, :study_id, :assay_id
    rename_column :study_queues,     :study_id, :assay_id
    rename_column :study_protocols,  :study_id, :assay_id
    rename_column :treatment_groups, :study_id, :assay_id    
    
    rename_column :cross_tab_columns,     :study_parameter_id, :assay_parameter_id
    rename_column :parameters,            :study_parameter_id, :assay_parameter_id
    rename_column :queue_items,           :study_parameter_id, :assay_parameter_id
    rename_column :study_queues,          :study_parameter_id, :assay_parameter_id

    rename_column :experiments,       :study_protocol_id, :assay_protocol_id
    rename_column :protocol_versions, :study_protocol_id, :assay_protocol_id
    rename_column :study_queues,      :study_protocol_id, :assay_protocol_id
    rename_column :tasks,             :study_protocol_id, :assay_protocol_id

    rename_column :parameters,          :study_queue_id, :assay_queue_id
    rename_column :queue_items,         :study_queue_id, :assay_queue_id
    rename_column :study_protocols,     :study_stage_id, :assay_stage_id
    rename_column :study_queues,        :study_stage_id, :assay_stage_id

    rename_table :studies,:assays
    rename_table :study_parameters,:assay_parameters
    rename_table :study_protocols, :assay_protocols
    rename_table :study_queues,:assay_queues
    rename_table :study_stages,:assay_stages
        
  end

  def self.down
    rename_table :assays,:studies
    rename_table :assay_parameters, :study_parameters
    rename_table :assay_protocols,:study_protocols
    rename_table :assay_queues,:study_queues
    rename_table :assay_stages,:study_stages
    
    rename_column :experiments,     :assay_id,:study_id
    rename_column :study_parameters,:assay_id,:study_id
    rename_column :study_queues,    :assay_id,:study_id
    rename_column :study_protocols, :assay_id,:study_id
    rename_column :treatment_groups, :assay_id,:study_id
    
    rename_column :cross_tab_columns,      :assay_parameter_id, :study_parameter_id
    rename_column :parameters,             :assay_parameter_id, :study_parameter_id
    rename_column :queue_items,           :assay_parameter_id, :study_parameter_id
    rename_column :study_queues,           :assay_parameter_id, :study_parameter_id

    rename_column :experiments,       :assay_protocol_id, :study_protocol_id
    rename_column :protocol_versions,  :assay_protocol_id, :study_protocol_id
    rename_column :study_queues,       :assay_protocol_id, :study_protocol_id
    rename_column :tasks,              :assay_protocol_id, :study_protocol_id

    rename_column :parameters,           :assay_queue_id,:study_queue_id
    rename_column :queue_items,         :assay_queue_id,:study_queue_id
    rename_column :study_protocols,     :assay_queue_id,:study_queue_id
    rename_column :study_queues,       :assay_queue_id,:study_queue_id
  end
end
