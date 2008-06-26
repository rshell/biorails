class AddExperimentProcessFlowId < ActiveRecord::Migration
  def self.up
    change_column :experiments,:study_protocol_id,:integer,:null => true
  end

  def self.down
    change_column :experiments,:study_protocol_id,:integer,:null => false
  end
end
