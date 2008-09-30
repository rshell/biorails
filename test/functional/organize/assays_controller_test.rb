require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/assays_controller"

# Re-raise errors caught by the controller.
class Organize::AssaysController; def rescue_action(e) raise e end; end

class Organize::AssaysControllerTest < Test::Unit::TestCase

  NEW_STUDY = {}	# e.g. {:name => 'Test Assay', :description => 'Dummy'}
  REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = Organize::AssaysController.new
    @request    =ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @item = Assay.find(1)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @item
    assert_not_nil @item.id
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
  end
  
  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
  end

  def test_show_invalid
    get :show, :id => 24242432
    assert_response :redirect
    assert_redirected_to :action => 'access_denied'
  end

  def test_show_denied
    @request.session[:current_project_id] =2
    @request.session[:current_user_id] = 9   
    get :show, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'access_denied'
  end
  
  def test_show_xml
    get :show, :id => @item.id,:format=>'xml'
    assert_response :success
  end

  def test_show_json
    get :show, :id => @item.id,:format=>'json'
    assert_response :success
  end

  
  def test_print
    get :print, :id => @item.id
    assert_response :success
  end
  
  def test_print_pdf
    get :print, :id => @item.id,:format=>'pdf'
    assert_response :success
  end
  
  def test_print_xml
    get :print, :id => @item.id,:format=>'xml'
    assert_response :success
  end
  
  def test_import
    get :import, :id => @item.id
    assert_response :success
    assert_template 'list'
  end

  def test_import_file_failed
    post :import_file, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert flash[:error]
  end

  def test_import_file_failed_bad_file
    file = ActionController::TestUploadedFile.new(Test::Unit::TestCase.fixture_path+
        '/files/test2-parameters.csv', 'text/csv') 
    post :import_file, :id => @item.id,:name=>'xx-import',:file=>file
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert flash[:error]
  end

  def test_import_file_good_file
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Assay1.xml'))
    post :import_file, :id => @item.id,:name=>'xx-import',:file=>file
    assert_nil flash[:error],flash[:error]
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_share_link
    @request.session[:current_project_id] = 4
    get :link, :assay_id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_create_failed
    num = Assay.count
    destory_id_generator(Assay)    
    post :create, :assay => {}
    assert_response :success
    assert_template 'new'
    assert_equal num, Assay.count
  end
  
  def test_create_default
    num = Assay.count
    create_id_generator(Assay)    
    post :create, :assay => {}
    assert_redirected_to :action=> 'show'
    assert_equal 'Assay was successfully created.', flash[:notice]
    assert_equal num+1, Assay.count
  end
  
  def test_create_valid_assay
    num=Assay.count
    post :create, :assay=>{"name"=>"S-73", "purpose"=>"", "expected_at"=>"2008-07-14", "description"=>"really new one", "status_id"=>"0", "started_at"=>"2008-04-14", "research_area"=>""}
    assert_redirected_to :action=> 'show'
    assert_equal 'Assay was successfully created.', flash[:notice]
    assert_equal num+1, Assay.count
  end
  
  def test_create_invalid_assay
    destory_id_generator(Assay)    
    num=Assay.count
    post :create, :assay=>{"name"=>"", "purpose"=>"", "expected_at"=>"2008-07-14", "description"=>"really new one", "status_id"=>"0", "started_at"=>"2008-04-14", "research_area"=>""}
    assert_response :success
    assert_not_nil assigns(:assay)
    assert !assigns(:assay).valid? 
    assert assigns(:assay).errors
    assert assigns(:assay).errors[:name]
    assert_empty_error_field('assay[name]')
    assert_equal num, Assay.count
  end
  
  def test_create_invalid_assay_because_missing_name
    destory_id_generator(Assay)    
    num=Assay.count
    post :create, :assay=>{"name"=>"", "purpose"=>"", "expected_at"=>"2008-07-14", "description"=>"", "status_id"=>"0", "started_at"=>"2008-04-14", "research_area"=>""}
    assert_response :success
    assert_not_nil assigns(:assay)
    assert !assigns(:assay).valid? 
    assert assigns(:assay).errors
    assert assigns(:assay).errors[:name]
    assert_empty_error_field('assay[name]')
    assert_equal num, Assay.count
  end
   
  
  
  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_equal 'Assay was successfully updated.', flash[:notice]
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_update_with_invalid_name
    post :update, :id=>@item.id,  :assay=>{"name"=>"", "purpose"=>"Testing Assay", "expected_at"=>"2008-03-06", "description"=>"My first assay", "status_id"=>"1", "started_at"=>"2007-12-07", "research_area"=>""}
    assert_response :success
    assert_not_nil assigns(:assay)
    assert !assigns(:assay).valid? 
    assert assigns(:assay).errors
    assert assigns(:assay).errors[:name]
    assert_empty_error_field('assay[name]')
  end
 
 
  def test_destroy
    assert_not_nil Assay.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_raise(ActiveRecord::RecordNotFound) {
      Assay.find(@item.id)
    }
  end

  def test_experiments
    get :experiments, :id => @item.id
    assert_response :success
    assert_template 'experiments'
  end

  def test_queues
    get :queues, :id => @item.id
    assert_response :success
    assert_template 'queues'
  end

  def test_metrics
    get :metrics, :id => @item.id
    assert_response :success
    assert_template 'metrics'
  end

  def test_protocols
    get :protocols, :id => @item.id
    assert_response :redirect
  end

  def test_parameters
    get :parameters, :id => @item.id
    assert_response :success
    assert_template 'parameters'
  end

  def test_export
    get :export, :id => @item.id
    assert_response :success
  end
 
end
