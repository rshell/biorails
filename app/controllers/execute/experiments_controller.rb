##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

require "faster_csv"

class Execute::ExperimentsController < ApplicationController

  use_authorization :experiment,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_project
                    
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  helper :calendar
##
# default action is linked to list
  def index
    list
    render :action=>'list'
  end

###
# list all the experiments 
# 
  def list
   @project = current_project
   @report = Report.internal_report("ExperimentList",Experiment) do | report |
      report.column('project_id').filter = @project.id
      report.column('project_id').is_visible = false
      report.column('name').customize(:order_num=>1)
      report.column('name').is_visible = true
      report.column('name').action = :show
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   @data_pages = Paginator.new self, @project.experiments.size, 20, params[:page]
   @data = @report.run({:limit  =>  @data_pages.items_per_page,
                        :offset =>  @data_pages.current.offset })
  end

##
# show the current experiment
# 
  def show
    @experiment = current(Experiment,params[:id])
  end

  def metrics
    @experiment = current(Experiment,params[:id]) 
  end

  def calendar
    @experiment = current(Experiment,params[:id]) 
    @options ={ 'month' => Date.today.month,
                'year'=> Date.today.year,
                'items'=> {'task'=>1},
                'states' =>{'0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4} }.merge(params)
    @user = current_user

    started = Date.civil(@options['year'].to_i,@options['month'].to_i,1)   
    find_options = {:conditions=> "status_id in ( #{ @options['states'].keys.join(',') } )"}

    @calendar = CalendarData.new(started,1)
    @experiment.tasks.add_into( @calendar,find_options)               if @options['items']['task']
    @experiment.queue_items.add_into( @calendar,find_options)         if @options['items']['queue']

    respond_to do | format |
      format.html { render :action => 'calendar' }
      format.json { render :json => {:experiment=>@experiment,:items=>@calendar.items}.to_json }
      format.xml  { render :xml => {:experiment=>@experiment,:items=>@calendar.items}.to_xml }
      format.js   { render :update do | page |
           page.replace_html 'centre',  :partial => 'calendar' 
           page.replace_html 'right',  :partial => 'calendar_right' 
         end }
      #format.ical  { render :text => @schedule.to_ical}
    end
  end

##
# Display of Gantt chart of task in  the project
# This will need to show studies,experiments and tasks in order
#   
  def timeline
    @experiment = current(Experiment,params[:id]) 
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
    @tasks = @experiment.tasks.range( @date_from, @date_to,50,find_options)  

    if params[:output]=='pdf'
      @options_for_rfpdf ||= {}
      @options_for_rfpdf[:file_name] = "gantt.pdf"
      render :action => "gantt.rfpdf", :layout => false
    else
      render :action => "timeline.rhtml"
    end
  end
##
# create a new experiment
  def new
    @study = current( Study, params[:id] ) if  params[:id]
    @study ||= current_project.studies.find(:first)
    @experiment = Experiment.new(:study_id=>@study.id, :name=> Identifier.next_user_ref)
    @experiment.project = current_project
    @experiment.description = " Experiment in project #{current_project.name} "  
  end

  def copy
    @experiment = current( Experiment, params[:id] ).copy    
    @schedule = Schedule.tasks_in(@experiment)    
    render :action => 'show'
  end
##
# Return from new to create a Experiment record
  def create
    @experiment = Experiment.new(params[:experiment])
    if @experiment.process
        @experiment.protocol = @experiment.process.protocol 
    elsif  @experiment.protocol
        @experiment.process = @experiment.protocol.process 
    end
    @experiment.project = current_project
    if @experiment.save
      current_project.folder(@experiment)    
      flash[:notice] = 'Experiment was successfully created.'
      redirect_to :action => 'show', :id => @experiment.id
    else
      render :action => 'new'
    end
  end

##
# Edit a experiment details
# 
  def edit
    @experiment = current( Experiment, params[:id] )
  end

##
# Update a existing experiment
# 
  def update
    @experiment = current( Experiment, params[:id] )
    if @experiment.update_attributes(params[:experiment])
      flash[:notice] = 'Experiment was successfully updated.'
      redirect_to :action => 'show', :id => @experiment
    else
      render :action => 'edit'
    end
  end

##
# Delete the passed experiment
# 
  def destroy
    Experiment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

##
# Output a timeline for the experiment
  def changes
    if params[:id]
      @logs = current( Experiment, params[:id] ).logs
    else  
      @logs = ExperimentLog.find(:all,:limit=>100, :order=>'id desc')
    end
  end 

###
# Refresh the list of allowed protocols
#
  def refresh_allowed_protocols
     text = request.raw_post || request.query_string
     puts text
     study = Study.find(text)
     @items = study.protocols
     @experiment = Experiment.new
     @experiment.protocol = @items[0]
     render :partial =>'allowed_protocols' , :layout => false
  end

#
#  export Report of Elements as CVS
#  
  def export
    @experiment = current( Experiment, params[:id] )
    @study_protocol = StudyProtocol.find(params[:study_protocol_id])
    task = @experiment.new_task
    task.protocol = @study_protocol
    task.process = @study_protocol.process  
    filename = "#{@experiment.name}-#{task.name}.csv"
    task.description ="This task is linked to external cvs file for import created called #{filename}"
    task.save  
    send_data(task.grid.to_csv,  :type => 'text/csv; charset=iso-8859-1; header=present',  :filename => filename)
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")
      flash[:error] = ex.message
      flash[:trace] = ex.backtrace.join("<br \>")
      render :action => 'import'   
  end  

##
# add reports
#   
  def reports
   @report = Report.new      
   @report.model = Report
   @report.name = "Experiment Reports List"
   @report.description = "All Experiment Reports in the system"
   @report.column('custom_sql').is_visible=false
   column = @report.column('base_model')
   column.filter_operation = 'in'
   column.filter_text = "('Experiment','ExperimentStatistics','ExperimentLog','Experiment','Task','TaskContext','TaskValue','TaskText','TaskStatistics','TaskReference')"
   column.is_filterible = false
   @report.default_action = false
   @report.set_filter(params[:filter])if  params[:filter] 
   @report.add_sort(params[:sort]) if params[:sort]
  end
  
##
# Import form
  def import
    @experiment = current( Experiment, params[:id] )
  end

##
# Import file into the task
# 
# first  
# Task   study,experiment,task,status
# note   description
# Header label  [name,]
# Data   row    [value,]
# 
  def import_file
    @experiment = current( Experiment, params[:id] )
    if params[:file] # Firefox style
       @task = @experiment.import_task(params[:file])  
    elsif params['File'] # IE6 style tmp/file
       @task = @experiment.import_task(params['File'])  
    else
      flash[:error] ="couldn't work out where file was: {params.to_s}"
    end 
    
    flash[:error]=@experiment.errors
    #flash[:warning]=@experiment.messages
    flash[:info]= "import task #{@task.name}" 
    redirect_to :controller => 'tasks', :action => 'show', :id => @task

  rescue  Exception => ex
     logger.error ex.message
     logger.error ex.backtrace.join("\n") 
     flash[:error] = "Import Failed:" + ex.message
     flash[:info] = " Double check file format is CSV and matches template from above, common problem is files saved from excel as xls and not cvs"
     flash[:trace] = ex.backtrace.join("<br \>")
     render :action => 'import'   
  end
  

end
