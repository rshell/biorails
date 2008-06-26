require File.dirname(__FILE__) + '/../test_helper'

class AnalysisTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def setup
     @model = Analysis
  end
  
  class TestAnalysis < Analysis
    def self.name 
      'xxx_test'
    end 
    def self.description
      'xxxxx'
    end    
    
    def self.setup(name)
      defaults = AnalysisMethod.new(:name=>name,:description=>self.description,:class_name=>self.to_s)
    end
    
    def initialize(task,method)
      @task = task
      @method = method      
    end
    
    def run
      true
    end
    
    def to_html
      "test"
    end
  end
  

  class TestInvalidAnalysis < Analysis
    def self.name 
      'xxx_nosave'
    end 
    def self.description
      'xxxxx'
    end    
    
    def self.setup(name)
      defaults = AnalysisMethod.new(:name=>nil)
    end
    
    def initialize(task,method)
      @task = task
      @method = method      
    end
    
    def run
      true
    end
    
    def to_html
      "test"
    end
  end
  
  
  def test_truth
    assert true
  end
  
  def test_list
    list = Analysis.list
    assert list
    assert list.is_a?(Array)
    assert list.size>0
  end
  
  def test_get
    name = Analysis.list[0]
    method = Analysis.get(name)
    assert method
    assert_equal method,Analysis.processors[name]
  end

  def test_method
    name = Analysis.list[0]
    method = Analysis.method(name)
    assert method
    assert method.is_a?(AnalysisMethod)
  end

  def test_method_invalid
    method = Analysis.method('nsfdsds')
    assert_equal nil,method
  end
TestInvalidAnalysis

  def test_register_invalid_on
    Analysis.register(TestInvalidAnalysis)    
    assert Analysis.sync_db
    method = AnalysisMethod.find_by_name('xxx_nosave')
    assert_equal nil,method
  end

  def test_register
    Analysis.register(TestAnalysis)    
    method = Analysis.get( TestAnalysis.to_s)
    assert method
    assert_equal method,TestAnalysis
  end

  def test_register_again
    method = Analysis.get(name)
    Analysis.register(method)    
  end

  def test_register_sync_run_and_report_new_analysis
    method = Analysis.get(name)
    Analysis.register(TestAnalysis)    
    Analysis.sync_db
    method = AnalysisMethod.find_by_name('xxx_test')
    assert method
    task = Task.find(:first)
    assert method.run(task)
    assert method.report
  end
  
end
