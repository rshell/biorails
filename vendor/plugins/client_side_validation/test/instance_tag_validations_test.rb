
$:.unshift File.join(File.dirname(__FILE__))
$:.unshift File.join(File.dirname(__FILE__) + '/../lib')
$:.unshift File.join(File.dirname(__FILE__), '../../validation_reflection/lib')

require 'test_helper'
require 'boiler_plate/instance_tag_validations'
require 'boiler_plate/validation_reflection'

ActionView::Helpers::InstanceTag.class_eval do
  include BoilerPlate::ActionViewExtensions::InstanceTagValidationsSupport
end
ActiveRecord::Base.class_eval do
  include BoilerPlate::ActiveRecordExtensions::ValidationReflection
end

class InstanceTagValidationTest < Test::Unit::TestCase
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::TagHelper

  class Dummy < ActiveRecord::Base
    include BoilerPlate::ActiveRecordExtensions::ValidationReflection
  
    class << self
  
      def create_fake_column(name, null = true, limit = nil)
        sql_type = limit ? "varchar (#{limit})" : nil
        col = ActiveRecord::ConnectionAdapters::Column.new(name, nil, sql_type, null)
        col
      end
  
      def columns
        [
         create_fake_column('col1'),
         create_fake_column('col2', false, 100),
         create_fake_column('col3'),
         create_fake_column('col4'),
         create_fake_column('col5'),
         create_fake_column('other_dummy_id')
        ]
      end
    end
    
    has_one :nothing
    belongs_to :dummy
    
    validates_presence_of :col1
    validates_length_of :col2, :maximum => 100
    validates_format_of :col3, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    validates_numericality_of :col4, :only_integer => true
    validates_numericality_of :col5
    validates_presence_of :dummy_id
    
    def dummy_id
      1
    end
  end


  def setup
    @dummy = Dummy.new
  end

  def test_mandatory
    assert_dom_equal %{<input id="dummy_col1" name="dummy[col1]" class="mandatory" size="30" type="text" />},
      text_field('dummy', 'col1')
  end

  def test_limit
    assert_dom_equal %{<input id="dummy_col2" name="dummy[col2]" class="validate_maxlength_100" size="30" type="text" />},
      text_field('dummy', 'col2')
  end
  
  def test_format
    assert_dom_equal %{<input id="dummy_col3" name="dummy[col3]" class="validate_format_%2F%5E%28%5B%5E%40%5Cs%5D%2B%29%40%28%28%3F%3A%5B-a-z0-9%5D%2B%5C.%29%2B%5Ba-z%5D%7B2%2C%7D%29%24%2Fi" size="30" type="text" />},
      text_field('dummy', 'col3')
  end

  def test_numeric_integer
    assert_dom_equal %{<input name='dummy[col4]' size='30' class='integer' type='text' id='dummy_col4' />},
      text_field('dummy', 'col4')
  end
  
  def test_numeric_float
    assert_dom_equal %{<input name='dummy[col5]' size='30' class='numeric' type='text' id='dummy_col5' />},
      text_field('dummy', 'col5')
  end

  def test_select
    assert_dom_equal %{<select name='dummy[dummy_id]' id='dummy_dummy_id' class='mandatory'>},
      collection_select('dummy', 'dummy_id', [], 'id', 'col1')
  end

end
