# == Project Dashboard controller
# 
# This manages the creation of new projects and the main pages for a project.
# This should allow easy nagavation to current work in the project.
# 
# === Project 
#
# A project is the top level of organisation of data under each team.  
# It forms the root of a folder system and within a project assays are defined, 
# Requests are made, Documents are published.  The Project is therefore the driving 
# force behind the BioRails system.
#
# Projects in BioRails can map to a variety of real world organisational units. 
# The default are to an assay group or a laboratory or a discovery project. 
# The difference between the two is simply shown in the contents of their respective home pages, 
# with assay groups being focused around defining assays and running experiments.
#
# Projects are owned by teams.  The members of the teams carry over their team role to these projects. 
# 
# == Copyright
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ProjectsController < ApplicationController

 use_authorization :project,
    :actions => [:index,:show,:projects,:calendar,:timeline,:blog,:destroy],
    :rights => :current_user  
 
  before_filter :setup_project ,
    :only => [ :show, :edit, :share, :publish, :update, :destroy, :members, :calendar,:gantt,:tree,:list_signed_files]
  
  helper :calendar
  
  in_place_edit_for :project, :name
  in_place_edit_for :project, :summary
  # ## Generate a index projects the user can see
  # 
  # @return list of projects in html,xml,csv,json or as diagram page update
  # 
  # 
  def index
    @projects = User.current.projects(100)
    respond_to do |format|
      format.html { render :action=>'index'}
      format.xml  { render :xml => @projects.to_xml }
      format.csv  { render :text => @projects.to_csv }
      format.json { render :json =>  @projects.to_json } 
    end
  end    
    
  def list
    index
  end
  

  # ## Generate a dashboard for the project
  # 
  def show
    respond_to do | format |
      format.html { render :templage=> @project.project_type.action_template(:show)}
      format.xml {render :xml =>  @project.to_xml(:include=>[:team,:folders,:assays,:experiments,:tasks])}
      format.json  { render :text => @project.to_json }
    end

  end
  
  # 
  # Show new project form
  # 
  def new
    @project = Project.new()
    @project.project_type_id = params[:type]||1
    @user = current_user
    respond_to do |format|
      format.html # new.rhtml
      format.xml  { render :xml => @project.to_xml }
      format.json  { render :text => @project.to_json }
    end 
  end
  # 
  # Create a new project #Create
  def create
    @project = current_user.create_project(params['project'])
    if @project.save
      flash[:notice] = "Project was successfully created."
      set_project(@project)
      redirect_to(:action => 'show', :id => @project )  
    else
      render :action=>"new", :id=>@project 
    end
  end
  # 
  # Edit the project
  # 
  def edit
    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml {render :xml =>  @project.to_xml}
      format.json  { render :text => @project.to_json }
    end
  end
  # 
  # Update model and change to show project
  # 
  def update
    Project.transaction do
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        respond_to do |format|
          format.html { redirect_to  :action => 'show',:id => @project    }
          format.xml  { head :created, :location => projects_url(@project   ) }
        end   
      else
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @projects.errors.to_xml }
        end
      end
    end
  end
    
  
  # ## Destroy a assay
  # 
  def destroy
    @project.destroy
    set_project(Project.find(1))    
    respond_to do |format|
      format.html { redirect_to home_url(:action => 'index') }
      format.xml  { head :ok }
    end
  end  
  
  
  def share
    respond_to do |format|
      format.html { render :action => 'share'}
      format.xml {render :xml =>  @project.to_xml}
      format.json  { render :text => @project.to_json }
    end    
  end

  def publish
    respond_to do |format|
      format.html { render :action => 'share'}
      format.xml {render :xml =>  @project.to_xml}
      format.json  { render :text => @project.to_json }
    end    
  end

  # ## Show a overview calendar for the project this should list the
  # experiments, documents etc linked into the project
  # 
  def calendar
    @options ={ 'month' => Date.today.month,
      'year'=> Date.today.year,
      'items'=> {'task'=>1},
      'states' =>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4} }.merge(params)
 
    logger.debug " Calendar for #{@options.to_yaml}"

    started = Date.civil(@options['year'].to_i,@options['month'].to_i,1)   

    find_options = {:conditions=> "status_id in ( #{ @options['states'].keys.join(',') } )"}

    @calendar = CalendarData.new(started,1)
    @project.tasks.add_into(@calendar,find_options)               if @options['items']['task']
    @project.experiments.add_into(@calendar,find_options)         if @options['items']['experiment']
    @project.assays.add_into(@calendar,find_options)             if @options['items']['assay']
    @project.requests.add_into(@calendar,find_options)            if @options['items']['request']
    @project.requested_services.add_into(@calendar,find_options)  if @options['items']['service']
    @project.queue_items.add_into(@calendar,find_options)         if @options['items']['queue']

    respond_to do | format |
      format.html { render :action => 'calendar' }
      format.json { render :json => {:project=> @project, :items=>@calendar.items}.to_json }
      format.xml  { render :xml => {:project=> @project,:items=>@calendar.items}.to_xml }
      format.js   { render :update do | page |
          page.replace_html 'center',  :partial => 'calendar' 
          page.replace_html 'status',  :partial => 'calendar_right' 
        end }
      format.ics  { render :text => @calendar.to_ical}
    end
  end  

  # ## Display of Gantt chart of task in  the project This will need to show
  # assays,experiments and tasks in order
  # 
  def gantt
    @options ={ 'month' => Date.today.month,
      'year'=> Date.today.year,
      'items'=> {'task'=>1},
      'states' =>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4} }.merge(params)
    find_options = {:conditions=> "status_id in ( #{ @options['states'].keys.join(',') } )"}
                    
    if params[:year] and params[:year].to_i >0
      @year_from = params[:year].to_i
      if params[:month] and params[:month].to_i >=1 and params[:month].to_i <= 12
        @month_from = params[:month].to_i
      else
        @month_from = 1
      end
    else
      @month_from ||= (Date.today << 1).month
      @year_from ||= (Date.today << 1).year
    end
    
    @zoom = (params[:zoom].to_i > 0 and params[:zoom].to_i < 5) ? params[:zoom].to_i : 2
    @months = (params[:months].to_i > 0 and params[:months].to_i < 25) ? params[:months].to_i : 6
    
    @date_from = Date.civil(@year_from, @month_from, 1)
    @date_to = (@date_from >> @months) - 1
    @tasks = @project.tasks.range( @date_from, @date_to,50,find_options)  
    
    @options_for_rfpdf ||= {}
    @options_for_rfpdf[:file_name] = "gantt.pdf"

    respond_to do | format |
      format.html { render :action => 'gantt' }
      format.ext { render :action => 'gantt', :layout => false }
      format.pdf { render :action => "gantt_print.rfpdf", :layout => false }
      format.json { render :json => {:project=> @project, :items=>@tasks}.to_json }
      format.xml  { render :xml =>  {:project=> @project,:items=>@tasks}.to_xml }
      format.js   { 
        render :update do | page |
          page.main_panel   :partial => 'gantt' 
          page.status_panel   :partial => 'gantt_status'
        end
      }
    end
  end

  protected

  def setup_project
    if params[:id]
      @project = Project.load(params[:id])
      if @project        
        set_project(@project)
        set_element(@project.home)  
      end
    else 
      @project = current_project  
    end
    return show_access_denied unless @project
  end
end
