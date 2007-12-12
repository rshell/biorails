ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  #- Admin
  Biorails::Dba.import_model :user_roles
  Biorails::Dba.import_model :project_roles
  Biorails::Dba.import_model :users
  Biorails::Dba.import_model :role_permissions
  Biorails::Dba.import_model :permissions
  
  #-- Catalogue
  Biorails::Dba.import_model :data_concept
  Biorails::Dba.import_model :data_systems
  Biorails::Dba.import_model :data_element
  Biorails::Dba.import_model :data_type
  Biorails::Dba.import_model :data_format
  Biorails::Dba.import_model :parameter_types
  Biorails::Dba.import_model :parameter_roles
  Biorails::Dba.import_model :model_element
  Biorails::Dba.import_model :sql_element
  
  # - Projects
  Biorails::Dba.import_model :projects
  Biorails::Dba.import_model :memberships
  Biorails::Dba.import_model :assets
  Biorails::Dba.import_model :contents
  Biorails::Dba.import_model :project_folders
  Biorails::Dba.import_model :project_contents
  Biorails::Dba.import_model :project_assets
  
  #  - Studies 
  Biorails::Dba.import_model :studies
  Biorails::Dba.import_model :study_parameters
  Biorails::Dba.import_model :study_queues
  Biorails::Dba.import_model :study_protocols
  Biorails::Dba.import_model :protocol_versions
  Biorails::Dba.import_model :parameter_contexts
  Biorails::Dba.import_model :parameters
  
  # - Experiments
  Biorails::Dba.import_model :experiments
  Biorails::Dba.import_model :tasks
  Biorails::Dba.import_model :task_contexts
  Biorails::Dba.import_model :task_values
  Biorails::Dba.import_model :task_texts
 
  
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
