
require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTestTest < ActionController::IntegrationTest
    include Caboose::SpiderIntegrator
 
    fixtures :roles
    fixtures :permissions
    fixtures :role_permissions
    fixtures :data_concepts
    fixtures :data_systems
    fixtures :data_elements
    fixtures :parameter_types
    fixtures :Parameter_roles
    fixtures :study_stages
   
    fixtures :lists
    fixtures :list_items
  
    fixtures :compounds
    fixtures :batches
  
    fixtures :projects
    fixtures :db_files
    fixtures :project_elements
    fixtures :project_contents
    fixtures :project_assets
  
    fixtures :studies
    fixtures :study_parameters
    fixtures :study_queues
    fixtures :study_protocols  
    
    fixtures :protocol_versions
    fixtures :paremeter_contexts
    fixtures :parameters
  
    fixtures :requests
    fixtures :request_services  
    fixtures :queue_items
    
    fixtures :experiments
    fixtures :tasks
    fixtures :task_contexts
    fixtures :task_values
    fixtures :task_texts
    fixtures :task_references

 
    
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
#  def test_spider
#      get '/sessions/new'
#      assert_response :success
#      post 'auth/login', :login => 'admin', :password => 'admin'
#      assert session[:user]
#      assert_response :redirect
#      assert_redirected_to '/'
#      follow_redirect!  
#      spider(@response.body, '/')
#    end
end
