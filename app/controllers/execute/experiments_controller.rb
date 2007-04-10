##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

require "faster_csv"

class Execute::ExperimentsController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

##
# default action is linked to list
  def index
    list
    render :action => 'list'
  end

###
# list all the experiments 
# 
  def list
    @study = current( Study, params[:id]  )
    @experiment_pages, @experiments = paginate :experiments, :per_page => 10
  end

##
# show the current experiment
# 
  def show
    @experiment = current(Experiment,params[:id])
    @project_folder = current_project.folder(@experiment)    
    @schedule = Schedule.tasks_in(@experiment)    
  end

  def notes
    show
    @project_folder = current_project.folder(@experiment)
  end
  
##
# create a new experiment
  def new
    @study = current( Study, params[:id] )
    @experiment = Experiment.new(:study_id=>@study.id, :name=> Identifier.next_id(Experiment))
    @experiment.description = " Task in study #{@study.name} "  
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
    if @experiment.save
      @project_folder = current_project.folder(@experiment)    
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
  def timeline
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
