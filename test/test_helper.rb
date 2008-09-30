ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'hpricot'
include Biorails

@@logger=Logger.new(STDOUT)

def logger
  return @@logger
end

module Test
  module Unit
    module Assertions

      def assert_ok(object)
         assert_not_nil object, ' Object is missing'
         assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
         assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
         assert !object.new_record?,   " #{object.class}:#{object} not saved"
      end

      def assert_save_ok(object)
         assert_not_nil object, ' Object is missing'
         assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
         assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
         assert object.save,"Failed to save"
         assert !object.new_record?,   " #{object.class}:#{object} not saved"
      end

      def assert_valid(object)
         assert_not_nil object, ' Object is missing'
         assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
         assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
      end
      
      def destory_id_generator(clazz)
         generator = Identifier.find_by_name(clazz.to_s)
         generator.destroy
      rescue   
      end
      
      def create_id_generator(clazz)
         Identifer.next_id(clazz)
      rescue   
      end
      
      # Test a class' required fields. You should not be able to save if missing a required field.
      # You should be able to save if the required fields are supplied. The purpose of this custom 
      # assertion is two-fold: 
      #
      # 1. Help your test cases explicitly state your business rules  
      # 2. Keep DRY by collapsing tests for multiple required fields into one method call
      #
      # Example: assert_required User, :last_name => 'Romney', :first_name => 'Christian'
      # You must supply the class to test as the first argument, and an initialization hash
      # containing good/passing values as the second argument. An optional third argument (message)
      # allows you to override the default failure messages with your own. The default messages are
      # very descriptive, however, and you should probably think twice about overriding them.
      def assert_required(klass, required_fields={}, message=nil)
        clean_backtrace do
          # Check the arguments to assert_required
          assert_not_nil klass, (message || "You must pass the class to test as the first argument.")
          assert_respond_to klass.new, :save, (message || "The class you supplied does not respond to the :save message.")
          assert_not_equal 0, required_fields.size, (message || 'You have not specified any required fields.')

          # Assert we cannot save if we omit *any* one of the required fields
          required_fields.each do |current_field, current_value|
            all_fields_but_current = required_fields.reject {|key, value| key.eql? current_field}
            assert !klass.new(all_fields_but_current).save, 
              (message || "#{klass.to_s} should not save when missing required field '#{current_field}'.")
          end

          # Assert we can save the model with all the required fields given
          assert klass.new(required_fields).save, 
            (message || "#{klass.to_s} should save if all required fields present.")
        end
      rescue Exception=>ex  
         fail(ex.message)
      end
      
      #assert that the named field is empty and marked as an error
      def assert_empty_error_field(name)
          parsed=Hpricot.parse(@response.body)
         el= parsed/'div[@class="fieldWithErrors"]/*'
         assert el.size > 0, parsed
         el.each do |e|
           assert_equal name, e.attributes['name']
           assert_equal '', e.inner_html
         end
       rescue Exception=>ex  
         fail(ex.message)
       end
     end
   end
 end
 
class OutputNotAllowed < StandardError ; end

class Test::Unit::TestCase
  #- Admin
  if Task.count < 1 or Project.count < 1
  Biorails::Dba.import_model :user_roles
  Biorails::Dba.import_model :project_roles
  Biorails::Dba.import_model :users
  Biorails::Dba.import_model :identifiers
  Biorails::Dba.import_model :role_permissions
  
  Biorails::Dba.import_model :reports
  Biorails::Dba.import_model :report_columns

  #- Inventory
  Biorails::Dba.import_model :compounds
  Biorails::Dba.import_model :batches
  Biorails::Dba.import_model :lists
  Biorails::Dba.import_model :list_items
  
  #-- Catalogue
  Biorails::Dba.import_model :data_concept
  Biorails::Dba.import_model :data_systems
  Biorails::Dba.import_model :data_element
  Biorails::Dba.import_model :data_type
  Biorails::Dba.import_model :data_format
  Biorails::Dba.import_model :parameter_types
  Biorails::Dba.import_model :parameter_type_aliases
  Biorails::Dba.import_model :project_types
  Biorails::Dba.import_model :parameter_roles
  Biorails::Dba.import_model :model_element
  Biorails::Dba.import_model :list_element
  Biorails::Dba.import_model :sql_element
  Biorails::Dba.import_model :element_types
  Biorails::Dba.import_model :states
  
  # - Projects
  Biorails::Dba.import_model :teams
  Biorails::Dba.import_model :memberships
# built from teams  
#  Biorails::Dba.import_model :access_control_lists
#  Biorails::Dba.import_model :access_control_elements
  Biorails::Dba.import_model :projects
  Biorails::Dba.import_model :db_files
  Biorails::Dba.import_model :assets
  Biorails::Dba.import_model :contents
  Biorails::Dba.import_model :project_contents
  Biorails::Dba.import_model :project_assets
  Biorails::Dba.import_model :signatures
  
  #  - Studies 
  Biorails::Dba.import_model :assay_stages
  Biorails::Dba.import_model :assays

  Biorails::Dba.import_model :requests
  Biorails::Dba.import_model :request_services

  Biorails::Dba.import_model :assay_parameters
  Biorails::Dba.import_model :assay_queues
  Biorails::Dba.import_model :assay_processes
  Biorails::Dba.import_model :assay_workflows
  Biorails::Dba.import_model :process_flows
  Biorails::Dba.import_model :process_instances
  Biorails::Dba.import_model :process_steps
  Biorails::Dba.import_model :parameter_contexts
  Biorails::Dba.import_model :parameters
    
  Biorails::Dba.import_model :analysis_methods
  Biorails::Dba.import_model :analysis_settings

  # - Experiments
  Biorails::Dba.import_model :experiments
  Biorails::Dba.import_model :tasks
  Biorails::Dba.import_model :task_contexts
  Biorails::Dba.import_model :task_values
  Biorails::Dba.import_model :task_texts

  Biorails::Dba.import_model :queue_items
  Biorails::Dba.import_model :cross_tabs
  ProjectElement.rebuild_sets
  TaskContext.rebuild_sets
  ParameterContext.rebuild_sets
  Content.rebuild_sets
  else
    puts "Data Already loaded will use it!"
  end
  # 
  #
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
end

class TestHelper < Test::Unit::TestCase
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::CaptureHelper
  include ApplicationHelper
  
  def default_test
    true
  end

  def image_tag(*args)
    "mock image_tag"
  end
    
  def call(*arg)
    "mock"
  end

  def render(*arg)
    "mock"
  end  

  def report_url(*arg)
    "mock"  
  end

  def element_url(*arg)
    "mock"  
  end
  
  def folder_url(*arg)
    "mock"  
  end
  
  def project_url(*arg)
    "mock"  
  end
  def assay_url(*arg)
    "mock"  
  end
  def content_url(*arg)
    "mock"  
  end
  def asset_url(*arg)
    "mock"  
  end
  def folder_url(*arg)
    "mock"  
  end
  def assay_parameter_url(*arg)
    "mock"  
  end
  def experiment_url(*arg)
    "mock"  
  end

  def process_instance_url(*arg)
    "mock"
  end
  def process_flow_url(*arg)
    "mock"
  end

  def task_url(*arg)
    "mock"  
  end
  def report_url(*arg)
    "mock"  
  end
  def request_url(*arg)
    "mock"  
  end
  def compound_url(*arg)
    "mock"  
  end
  def url_for(*arg)
    "mock"  
  end
  
  def protect_against_forgery?
    false
  end

end
