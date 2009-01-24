# == Description
# 
# Main Application controller with a log of the key application aspects for user
# authorization, authentatations etc. It basically provides a number 
# of helper methods for use in your controllers :-
# 
# * current_user
# * current_team
# * current_project
# 
# These are automatically filled with session level context at the start of a request.
#  
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ApplicationController < ActionController::Base
  layout 'biorails3'

  # #audit DataConcept,DataContext,DataSystem,DataElement,DataFormat,DataType,
  #      Assay,AssayProtocol,AssayParameter,
  #      ProtocolVersion,ParameterContext,Parameter,
  #      Experiment,Task
 
  # ## Help functionailty has been divided up into a number areas to keep
  # modules readable
  helper Execute::ReportsHelper
  helper FormHelper    # Various Form helper and custom controllers
  helper FormatHelper  # Extra formating rules for date,times etc
  helper SessionHelper # Various session/parameter cache and lookup function

  # 
  # Stuff best not to out to the log file. like passwords
  # 
  filter_parameter_logging :password,:login

  # 
  # Filter actions to automiatcally setup current project,user,folder context
  # from session
  # 
  before_filter :setup_context
  # 
  # share session management methods with helpers
  # 
  helper_method :logged_in?
  helper_method :has_rights?
  helper_method :right?
  helper_method :current_user
  helper_method :current_team
  helper_method :current_project
  helper_method :current_username
  helper_method :current_element
  helper_method :current_clipboard
  helper_method :browser_is?
  helper_method :get_browser
  helper_method :object_to_url
  helper_method :element_to_url
  helper_method :reference_to_url
 
  protected #----- End of public actions --------------------------------------------------------------------------------

  # ## Get current version of this model passed on param[:id] and if not found
  # the current session
  #  1) model instance with passed id
  #  2) model instance cached in session
  #  3) last edited model instance
  # 
  # @param model @parm id
  # 
  # @return object
  # 
  def current(model,id=nil)
    logger.debug "current(#{model},#{id})"
    key = "#{model.to_s}_id"
    instance = model.find(id) if id
    instance ||= model.find(session[key]) if session[key]
    instance ||= current_user.latest(model) if logged_in?
    session[key]= instance.id if instance
    return instance
  rescue Exception => ex
    logger.error "current error: #{ex.message}"
    nil
  end

  # 
  # Read the session and setup the context for user,project and folder This is
  # used to set the currrent in User,Project and ProjectFolder
  # 
  def setup_context
    begin  
      Notification.default_url_options[:host]= request.host
      User.current          = @current_user    = User.find(session[:current_user_id])       unless session[:current_user_id].blank? 
      Project.current       = @current_project = Project.find(session[:current_project_id]) unless session[:current_project_id].blank? 
      ProjectFolder.current = @current_element = ProjectElement.load(session[:current_element_id]) unless session[:current_element_id].blank? 
      @current_controller = controller_name
      @clipboard = session[:clipboard] ||= Clipboard.new
      return true
    rescue Exception => ex
      flash[:warning] ="Invalid session information user or project invalid, prompting to login again "
      logger.warn "Session appears invalid "+ex.message
      logger.debug ex.backtrace.join("\n") 
      clear_session
      return false
    end  
  end  
  # 
  # Clean out the session
  # 
  def clear_session
    logger.info("clear_session ")
    @current_element = nil
    @current_project = nil
    @current_user = nil
    session[:current_user_id] = nil
    session[:current_project_id] = nil
    session[:current_element_id] = nil
    session[:clipboard] = nil
  rescue 
    nil
  end

  # ## Default authorization function allow anything generally overridden in
  # controllers via use_authorization definition
  # 
  def authorize
    return true
  end   

  # ## is there a user logged in, tests whether there is a current user set
  # 
  # @return true/false
  # 
  def logged_in?
    !session[:current_user_id].nil?
  end
  #
  # Rights Check for the current context of folder and user
  #
  def right?(subject,action=nil)
    logged_in? and (current_user.right?(subject,action) or current_element.right?(subject,action))
  end

  # ## Default authenticate called before all authorization activity to make
  # sure the user is logged
  # 
  def authenticate
    if request.get? and params[:controller].to_s !="auth" and not request.xhr?
        session[:last_url] = url_for(params) 
        logger.info "Current url =#{session[:last_url]}"
    end
    logged_in?
  end

  # ## Reference to the current User
  # 
  def current_user
    if session and session[:current_user_id]
      User.current =  User.find(session[:current_user_id]) 
    end
    User.current
  end  
  
  # ## Reference to the current project 1st checks for a pass parameter of
  # project_id 2nd checks for a session project_id 3rd find the object
  # 
  def current_project
    if session and session[:current_project_id]  
      @current_project ||= Project.find(session[:current_project_id])
    end
    @current_project ||= Project.list(:first,:order=>:id)
    @current_project ||= Project.find(:first,:order=>:id)
    Team.current = @current_project.team
    Project.current = @current_project
  end
  # 
  # 
  # 
  def current_element
    if session[:current_element_id]  
      @current_element ||= ProjectElement.find(session[:current_element_id])
    end
    @current_element ||= current_project.folder
    ProjectFolder.current = @current_element
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
  rescue 
    @current_user = nil
  end 
  # 
  # Change the Current project in session
  # 
  def set_project(project)
    logger.info("set_project #{project.name}")
    if current_user.project(project.id) 
      session[:current_project_id] = project.id
      Project.current = @current_project = project
    else
      return show_access_denied      
    end
    return @current_project
  rescue 
    @current_project = nil
  end  
  # 
  # Change the Current folder in session
  # 
  # ## Simple helpers to get the current folder from the session or params
  # 
  def set_element( element_id = nil)
    @current_element =  current_project.home if element_id.nil?
    @current_element =  ProjectElement.load(element_id) 
    if @current_element
      ProjectFolder.current = @current_element
      logger.info("set_folder #{@current_element.name} ")
      session[:current_element_id] = @current_element.id
      return @current_element
    else
      session[:current_element_id] = nil
      @current_element = nil
    end
  rescue 
    @current_element = nil
  end  
  # 
  # General error page for access control problems in the system
  # 
  def show_access_denied
    flash[:error]= "Access denied for url #{url_for(params)}"
    respond_to do | format |
      format.html { render :template => '/auth/access_denied' }
      format.ext  { render :partial => 'auth/access_denied' }
      format.js   {
         render :update do | page |
           page.replace_html 'center',  :partial => 'auth/access_denied'
           page.replace_html 'messages',  :partial => 'shared/messages'
         end
         }
    end
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
  # Context a node to objects
  # 
  # This is used for convertopn of dom_id to the correct object
  # 
  def from_dom_id(node)
    ModelExtras.from_dom_id(node)
  end
  # 
  # Load the clipboard for the current session
  # 
  def current_clipboard
    @clipboard ||= session[:clipboard] ||= Clipboard.new
  end
  # 
  # Save the clipboard for the current session
  # 
  def save_clipboard( item = nil)
    session[:clipboard] = item || @clipboard
  end
  # 
  # Render a page as PDF for output based on current html
  # 
  def render_pdf(filename,options={})
     html = render_to_string(options)
     send_as('pdf',filename,html)
  end

  def send_as(type,filename,html)
    format = Alces::OpenOffice::FormatConverter.format(type)
    @@public_root ||= File.join(RAILS_ROOT,"public")
    file = Tempfile.new("temp.html")
    html = html.gsub(/src="\/(.*)\?(.*)"/,"src=\"#{@@public_root}/\\1\"")
    html = html.gsub(/link href="\/(.*)\?(.*)"/,"link href=\"#{@@public_root}/\\1\"")
    file << html
    file.close
    formatter = Alces::OpenOffice::FormatConverter.new(type)
    output_file = formatter.convert(file.path)
    if output_file
      return send_file( output_file,:filename=>filename,  :type => format[:mime])
    else
      formatter.errors.each{|error| logger.warn " PDF '#{filename} create problem: #{error}"}
      return render :inline => formatter.results
    end
  end

  def underscore(filename)
    filename.gsub!(/\s/,'_') || filename
  end
  # 
  # Test what the client browser is
  # 
  def browser_is? name
    name = name.to_s.strip
    return true if browser_name == name
    return true if name == 'mozilla' && browser_name == 'gecko'
    return true if name == 'ie' && browser_name.index('ie')
    return true if name == 'webkit' && browser_name == 'safari'
  end
  # 
  # Get the Browser Name
  # 
  def browser_name(req=request)
    @browser_name ||= begin
      return 'test' unless req.env['HTTP_USER_AGENT']
      ua = req.env['HTTP_USER_AGENT'].downcase
      if ua.index('msie') && !ua.index('opera') && !ua.index('webtv')
        'ie'+ua[ua.index('msie')+5].chr
      elsif ua.index('gecko/') 
        'gecko'
      elsif ua.index('opera')
        'opera'
      elsif ua.index('konqueror') 
        'konqueror'
      elsif ua.index('applewebkit/')
        'safari'
      elsif ua.index('mozilla/')
        'gecko'
      end
    end
  end
  ##
