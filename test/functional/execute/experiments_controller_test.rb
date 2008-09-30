require File.dirname(__FILE__) + '/../../test_helper'
require "experiments_controller"

# Re-raise errors caught by the controller.
class Execute::ExperimentsController; def rescue_action(e) raise e end; end

class Execute::ExperimentsControllerTest < Test::Unit::TestCase

  def setup
    @controller = Execute::ExperimentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first = Experiment.find(:first)
    @request.session[:current_element_id] =@first.project_element_id
    @request.session[:current_project_id] = @first.project_id
    @request.session[:current_user_id] = 3
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @first
    assert_not_nil @first.id
  end
  
  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:report)
  end

  def test_show
    get :show, :id => @first.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:experiment)
    assert assigns(:experiment).valid?
  end

  def test_show_no_id
    get :show,:id=>nil
    assert_response :redirect
  end

  def test_show_invalid_id
    get :show,:id=>34535535
    assert_response :redirect
  end

  def test_print
    get :print, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:experiment)
    assert assigns(:experiment).valid?
  end

  def test_metrics
    get :metrics, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:experiment)
    assert assigns(:experiment).valid?
  end

  def test_export_ok
    get :export,:id => @first.id, :assay_protocol_id => AssayProcess.find(:first)
    assert_response :success
    assert_not_nil assigns(:experiment)
    assert assigns(:experiment).valid?
  end

  def test_export_failed
    get :export, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:experiment)
    assert assigns(:experiment).valid?    
  end
  

  def test_copy
    get :copy, :id => @first.id
    assert_response :redirect
    assert_not_nil assigns(:experiment)
    assert assigns(:experiment).valid?
  end

  def test_new
    get :new, :id => Assay.list(:first).id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:experiment)
  end

  def test_create_failed
    destory_id_generator(Experiment)    
    num_experiments = Experiment.count
     post :create, :experiment=>{"name"=>"", "protocol_version_id"=>"4", "expected_at"=>"2008-04-21", "description"=>" Experiment in project ream ", "assay_id"=>"3", "started_at"=>"2008-04-14"}
    assert_response :success
    assert_template 'new'
    assert assigns(:experiment)
    assert !assigns(:experiment).valid? 
    assert assigns(:experiment).errors
    assert assigns(:experiment).errors[:name]
    assert_equal num_experiments, Experiment.count
  end

  def test_create_with_default
    create_id_generator(Experiment)    
    num_experiments = Experiment.count
     post :create, :experiment=>{"name"=>"", "protocol_version_id"=>"4", "expected_at"=>"2008-04-21", "description"=>" Experiment in project ream ", "assay_id"=>"3", "started_at"=>"2008-04-14"}
     assert_response :redirect
     assert_redirected_to :action=>'show'
     assert_equal num_experiments+1, Experiment.count
  end
  
  def test_create_valid_experiment
    destory_id_generator(Experiment)    
     num_experiments = Experiment.count
     post :create, :experiment=>{"name"=>"rjs-457", "protocol_version_id"=>"4", "expected_at"=>"2008-04-21", "description"=>" Experiment in project ream ", "assay_id"=>"3", "started_at"=>"2008-04-14"}
     assert_response :redirect
     assert_redirected_to :action=>'show'
     assert_equal num_experiments+1, Experiment.count
   end

  def test_edit
    get :edit, :id => @first.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:experiment)
    assert assigns(:experiment).valid?
  end

  def test_update
    post :update, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end
  
  def test_update_makes_experiment_invalid
    post :update, :id => @first.id, :experiment=>{:name=>''}
    assert_response :success
    assert !assigns(:experiment).valid? 
    assert assigns(:experiment).errors
    assert assigns(:experiment).errors[:name]
  end

  def test_destroy
    assert_not_nil Experiment.find(@first.id)

    post :destroy, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Experiment.find(@first.id)
    }
  end
  
  def test_import
    get :import, :id => @first.id
    assert_response :success
    assert_template 'import'
    assert_not_nil assigns(:experiment)
  end

  def test_import_file
    get :import_file, :id=>@first.id, :file=>'file'
    assert flash[:error]
  end

  def test_import_file_ie6_pattern
    get :import_file, :id=>@first.id, 'File'=>'file'
    assert flash[:error]
  end
  
  def test_import_file_fails_because_file_param_missing
     post :import_file, :id=>@first.id 
     assert flash[:error]
     assert flash[:info]
   end

  #
  # Cant create a new task with no experiment or task_id
  #
  def test_import_file_ok_with_blank_experiment_name
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad_no_experiment_name.csv'))
    post :import_file, :id=>1,:file=>file
    assert !flash[:error]
    assert flash[:info]
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
  #
  # Work fine with no assay name
  #
  def test_import_file_suceeds_with_no_assay_name
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad_no_assay_name.csv'))
    post :import_file, :id=>1,:file=>file
    assert !flash[:error]
    assert flash[:info]
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
#
#
#
  def test_import_file_bad_no_protocol_name
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad_no_protocol_name.csv'))
    post :import_file, :id=>1,:file=>file
    assert_response :redirect
    assert_redirected_to :action => 'import'
    assert flash[:error]
    assert flash[:info]
  end
    
  def test_import_file_poor_data
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad-data.csv'))
    post :import_file, :id=>1,:file=>file
    assert !flash[:error],flash[:error]
    assert !flash[:warning],flash[:warning]
    assert flash[:info]
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
    
  def test_import_file_bad_context
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad-context.csv'))
    post :import_file, :id=>1,:file=>file
    assert !flash[:error],flash[:error]
    assert !flash[:warning],flash[:warning]
    assert flash[:info]
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
    
  def test_import_file_new_task_good_data
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-good-data.csv'))
    post :import_file, :id=>1,:file=>file
    assert !flash[:error]
    assert flash[:info]
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
    
  def test_import_file_old_task_good_data
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-Task1.csv'))
    post :import_file, :id=>1,:file=>file
    assert !flash[:error],flash[:error]
    assert flash[:info]
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
    
end
