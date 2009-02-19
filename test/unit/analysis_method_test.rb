require File.dirname(__FILE__) + '/../test_helper'

class AnalysisMethodTest < BiorailsTestCase
  ## Biorails::Dba.import_model :analysis_methods

  # Replace this with your real tests.
def setup
    Analysis.register(Alces::Processor::PlotXy)
    Analysis.register(Alces::Processor::Dummy)
     @model = AnalysisMethod
  end
  
  def test_truth
    assert true
  end
  
  def test_processors
    assert AnalysisMethod.processors
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.name
  end
    
  def test_run
     first = @model.find(:first)
     task = Task.find(:first)
     assert first.id
     first.run(task)
     assert first.report
  end
    
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

   def test_valid
    first = @model.find(:first)
    assert first.valid?   
  end

  def test_update
    first = @model.find(:first)
    assert first.save  
  end

  def test_to_s
    first = @model.find(:first)
    assert !first.to_s.nil?  
  end

  def test_to_json
    first = @model.find(:first)
    assert !first.to_json.nil?  
  end

  def test_to_xml
    first = @model.find(:first)
    assert !first.to_xml.nil?  
  end
 
  def test_report_exceptiohn_handler
    first = @model.find(:first)
    first.process = 10   
    assert first.report    
  end
  
  def test_processor
    first = @model.find(:first)
    Analysis.register(Alces::Processor::Dummy)    
    first.class_name ="Alces::Processor::Dummy"
    assert_equal "Alces::Processor::Dummy", first.class_name
    assert_equal Alces::Processor::Dummy, first.processor      
  end
  
  def test_run
    Analysis.register(Alces::Processor::Dummy)    
    first = @model.find(:first)
    task = Task.find(:first)
    first.class_name ="Alces::Processor::Dummy"
    first.save
    assert_ok first
    first.run(task)    
    assert_ok first
    assert first.process
    assert first.report    
  end
  
  def test_setup
    analysis = AnalysisMethod.setup(
                  :name=>'fred',
                  :method=>Alces::Processor::Dummy,
                  :settings=>{
                    :filename=>{:default_value=>'xxxx.csv'}
                  }
                )
    assert_ok analysis    
  end
  
  def test_configure
    analysis = @model.find(:first)
    assert analysis.configure(
                    :filename=>{:default_value=>'xxxx.csv'}
                )
    assert_ok analysis    
  end
 

  def test_registered
    task = Task.find(:first)
    for name in Analysis.list
      method = Analysis.method(name)
      assert method
      assert method.is_a?(AnalysisMethod)
      assert method.valid?
      ok = method.run(task) 
      assert_not_nil ok
      assert method.report
    end
  end
end
