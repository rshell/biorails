require File.dirname(__FILE__) + '/../test_helper'

class TaskReferenceTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :projects
  ## Biorails::Dba.import_model :studies
  ## Biorails::Dba.import_model :study_protocols
  ## Biorails::Dba.import_model :study_parameters
  ## Biorails::Dba.import_model :protocol_versions
  ## Biorails::Dba.import_model :parameters
  ## Biorails::Dba.import_model :experiments
  ## Biorails::Dba.import_model :experiments
  ## Biorails::Dba.import_model :tasks
  ## Biorails::Dba.import_model :task_contexts
  ## Biorails::Dba.import_model :task_values
  ## Biorails::Dba.import_model :task_texts
  ## Biorails::Dba.import_model :task_references

def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = TaskReference
  end
  
  def test_truth
    assert true
  end

  
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  
end
