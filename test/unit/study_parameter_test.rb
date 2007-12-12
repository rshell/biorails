require File.dirname(__FILE__) + '/../test_helper'

class StudyParameterTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :user_roles
  ## Biorails::Dba.import_model :project_roles
  ## Biorails::Dba.import_model :users
  ## Biorails::Dba.import_model :projects
  ## Biorails::Dba.import_model :memberships
  ## Biorails::Dba.import_model :studies
  ## Biorails::Dba.import_model :data_concept
  ## Biorails::Dba.import_model :data_systems
  ## Biorails::Dba.import_model :data_element
  ## Biorails::Dba.import_model :data_type
  ## Biorails::Dba.import_model :data_format
  ## Biorails::Dba.import_model :parameter_types
  ## Biorails::Dba.import_model :parameter_roles
  ## Biorails::Dba.import_model :study_parameters

def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = StudyParameter
  end
  
  def test_truth
    assert true
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.name
  end
  
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end

  def test_belongs_to_study
    first = @model.find(:first)
    assert first.study    
  end

  def test_belongs_to_parameter_type
    first = @model.find(:first)
    assert first.type    
  end

  def test_belongs_to_parameter_role
    first = @model.find(:first)
    assert first.role
  end

end

