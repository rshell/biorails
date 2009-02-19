require File.dirname(__FILE__) + '/../test_helper'

class UmlModelTest < BiorailsTestCase

  # Replace this with your real tests.
  
  def test_uml_controllers
    list = Biorails::UmlModel.controllers
    assert list
    assert list.is_a?(Hash)
    assert list.size> 0
  end
  
  def test_uml_model
    list = Biorails::UmlModel.models
    assert list
    assert list.is_a?(Array)
    assert list.size> 0
  end

  def test_uml_create_model_diagram
    file = Biorails::UmlModel.create_model_diagram('.',Assay,{})
    assert File.exists?(file)
  end
  
end
