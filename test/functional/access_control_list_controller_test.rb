require File.dirname(__FILE__) + '/../test_helper'
require "#{RAILS_ROOT}/app/controllers/access_control_list_controller"

# Re-raise errors caught by the controller.
class AccessControlListController; def rescue_action(e) raise e end; end

class AccessControlListControllerTest < BiorailsTestCase

  def setup
    @controller = AccessControlListController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @model = AccessControlList
    @team = Team.find(:first)
    @item = ProjectElement.find(:first,:conditions=>'access_control_list_id is not null')
    @acl = @item.access_control_list
    @role = ProjectRole.find(:first)
  end


  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
  end

  def test_show_invalid
    get :show, :id => 999999999999999
    assert_response :success
    assert_template 'access_denied'
  end

  def test_show_ext
    get :show, :id => @item.id,:format=>'ext'
    assert_response :success
    assert_template '_show'
  end

  def test_show_xml
    get :show, :id => @item.id, :format=>'xml'
    assert_response :success
  end

  def test_show_js
    get :show, :id => @item.id, :format=>'js'
    assert_response :success
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end

  def test_update_cancel
      post :update, :access_control_list_id => @acl.id,:project_element_id=>@item.id,  :cmomit=> 'cancel'
      assert_response :success
      assert_template 'edit'
    end

   def test_create_update_cancel
      @editable_acl = @acl.copy   
      post :update, :access_control_list_id => @editable_acl.id,:project_element_id=>@item.id,  :cmomit=> 'cancel'
      assert_response :redirect
   end

  def test_update_save
    post :update, :access_control_list_id => @acl.id,:project_element_id=>@item.id,  :commit=> l(:Save)
    assert_response :success
    assert_template 'edit'
  end

  def test_add_user
    post :add_user,:access_control_list_id => @acl.id,:project_element_id=>@item.id,
            :role_id => @role.id,:user_id=>3
    assert_response :redirect
    assert_redirected_to :action => 'edit'
  end

  def test_add_user_invalid
    post :add_user,:access_control_list_id => 4354543,:project_element_id=>543543543,
            :role_id => @role.id,:user_id=>3
    assert_response :success
    assert_template 'access_denied'
  end

  def test_add_user_ajax
    post :add_user,:access_control_list_id => @acl.id,:project_element_id=>@item.id,
              :role_id => @role.id,:user_id=>4,:format=>'js'
    assert_response :success
  end

  
  def test_add_team
    post :add_team,:access_control_list_id => @acl.id,:project_element_id=>@item.id,
              :role_id => @role.id,:team_id=>2
    assert_response :redirect
    assert_redirected_to :action => 'edit'
  end

  def test_add_team_ajax
    post :add_team,:role_id => @role.id,:access_control_list_id => @acl.id,:project_element_id=>@item.id,
      :team_id=>2,:format=>'js'
    assert_response :success
  end

  def test_remove
    @ace = @acl.rules[0]
    post :remove, :access_control_element_id=>@ace.id,:project_element_id=>@item.id
    assert_response :redirect
    assert_redirected_to :action => 'edit'
  end

  def test_remove_js
    @ace = @acl.rules[0]
    post :remove, :access_control_element_id=>@ace.id,:project_element_id=>@item.id,:format=>'js'
    assert_response :success
  end

  def test_remove_invalid
    post :remove, :access_control_element_id=>3453532,:project_element_id=>6646643643
    assert_response :success
    assert_template 'access_denied'
  end

  def test_remove_invalid_js
    post :remove, :access_control_element_id=>3453532,:project_element_id=>6646643643,:format=>'js'
    assert_response :success
    assert_template '_access_denied'
  end

end