# Convert a type/id reference into a url to the correct controlelr
#    
  def object_to_url( object,options = {:action=>'show'})
    return "" unless object
    id = object.id
    if object
      case  object
      when ProjectAsset then    asset_url(   options.merge(  { :id=>id ,:folder_id=>object.parent_id}) )
      when ProjectContent then  content_url( options.merge({ :id=>id ,:folder_id=>object.parent_id}) )
      when ProjectElement then  folder_url(  options.merge( { :id=>id ,:folder_id=>object.parent_id}) )
      when RequestService then  request_url( options.merge({:id=>object.request.id}) )
      when ProjectElement then  folder_url(  options.merge({ :id=>id} ) )
      when ProjectFolder then   folder_url(  options.merge({ :id=>id} ) )
      when AssayProtocol then   assay_url(   options.merge({ :id=>object.assay_id})  )
      when AssayQueue then      queue_url(   options.merge({ :id=>id})  )
      when SystemReport then    system_report_url( options.merge({:id=>id})  )
      when ProjectReport then   report_url(        options.merge({:id=>id})  )
      else
        begin
          send("#{object.class.to_s.underscore}_url",{:action=>'show',:id=>object.id})         
        rescue Exception => ex
          logger.warn("Cant work out url for #{object.class}.#{object.id}")
          nil
        end
      end
    end
  end  
   
  # ## Convert a element in to a url call to display it
  # 
  def element_to_url(element)
    case element
    when ProjectFolder
      folder_url(:action=>'show', :id=> element.id )
    when ProjectContent
      content_url(:action=>'show', :id=>element.id ,:folder_id=>element.parent_id )
    when ProjectAsset
      asset_url(:action=>'show',:id=>element.id,:folder_id=>element.parent_id )
    when ProjectReference
       object_to_url(element.reference)
    else
      element_url(:action=>'show', :id=>element.id, :folder_id=>element.parent_id )
    end
  end 
  # ## Convert a type/id reference into a url to the correct controlelr
  # 
  def reference_to_url(element)
    case element.attributes['reference_type']
    when 'Project'  then        project_url( :action=>'show', :id=>element.reference_id )
    when 'ProjectContent' then  content_url( :action=>'show', :id=>element.id ,:folder_id=>element.parent_id )
    when 'ProjectAsset'  then   asset_url(   :action=>'show',:id=>element.id,:folder_id=>element.parent_id )

    when 'Assay'  then          assay_url(          :action=>'show', :id=> element.reference_id )
    when 'AssayParameter'  then assay_parameter_url(:action=>'show', :id=> element.reference_id )
    when 'AssayQueue'      then assay_queue_url(    :action=>'show', :id=> element.reference_id )
    when 'AssayProtocol'   then object_to_url(element.reference.latest )
    when 'ProtocolVersion' then object_to_url(element.reference )

    when 'Experiment' then      experiment_url(:action=>'show', :id=> element.reference_id )
    when 'Task' then            task_url(      :action=>'show', :id=> element.reference_id )
    when 'Report' then          report_url(    :action=>'show', :id=> element.reference_id )
    when 'CrossTab' then        cross_tab_url( :action=>'show', :id=> element.reference_id )
    when 'Request' then         request_url(   :action=>'show', :id=> element.reference_id )
    when 'RequestService' then  request_service_url(:action=>'show', :id=> element.reference_id )
    when 'QueueItem' then       request_service_url(:action=>'show', :id=> element.reference.service )
    when 'Compound' then        compound_url(  :action=>'show', :id=> element.reference_id )
    when 'Batch' then           batch_url(     :action=>'show', :id=> element.reference_id )
    when 'CircePlate' then      plate_url(     :action=>'show', :id=> element.reference_id )
    else
      element_to_url(element)
    end
  end   

end  # class ApplicationController
