##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

##
# Project Dashboard controller
# 
# This manages the creation of new projects and the main pages for a project. This should allow easy
#  nagavation to current work in the project. 
#
#
class Project::ProjectsController < ApplicationController

  use_authorization :project,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights =>  :current_project  

  helper :calendar
  
  in_place_edit_for :project, :name
  in_place_edit_for :project, :summary
##
# Generate a index projects the user can see
# 
# @return list of projects in html,xml,csv,json or as diagram page update
#  
#   
  def index
    @projects = User.current.projects
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @projects.to_xml }
      format.csv  { render :text => @projects.to_csv }
      format.json { render :json =>  @projects.to_json } 
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial =>'list'
          page.model_datagrid(Project)
       end 
      }
    end
  end

##
# Generate a dashboard for the project 
#  
  def show
    setup_project
    respond_to do | format |
      format.html { render :action => 'show'}
      format.xml {render :xml =>  @project.to_xml(:include=>[:memberships,:folders,:studies,:experiments,:tasks])}
      format.json  { render :text => @project.to_json }
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'show'
       end      
      }
    end

  end
  
#
# Show new project form
# 
  def new
    @project = Project.new
    @user = current_user
	respond_to do |format|
      format.html # new.rhtml
      format.xml  { render :xml => @project.to_xml }
      format.json  { render :text => @project.to_json }
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'new'
        end
      }
     end 
  end
#
# Create a new project
#Create
  def create
    Project.transaction do
	  @project = current_user.create_project(params['project'])
	  @project.summary = params[:project][:summary]
 	  if @project.save
		  flash[:notice] = "Project was successfully created."
		  set_project(@project)
		  respond_to do |format|
			  format.html { redirect_to  :action => 'show',:id => @project    }
			  format.xml  { head :created, :location => projects_url(@project   ) }
			  format.js  { render :update do | page |  
				  page.actions_panel  :partial => 'actions'
				  page.help_panel     :partial => 'help'
				  page.status_panel   :partial => 'status'
				  page.main_panel     :partial => 'show'
				end
			   }
			end   
  	  else
		  respond_to do |format|
			  format.html { render :action => "new" }
			  format.xml  { render :xml => @projects.errors.to_xml }
			  format.js  { render :update do | page |  
				  page.actions_panel  :partial => 'actions'
				  page.help_panel     :partial => 'help'
				  page.status_panel   :partial => 'status'
				  page.main_panel     :partial => 'new'
				end
			   }
			end
	  end
    end
  end
#
# Edit the project
# 
  def edit
    setup_project
    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml {render :xml =>  @project.to_xml}
      format.json  { render :text => @project.to_json }
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'edit'
        end
      }
    end
  end
#
# Update model and change to show project
#
  def update
    Project.transaction do
      @project = current_user.project(params[:id])
      if @project.update_attributes(params[:project])
          flash[:notice] = 'Project was successfully updated.'
		  respond_to do |format|
			  format.html { redirect_to  :action => 'show',:id => @project    }
			  format.xml  { head :created, :location => projects_url(@project   ) }
			  format.js  { render :update do | page |  
				  page.actions_panel  :partial => 'actions'
				  page.help_panel     :partial => 'help'
				  page.status_panel   :partial => 'status'
				  page.main_panel     :partial => 'show'
				end
			   }
			end   
      else
		  respond_to do |format|
			  format.html { render :action => "edit" }
			  format.xml  { render :xml => @projects.errors.to_xml }
			  format.js  { render :update do | page |  
				  page.actions_panel  :partial => 'actions'
				  page.help_panel     :partial => 'help'
				  page.status_panel   :partial => 'status'
				  page.main_panel     :partial => 'edit'
				end
			   }
			end
      end
    end
  end
  
##
# Destroy a study
#
  def destroy
    setup_project
    @project.destroy
    set_project(Project.find(1))    
    respond_to do |format|
      format.html { rredirect_to home_url(:action => 'index') }
      format.xml  { head :ok }
      format.js  { render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'list'
          end
      }
    end
  end  

##
# List of the membership of the project
# 
  def members
    setup_project
    @membership = Membership.new(:project_id=>@project)
    respond_to do | format |
      format.html { render :action => 'members'}
      format.xml {render :xml =>  @project.to_xml(:include =>[:memberships,:owners,:users])}
    end
  end
##
# Show a overview calendar for the project this should list the experiments, documents etc linked into the project
# 
  def calendar
     setup_project
     @options ={ 'month' => Date.today.month,
                'year'=> Date.today.year,
                'items'=> {'task'=>1},
                'states' =>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4} }.merge(params)
 
    logger.info " Calendar for #{@options.to_yaml}"

    started = Date.civil(@options['year'].to_i,@options['month'].to_i,1)   

    find_options = {:conditions=> "status_id in ( #{ @options['states'].keys.join(',') } )"}

    @calendar = CalendarData.new(started,1)
    @project.tasks.add_into(@calendar,find_options)               if @options['items']['task']
    @project.experiments.add_into(@calendar,find_options)         if @options['items']['experiment']
    @project.studies.add_into(@calendar,find_options)             if @options['items']['study']
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

##
# Display of Gantt chart of task in  the project
# This will need to show studies,experiments and tasks in order
#   
  def gantt
     setup_project
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
      format.js   { render :update do | page |
           page.main_panel   :partial => 'gantt' 
           page.status_panel   :partial => 'gantt_status'
         end }
    end
  end

#
# Render node information to the project tree control
#
  def tree
    setup_project
    respond_to do | format |
      format.html { render :partial => 'tree'}
      format.json { render :partial => 'tree'}
    end
  end

protected

  def setup_project
	if params[:id]
	  @project = current_user.project(params[:id])
	  set_project(@project)
	else 
	  @project = current_project  
    end
  end
end
