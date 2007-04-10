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
 
 #audit DataConcept,DataContext,DataSystem,DataElement,DataFormat,DataType,
 #      Study,StudyProtocol,StudyParameter,
 #      ProtocolVersion,ParameterContext,Parameter,
 #      Experiment,Task
 
##
# Help functionailty has been divided up into a number areas to keep modules readable 
  helper SortHelper    # Dynamic table sort
  helper FormHelper    # Various Form helper and custom controllers
  helper FormatHelper  # Extra formating rules for date,times etc
  helper SessionHelper # Various session/parameter cache and lookup function
  helper TreeHelper # Tree display helpers
  include SessionHelper # Various session/parameter cache and lookup function
  include TinyMCE
 
  include Biorails::CachingMethods

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_Biorails2_session_id'


#  cattr_accessor :project_count
#  before_filter  :set_cache_root
#  helper_method  :project
#  attr_reader    :project


#set norfello style layout
# layout 'norfello'

  uses_tiny_mce(:options => {
     :theme => 'advanced',
     :browsers => %w{msie,gecko,opera,safari},
     :theme_advanced_toolbar_location => "top",
     :theme_advanced_toolbar_align => "left",
     :auto_resize => false,
     :theme_advanced_resizing => true,
     :theme_advanced_statusbar_location => "bottom",
     :paste_auto_cleanup_on_paste => true,
     :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent bullist numlist separator help},
     :theme_advanced_buttons3 => [],
     :plugins => %w{contextmenu paste }
     },
      :only => [:new, :edit, :show, :index])  



  class_inheritable_reader :check_permissions
  write_inheritable_attribute :check_permissions, []

 ##
# Test whether the user is logged_in
#   

  def prompt_login
      redirect_to :controller => "account", :action => "login"
      return false
  end

##
# Get the lastest object of this type in the system
  def lastest(clazz)
      return clazz.find(:first, :order => 'updated_at desc')
  rescue Exception => ex
      logger.error "lastest(#{clazz}) error: #{ex.message}"
      return clazz.new
  end 

  
  
##
# Get current version of this model passed on param[:id] and
# if not found the current session
#
  def current(model,id=nil)
    key = "#{model.to_s}_id"
    if !id.nil? and !id.empty?
        instance = model.find(id)
    elsif instance.nil? && session[key]
        instance = model.find(session[key])
    else
        instance = lastest(model)
    end
    session[:controller]=key.downcase.tableize
    session[key]= instance.id
    return instance
  rescue Exception => ex
      logger.error "current error: #{ex.message}"
      return lastest(model)
  end
   
protected   
##
# standard authorization method.  allow logged in users that are admins, or members in certain actions
#
  def authorized?
      return true if !check_permissions.include?(session[:action]) # not checked
      logged_in? && (admin? || member_actions.include?(action_name) || allow_member?)
  end

##
# Default report to build if none found in library
#    
  def report_list_for(name,model)
    report = Report.new
    report.model=model
    report.name = name || "#{model}List"
    report.description = "Default reports for display as /#{model.to_s}/list"
    report.column('id').is_visible = false
    return report
  end

##
# Generate a default report to display all the reports in the list of types
  def reports_on_models(name,list)
   report = Report.new
   report.model = Report
   report.name = name
   report.description = "#{name} list of all #{list.join(',')} centric reports on the system"
   report.column('custom_sql').is_visible=false
   report.column('id').is_visible = false
   column = report.column('base_model')
   column.filter_operation = 'in'
   column.filter_text = "("+list.collect{|item|"'#{item.to_s}'"}.join(",")+")"
   column.is_filterible = false
   return report
  end
 
  def show_error(message = 'An error occurred.', status = '500 Error')
      render_liquid_template_for(:error, 'message' => message, :status => status)
  end

  def show_404
      show_error 'Page Not Found', '404 NotFound'
  end

  def with_project_timezone
      old_tz = ENV['TZ']
      ENV['TZ'] = project.timezone.name
      yield
      ENV['TZ'] = old_tz
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
