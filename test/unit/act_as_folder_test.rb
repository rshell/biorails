
require File.dirname(__FILE__) + '/../test_helper'

class ActAsFolderTest < Test::Unit::TestCase
  # ## Biorails::Dba.import_model :lists

  # Replace this with your real tests.
  def setup
    @model = Assay
    @instance = Assay.find(:first)
    User.current = User.find(3)
    Project.current = Project.find(2)
  end
  
  def is_class_list_all(model)
     assert list = model.list(:all)
     assert list.size>0
  end 

  def is_class_find_visible(model)
     assert list = model.find_visible(:all)
     assert list.size>0
  end

  def is_instance_folder(instance)
     assert folder = instance.folder
     assert folder.is_a?(ProjectFolder)
     assert_equal instance.name, folder.name
  end

  def is_instance_changable?(model)
     assert model.changable?
  end

  def is_instance_visible?(model,instance)
     assert model.new.visible?
     assert instance.visible?
  end
  
  def test_assay_class
    is_class_list_all(Assay)
    is_class_find_visible(Assay)
  end

  def test_experiment_class
    is_class_list_all(Experiment)
    is_class_find_visible(Experiment)
  end

  def test_task_class
    is_class_list_all(Task)
    is_class_find_visible(Task)
  end
  
  def test_class_load
     x = @model.load(@instance.id)
     assert_equal @instance,x
  end

  def test_assay_instance_methods
    model = Assay
    instance = model.find(:first)
    is_instance_folder(instance)
    is_instance_changable?(instance)
    is_instance_visible?(model,instance)
  end
  
  def test_assay_parameter_instance_methods
    model = AssayParameter
    instance = model.find(:first)
    is_instance_folder(instance)
    is_instance_changable?(instance)
    is_instance_visible?(model,instance)
  end
  
  def test_assay_queue_instance_methods
    model = AssayQueue
    instance = model.find(:first)
    is_instance_folder(instance)
    is_instance_changable?(instance)
    is_instance_visible?(model,instance)
  end
  
  def test_request_instance_methods
    model = Request
    instance = model.find(:first)
    is_instance_folder(instance)
    is_instance_visible?(model,instance)
  end
  
  def test_experiment_instance_methods
    model = Experiment
    instance = model.find(:first)
    is_instance_folder(instance)
    is_instance_changable?(instance)
    is_instance_visible?(model,instance)
  end
  
  def test_task_instance_methods
    model = Task
    instance = model.find(:first)
    is_instance_folder(instance)
    is_instance_changable?(instance)
    is_instance_visible?(model,instance)
  end

  
  def test_share    
    project_x = Project.find(2)
    assert project_x.home.allow?(:data,:update)
    
    project_y = Project.find(3)    
    assert project_y.home.allow?(:data,:create)
    
    User.current = User.find(3)
    
    Project.current = project_x
    assert assay_in_x = Assay.load(1)
    assert_equal 2, Assay.list(:all).size
    
    assert 0,Assay.list(:all).size
    element = project_y.share(assay_in_x)
    assert element.is_a?(ProjectFolder)
    assert_equal assay_in_x,element.reference
  end

  
  def test_publish    
    project_x = Project.find(2)
    assert project_x.home.allow?(:data,:edit)
    
    project_y = Project.find(3)    
    assert project_y.home.allow?(:data,:create)
    
    User.current = User.find(3)
    
    Project.current = project_x
    assert assay_in_x = Assay.load(1)
    assert_equal 2, Assay.list(:all).size
    
    assert 0,Assay.list(:all).size
    element = project_y.home.add_link(assay_in_x.folder)
    assert element.is_a?(ProjectReference)
    assert_equal assay_in_x,element.reference
  end
  
end
