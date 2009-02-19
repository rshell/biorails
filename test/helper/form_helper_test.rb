require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class FormHelperTest < BiorailsTestCase
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::CaptureHelper
  include ApplicationHelper
  include FormHelper
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
    @parameter = Parameter.find(:first)
  end  
  
  def test_dialog
    html = dialog(:xxxx) 
  end

  def test_date_field
    @data_element = DataElement.find(:first)
    html = date_field(:data_element,:created_at) 
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_html_field
    @data_element = DataElement.find(:first)
    html = html_field(:data_element,:description) 
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_html_field_with_error
    @data_element = DataElement.find(:first)
    html = html_field(nil,:description,[]) 
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_document_field
    @data_element = DataElement.find(:first)
    html = document_field(:data_element,:description) 
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_document_field_with_error
    html = document_field(nil,:name) 
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_select_values_for_assay
    @data_element = DataElement.find(:first)
    assert select_values(:data_element,:name,Assay.find(:all))
  end

  def test_select_values_for_experiment
    @data_element = DataElement.find(:first)
    assert select_values(:data_element,:name,Experiment.find(:all))
  end

  def test_select_values_for_project
    @data_element = DataElement.find(:first)
    assert select_values(:data_element,:name,Project.find(:all))
  end

  def test_select_values_for_project_folder
    @data_element = DataElement.find(:first)
    assert select_values(:data_element,:name,ProjectFolder.find(:all))
  end

  def test_select_values_for_data_concept
    @data_element = DataElement.find(:first)
    assert select_values(:data_element,:name,DataConcept.find(:all))
  end

  def test_select_values_for_data_element
    @data_element = DataElement.find(:first)
    assert select_values(:data_element,:name,DataElement.find(:all))
  end

  def test_select_values_for_common_types
    @data_element = DataElement.find(:first)
    assert select_values(:data_element,:name,Assay.find(:all))
    assert select_values(:data_element,:name,Experiment.find(:all))
    assert select_values(:data_element,:name,Project.find(:all))
    assert select_values(:data_element,:name,ProjectFolder.find(:all))
    assert select_values(:data_element,:name,DataConcept.find(:all))
    assert select_values(:data_element,:name,DataElement.find(:all))
  end

  def test_select_values_with_errors
    assert select_values(nil,:name,Assay.find(:all),[])
  end
  
  def test_select_data_element
    @data_element = DataElement.find(:first)
    assert select_data_element(:data_element,:description,DataConcept.find(:first)) 
  end

  def test_select_data_element_by_elment
    @data_element = DataElement.find(:first)
    assert select_data_element(:data_element,:description,@data_element) 
  end

  def test_select_data_element_as_text
    @data_element = DataElement.find(:first)
    assert select_data_element(:data_element,:description,'Project') 
  end

  def test_select_data_element_as_error
    assert select_data_element(:datalement,:description,'Compound') 
  end

  def test_select_data_format
    @parameter = Parameter.find(:first)
    html = select_data_format(:parameter,:data_format) 
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_select_data_format_as_error
    html = select_data_format(:pameter,:data_format) 
    assert html.is_a?(String),html
    assert html.size>0
  end
  
  def test_select_concept
    element = DataElement.find(:first)
    concept = element.concept
    html = select_concept(:parameter,:data_format,concept)
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_select_concept_by_id
    element = DataElement.find(:first)
    concept = element.concept
    html = select_concept(:parameter,:data_format,concept.id)
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_select_concept_invalid
    html = select_concept(:parameter,:data_format,8888888)
    assert html.is_a?(String),html
    assert html.size>0
  end

   def test_select_concept_unused
    concept = DataConcept.create(:name=>'dsgsdgdsgds',:description=>'dsgdsgdsgdsg')
    html = select_concept(:parameter,:data_format,concept)
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_select_element
    element = DataElement.find(:first)
    html = select_element(:parameter,:data_format,element)
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_select_element_by_id
    element = DataElement.find(:first)
    html = select_element(:parameter,:data_format,element.id)
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_select_element_invalid
    element = DataElement.find(:first)
    html = select_element(:parameter,:data_format,539805034)
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_select_named
    @parameter = Parameter.find(:first)
    html = select_named(:parameter,:data_format,DataFormat)
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_select_named_as_error
    html = select_named(:parameter,:data_format,DataFormat) 
    assert html.is_a?(String),html
    assert html.size>0
  end
  
  def test_select_process
    @parameter = Parameter.find(:first)
    html = select_process('parameter','protocol_version_id') 
    assert html.is_a?(String),html
  end
  
  def test_select_process_with_latest
    @parameter = Parameter.find(:first)
    html = select_process('parameter','protocol_version_id',nil,true) 
    assert html.is_a?(String),html
  end
  
  def test_select_process_as_error
    html = select_process('parameter','protocol_version_id') 
    assert html.is_a?(String),html
  end

  def test_select_process_instance_as_error
    html = select_process_instance(nil,:assay_protocol_id) 
    assert html.is_a?(String),html
    assert html.size>0
  end
  
  def test_select_process_instance
    @experiment = Experiment.find(:first)
    Project.current = Project.find(2)
    html = select_process_instance(:experiment,:assay_protocol_id) 
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_select_process_instance_and_lastest
    @experiment = Experiment.find(:first)
    Project.current = Project.find(2)
    html = select_process_instance(:experiment,:assay_protocol_id,nil) 
    assert html.is_a?(String),html
    assert html.size>0
  end

  def test_my_field_tag
    Project.current = Project.find(2)
    for parameter in Parameter.find(:all)
      html = my_field_tag(:id,:name,parameter) 
      assert html.is_a?(String),html
      assert html.size>0
    end
  end
  
  def test_my_file_tag
    @experiment = Experiment.find(:first)
    Project.current = Project.find(2)
    html = my_file_field(:experiment,:name,@experiment.folder)
    assert html.is_a?(String),html
    assert html.size>0
  end
  
  def test_my_date_tag
    @experiment = Experiment.find(:first)
    Project.current = Project.find(2)
    html = my_date_field(:experiment,:started_at,@experiment.started_at)
    assert html.is_a?(String),html
    assert html.size>0
  end

  def in_place_editor(*args)
    "mock"
  end
  
  def test_my_in_place_editor_field
    @experiment = Experiment.find(:first)
    Project.current = Project.find(2)
    html = my_in_place_editor_field(@experiment,:name,{},{:url=>'show',:size=>30})
    assert html.is_a?(String),html
    assert html.size>0
  end

end