# == Description
# User Dashboard representing user centric actions including the default /home
# display dashboard seen by a user.
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
#
class HomeController < ApplicationController

  use_authorization :project,
    :use => [:index,:show,:edit,:projects,:calendar,:timeline,:blog,:destroy]

  helper :calendar
  DEFAULT_CALENDAR_OPTIONS = {  'month' => Date.today.month,
    'year'=> Date.today.year,
    'items'=> {'task'=>1},
    'states' =>{'0'=>'new','1'=>'accepted','2'=>'waiting','3'=>'processing','4'=>'validation'} } unless defined? DEFAULT_CALENDAR_OPTIONS
                  
  def index
    show
  end
  # 
  # Show the default user dashboard
  # 
  def show
    @user = current_user    
    respond_to do | format |
      format.html { render :action => 'show'}
      format.xml {render :xml =>  @user.to_xml()}
    end
  end

  def edit
    @user = current_user
    @languages = [['English','en'],['French','fr'],['German','de']]
    @project_list = current_user.project_list
    @options = box_list
    respond_to do | format |
      format.html { render :action => 'edit'}
      format.xml {render :xml =>  @user.to_xml()}
    end
  end

  def update
    @user = current_user
    @options = box_list

    UserSetting.home_tab1 = params[:home_tab1]
    UserSetting.home_tab2 = params[:home_tab2]
    UserSetting.home_tab3 = params[:home_tab3]
    UserSetting.home_tab4 = params[:home_tab4]
    UserSetting.home_tab5 = params[:home_tab5]
    UserSetting.home_tab6 = params[:home_tab6]
    UserSetting.default_project_id = params[:default_project_id]
    UserSetting.default_language   = params[:default_language]
    respond_to do | format |
      format.html { redirect_to :action => 'show'}
      format.xml {render :xml =>  @user.to_xml()}
    end
  end
  # 
  # List news for the user
  # 
  def news
    @report = Biorails::SystemReportLibrary.project_content_list("#{current_user.name } News") do | report |
      report.column('updated_by_user_id').filter = current_user.id
    end
    respond_to do | format |
      format.html { render :action => 'report' }
      format.xml  { render :xml => {   :rows  => @report.run.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report, :data =>@data } 
        end 
      }
    end
  end
  
  def todo
    @report = Biorails::SystemReportLibrary.user_queued_items_list("Queued #{current_user.name}") do | report |
      report.column('assigned_to_user_id').filter =current_user.id
    end
    respond_to do | format |
      format.html { render :action => 'report' }
      format.xml  { render :xml => {   :rows  => @report.run.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report } 
        end 
      }
    end
  end

  def requests
    @report = Biorails::SystemReportLibrary.user_request_list("Requests #{current_user.name}") do | report |
      report.column('requested_by_user_id').filter = current_user.id
    end
    respond_to do | format |
      format.html { render :action => 'report' }
      format.xml  { render :xml => {   :rows  => @report.run.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report } 
        end 
      }
    end
  end

  
  def domains
    @report = Biorails::SystemReportLibrary.domains_list("Domains List") do | report |
      report.column('created_by_user_id').filter = current_user.id      
    end
    respond_to do | format |
      format.html { render :action => 'report' }
      format.xml  { render :xml => {   :rows  => @report.run.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report} 
        end 
      }
    end    
  end


  def tasks
    @report = Biorails::SystemReportLibrary.task_list("Tasks #{current_user.name}") do | report |
      report.column('created_by_user_id').filter = current_user.id
    end
    respond_to do | format |
      format.html { render :action => 'report' }
      format.xml  { render :xml => {   :rows  => @report.run.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   {
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report}
        end
      }
    end
  end

  # ## Generate a calendar in a number of formats
  # 
  def calendar
    @user = current_user
    
    @options = DEFAULT_CALENDAR_OPTIONS.merge(params)
    started = Date.civil(@options['year'].to_i,@options['month'].to_i,1)   

    find_options = {:conditions=> "project_elements.state_id in ( #{ @options['states'].keys.join(',') } )"}

    @calendar = CalendarData.new(started,1)
    @user.tasks.add_into(@calendar,find_options)               if @options['items']['task']
    @user.experiments.add_into(@calendar,find_options)         if @options['items']['experiment']
    @user.requested_services.add_into(@calendar,find_options)  if @options['items']['request']
    @user.queue_items.add_into(@calendar,find_options)         if @options['items']['queue']


    respond_to do | format |
      format.html { render :action => 'calendar' }
      format.json { render :json => {:user=>@user,:items=>@calendar.items}.to_json }
      format.xml  { render :xml => {:user=>@user,:items=>@calendar.items}.to_xml }
      # @todo enable mime etc for ical     format.ical  { render :text =>
      # @calendar.to_ical }
      format.js   { 
        render :update do | page |
          page.replace_html 'center',  :partial => 'calendar' 
          page.replace_html 'status',  :partial => 'calendar_right' 
        end 
      }
    end
  end
  
  
  def password
    @user = User.current
    if params[:user]
      unless (params[:user][:old_password].blank? or params[:user][:password].blank?)
        @user.name = params[:user][:name]    
        @user.fullname = params[:user][:fullname]         
        if @user.reset_password(params[:user][:old_password],
            params[:user][:password],
            params[:user][:password_confirmation])
          logger.warn flash[:info] = "Password changed!"
          return redirect_to(home_url())
        else
          logger.debug @user.errors.full_messages.join(",")
        end
      else
        logger.warn flash[:info] = "Valid old and new password needed to update record"
      end
    end
    render :action=>'password'
  end


  # Display of Gantt chart of task in  the project This will need to show
  # assays,experiments and tasks in order
  # 
  def gantt
    @user = current_user
    @options ={ 'month' => Date.today.month,
      'year'=> Date.today.year,
      'items'=> {'task'=>1},
      'states' =>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4} }.merge(params)
    find_options = {:conditions=> "state_id in ( #{ @options['states'].keys.join(',') } )"}
                    
    if params[:year] and params[:year].to_i >0
      @year_from = params[:year].to_i
      if params[:month] and params[:month].to_i >=1 and params[:month].to_i <= 12
        @month_from = params[:month].to_i
      end
    else
      @month_from ||= (Date.today << 1).month
      @year_from ||= (Date.today << 1).year
    end
    
    @zoom = (params[:zoom].to_i > 0 and params[:zoom].to_i < 5) ? params[:zoom].to_i : 2
    @months = (params[:months].to_i > 0 and params[:months].to_i < 25) ? params[:months].to_i : 6
    
    @date_from = Date.civil(@year_from, @month_from, 1)
    @date_to = (@date_from >> @months) - 1
    @tasks = current_user.tasks.range( @date_from, @date_to,50,find_options)  

    render :action => "gantt.rhtml"
  end

  # 
  # Create a Tree data model
  # 
  def tree
    if params[:node] == 'root'
      @elements = ProjectElement.list(:all,
        :conditions=>'project_elements.parent_id is null',
        :order=>'project_elements.name')
      @chain = current_element.self_and_ancestors
      return render(:inline => '<%= elements_to_json_tree(@elements,@chain) %>')
    else  
      @elements = ProjectElement.list(:all,
        :conditions =>['project_elements.parent_id = ?',params[:node] ],
        :order=>'project_elements.left_limit')
    end
    render :inline => '<%= elements_to_json_level(@elements) %>'
  end

  protected
  #
  # List of suitable dashboard directories
  # Heeds basic show
  #
  def box_list
    list =[]
    Dir[File.join(RAILS_ROOT,'app','views','home','_box_*')].each do |item|
      unless File.directory?(item)
        filename = File.split(item).last.gsub(/.rhtml*/,'').gsub(/^_/,'')
        name = filename.gsub(/^box_/,'')
        list << [name,filename]
      end
    end
    
    return list.sort
  end
end
