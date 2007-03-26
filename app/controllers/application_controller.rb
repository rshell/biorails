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
 
 
  before_filter :authorise 

#set norfello style layout
# layout 'norfello'

   uses_tiny_mce(:options => {:theme => 'advanced',
                           :browsers => %w{msie gecko},
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :auto_resize => true,
                           :theme_advanced_resizing => true,
                           :theme_advanced_statusbar_location => "bottom",
                           :paste_auto_cleanup_on_paste => true,
                           :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent separator bullist numlist forecolor backcolor separator link unlink image undo redo},
                           :theme_advanced_buttons2 => [],
                           :theme_advanced_buttons3 => [],
                           :plugins => %w{contextmenu paste}},
              :only => [:new, :edit, :show, :index])  


  def current_user
    if session[:user_id]
       @user ||= User.find(session[:user_id]) 
    else
       @user ||= User.find(1) 
    end
    return @user
  end

  def authorise
    #return if ENV['RAILS_ENV'] != 'development'
    begin
       @settings = SystemSettings.find(1)
    rescue Exception => ex
      logger.error "authorise error: #{ex.message}"
    end
    
    if @settings
      make_public = false  # Going to check if we need to
      if session[:user_id]
        if session[:last_time] != nil and (Time.now - session[:last_time]) > @settings.session_timeout
            logger.info "Session: time expired"
            AuthController.logout(session)
            redirect_to @settings.session_expired_page.url
            return
        end
      end             
      @role = Role.find(session[:role_id]||:first)
      session[:credentials] = @role.credentials
      session[:menu] = @role.menu

      
      # If this is a page request check that it exists, and if not
      # redirect to the "unknown" page
      if params[:controller] == 'content_pages' and    params[:action] == 'view'
        if not @role.credentials.pages.has_key?(params[:page_name].to_s)
          logger.warn "(Unknown page? #{params[:page_name].to_s})"
          redirect_to @settings.not_found_page.url
          return
        end
      end
      if  params[:controller] == 'data_capture' 
        return true
      end
      # PERMISSIONS
      # Check whether the user is authorised for this page or action.
      if not AuthController.authorised?(@role.credentials, params)
        redirect_to @settings.permission_denied_page.url
        return
      end
    end  # if @settings
    
    session[:last_time] = Time.now
    
  end  # def authorise


##
# Get the lastest object of this type in the system
  def lastest(clazz)
      return clazz.find(:first, :order => 'updated_at desc')
  rescue Exception => ex
      logger.error "lastest(#{clazz}) error: #{ex.message}"
      return clazz.new
  end 

##
# Get lastest instance of this model im likly to be interested in
# 
  def my_lastest(model)
      #if session[:user]
      #instance = model.find(:first,:condition=>['updated_by=?',session[:user]],:order=>'updated_at desc')
      #end
      #if instance.nil?
          instance = model.find(:first,:order=>'updated_at desc')
      #end
      if instance.nil?
         instance = model.find(:first)
      end
      return instance
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


  def current_user
      @user ||= session[:user]
  end

protected   

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
  
    
end  # class ApplicationController
