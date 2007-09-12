##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

#
# Main Application controller with a log of the key application aspects for
# user authorization, authentatations etc.
# 
class ApplicationController < ActionController::Base
 # observer :study_observer,:experiment_observer, :catalog_observer
 
 PUBLIC_PROJECT_ID = 1
 GUEST_USER_ID = 1
 
 #audit DataConcept,DataContext,DataSystem,DataElement,DataFormat,DataType,
 #      Study,StudyProtocol,StudyParameter,
 #      ProtocolVersion,ParameterContext,Parameter,
 #      Experiment,Task
 
##
# Help functionailty has been divided up into a number areas to keep modules readable 
  helper :sort
  helper Execute::ReportsHelper
  include SortHelper
  helper :pagination
  helper FormHelper    # Various Form helper and custom controllers
  helper FormatHelper  # Extra formating rules for date,times etc
  helper SessionHelper # Various session/parameter cache and lookup function
  helper TreeHelper # Tree display helpers
  include TinyMCE
 

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_Biorails2_session_id'

  before_filter :setup_context

#
# Global look and feel ofr MCE Rich text editor
#

  uses_tiny_mce(:options => {
     :theme => 'advanced',
     :mode => "textareas",
     :doctype => " ",
     :width => '100%',
     :height => '300px',
     :browsers => %w{msie,gecko,opera,safari},
     :theme_advanced_toolbar_location => "top",
     :theme_advanced_toolbar_align => "left",
     :auto_resize => false,
     :theme_advanced_resizing => true,
     :theme_advanced_statusbar_location => "bottom",
     :paste_auto_cleanup_on_paste => true,
     :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent bullist numlist separator fullscreen help},
     :theme_advanced_buttons2 => %w{cut copy paste pastetext pasteword undo redo link unlink image separator visualaid tablecontrols separator fullpage code cleanup},
     :theme_advanced_buttons3 => [],
     :plugins => %w{contextmenu paste table fullscreen fullpage}
     })  

  helper_method :logged_in?
  helper_method :current_user
  helper_method :current_project
  helper_method :current_username
  helper_method :current_folder
  helper_method :current 


##
# Get current version of this model passed on param[:id] and
# if not found the current session
#
  def current(model,id=nil)
    logger.debug "current(#{model},#{id})"
    key = "#{model.to_s}_id"
    instance = model.find(id) if id
    instance ||= model.find(session[key]) if session[key]
    instance ||= current_user.lastest(model) if logged_in?
    session[key]= instance.id if instance
    return instance
  rescue Exception => ex
      logger.error "current error: #{ex.message}"
  end

##
# Default authorization function allow anything generally overridden in
# controllers via use_authorization definition
#  
  def authorize
    return true
  end   

##
# is there a user logged in, tests whether there is a current user set
#   
  def logged_in?
    !session[:current_user_id].nil?
  end


##
# Default authenticate called before all authorization activity to make
# sure the user is logged
#  
  def authenticate
    session[:current_url] = url_for(params)
    logged_in?
  end
  
  
protected   
#
# Read the session and setup the context for user,project and folder
#
  def setup_context
    User.current    = @current_user    = User.find(session[:current_user_id])       unless session[:current_user_id].nil? 
    Project.current = @current_project = Project.find(session[:current_project_id]) unless session[:current_project_id].nil? 
  end  

  def clear_session
    logger.info("clear_session ")
    session[:current_user_id] = nil
    session[:current_project_id] = nil
    session[:current_username] = 'none'
    session[:current_params] = nil
    @current_project = nil
    @current_user = nil
  end

#
# Current username
#   
  def current_username
     session[:current_username]
  end
##
# Reference to the current User
#       
  def current_user
    if session[:current_user_id]
      @current_user ||= User.find(session[:current_user_id]) 
    else
      @current_user = User.find(GUEST_USER_ID)
      return nil
    end
    User.current = @current_user
  end
##
# Reference to the current project
# 1st checks for a pass parameter of project_id
# 2nd checks for a session project_id
# 3rd find the object
#   
  def current_project
    if session[:current_project_id]  
       @current_project ||= Project.find(session[:current_project_id])
    else
       @current_project ||= Project.find(PUBLIC_PROJECT_ID)
    end
     Project.current = @current_project
  end


  def current_folder
    if session[:current_folder_id]  
       @current_folder ||= ProjectFolder.find(session[:current_folder_id])
    end
    logger.info("current_folder #{@current_folder.name}")
    ProjectFolder.current = @current_folder
  end
#
# Change the Current user in session
# 
  def set_user(user)
      logger.info("set_user #{user.name}")
    if user  
      session[:current_user_id] = user.id    
      session[:current_username] = user.login
      User.current = @current_user = user
    end      
  end 
#
# Change the Current project in session
# 
  def set_project(project)
      logger.info("set_project #{project.name}")
      if project.member(current_user)
         session[:current_project_id] = project.id
         @current_project = project
      else
         show_access_denied      
      end
      return @current_project
  end  
#
# Change the Current folder in session
# 
  def set_folder(folder)
      logger.info("set_folder #{folder.name} ")
      if folder.project.member(current_user)
         session[:current_folder_id] = folder.id
         @current_folder = folder
         ProjectFolder.current = @current_folder
      else
         show_access_denied      
      end
  end  
#
# General error page for access control problems in the system
# 
  def show_access_denied
    redirect_to auth_url(:action => "access_denied")    
    return false
  end
#
# Test whether the user is logged_in
#   
  def show_login
      clear_session
      redirect_to auth_url(:action => "login")
      return false
  end
#
# Clear the session and show the logout form
#  
  def show_logout
      clear_session
      redirect_to auth_url(:action => "logout")
      return false
  end



  def rescue_action_in_public(exception)
      logger.debug "#{exception.class.name}: #{exception.to_s}"
      exception.backtrace.each { |t| logger.debug " > #{t}" }
      case exception
        when ActiveRecord::RecordNotFound, ::ActionController::UnknownController, ::ActionController::UnknownAction
          render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => '404 Not Found'
        else
          render :file => File.join(RAILS_ROOT, 'public/500.html'), :status => '500 Error'
      end
  end

end  # class ApplicationController
