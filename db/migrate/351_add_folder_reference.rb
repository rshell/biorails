class AddFolderReference < ActiveRecord::Migration
  
  def self.up
    add_column :projects,         :project_element_id, :integer

    add_column :assays,           :project_element_id, :integer
    add_column :assay_parameters, :project_element_id, :integer
    add_column :assay_queues,     :project_element_id, :integer
    add_column :assay_protocols,  :project_element_id, :integer
    add_column :protocol_versions,:project_element_id, :integer
    
    add_column :experiments,      :project_element_id, :integer
    add_column :tasks,            :project_element_id, :integer
 
    add_column :requests,         :project_element_id, :integer
    add_column :request_services, :project_element_id, :integer

    add_column :reports,          :project_element_id, :integer
    add_column :cross_tabs,       :project_element_id, :integer
  end

  def self.down
    remove_column :projects,         :project_element_id
    
    remove_column :assays,           :project_element_id
    remove_column :assay_parameters, :project_element_id
    remove_column :assay_queues,     :project_element_id
    remove_column :assay_protocols,  :project_element_id
    remove_column :protocol_versions,:project_element_id

    remove_column :tasks,            :project_element_id
    remove_column :experiments,      :project_element_id

    remove_column :requests,         :project_element_id
    remove_column :request_services, :project_element_id

    remove_column :reports,         :project_element_id
    remove_column :cross_tabs,      :project_element_id
  end

end
