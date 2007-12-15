##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Execute::TasksController < ApplicationController

  use_authorization :tasks,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_project

  helper SheetHelper

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
  end

##
# List tasks in the the current experiment
# 
  def list
    @tasks = Task.paginate :order=>'updated_at desc', :page => params[:page]
    respond_to do | format |
      format.html { render :action => 'list' }
      format.ext { render :action => 'list',:layout=>false }
      format.pdf  { render_pdf :action => 'list',:layout=>false }
      format.json { render :json => @tasks.to_json}
      format.xml  { render :xml => @tasks.to_xml }
     end
  end

##
# This will show the task and provide a read only view of the entered data on the screen
# 
  def show
    set_task
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext { render :partial => 'show',:layout=>false }
      format.pdf  { render_pdf "#{@task.name}.pdf", :partial => 'show',:layout=>false }
      format.csv { render :text => @task.to_csv}
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
     end
    
  end

##
# show statics on task
  def metrics
    set_task
    respond_to do | format |
      format.html { render :action => 'metrics' }
      format.ext { render :action => 'metrics',:layout=>false }
      format.pdf  { render_pdf :action => 'metrics',:layout=>false }
      format.csv { render :json => @task.grid.to_csv}
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
     end
  end

##
# show data entry sheet readonly
  def view
    set_task
    respond_to do | format |
      format.html { render :action => 'view' }
      format.ext { render :action => 'view',:layout=>false }
      format.pdf  { render_pdf :action => 'view',:layout=>false }
      format.csv { render :json => @task.grid.to_csv}
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
     end
  end

##
# show data entry sheet 
  def sheet
    set_task
    respond_to do | format |
      format.html { render :action => 'sheet'}
      format.ext { render :action => 'sheet',:layout=>false }
      format.pdf  { render_pdf :action => 'sheet',:layout=>false }
      format.csv { render :json => @task.grid.to_csv}
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
     end
  end

##
# show data entry sheet 
  def entry
    set_task
    respond_to do | format |
      format.html { render :action => 'entry'}
      format.ext { render :action => 'entry',:layout=>false }
      format.pdf  { render_pdf :action => 'sheet',:layout=>false }
      format.csv { render :json => @task.grid.to_csv}
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
     end
  end  
  

 #
 # Get a table of data for a context definition
 #
 def context
   @parameter_context = ParameterContext.find(params[:id])
   render :inline => '<%= context_model(@parameter_context) %>'
 end  
 #
 # Get a table of data for a context definition
 #
 def values
   @task_context = TaskContext.find(params[:id])
   render :inline => '<%= context_values( @task_context.task , @task_context.definition ) %>'
 end    
  
##
# show data task analysis options
# 
  def analysis
    set_task
    @level1 =  @task.process.parameters.reject{|i|i.context.parent.nil?}.collect{|i|["#{i.name} [#{i.data_type.name}]" ,i.id]}
    @level0 =  @task.process.parameters.reject{|i|!i.context.parent.nil?}.collect{|i|["#{i.name} [#{i.data_type.name}]",i.id]}
    @analysis = AnalysisMethod.setup(params)
    @analysis.run(@task)  if params[:run]
    respond_to do | format |
      format.html { render :action => 'analysis'}
      format.ext { render :action => 'analysis',:layout=>false }
      format.xml  { render :xml =>  @task.to_xml}
      format.text  { render :xml =>  @task.to_csv}
      format.js   { render :update do | page |
           page.replace_html 'analysis-form',  :partial => 'analysis' 
           page.replace_html 'analysis-run',  :inline => @analysis.report(@task) if @analysis.has_run? 
         end }
    end
  end

##
# show task notces,comments etc
  def folder
    set_task
    @project_folder = @task.folder  
  end
##
# show reporting options
# 
  def report
    show
  end

###
# If a process is linked to only a single task it can be mmodified on the fly. In this
# case control is passed to study protocol editor otherwize a warning is presented
  def modify 
    @task = current_user.task( params[:id] )
    @task.updated_by = current_user.name
    session[:data_sheet] = nil
    flash[:modify] = @task.id   
    if  @task.process.tasks.size==1
        flash[:return] = { :controller => 'tasks', :action=>'show', :id=>@task.id }
        redirect_to :action => 'edit',:controller=>'study_protocol',
                :id=> @task.protocol.id,  :version => @task.process.id  
    else
       flash[:warning] = "process #{@task.process.name} linked to multple task so cant be edited"
       render :action=>'show'
    end
  end
##
# Create a new task in the the current experiment
#
  def new
    set_experiment(params[:id])
    @task = @experiment.new_task
  end


##
# Post of new to task back to the database
#
  def create
    @task = Task.new(params[:task])
    @task.protocol = @task.process.protocol if @task.process
    @task.project = current_project
    set_experiment(@task.experiment_id)
    if @task.save
      @project_folder = @task.folder
      session[:task_id] = @task.id
      flash[:notice] = 'Task was successfully created.'
      redirect_to task_url(:action => 'show', :id=>@task.id)
    else
      render :action => 'new'
    end
  end
  
##
# Update the details on the current task
# 
# This is used for validation of task and changing of schedule
# 
  def edit
    set_task
    respond_to do | format |
      format.html { render :action => 'edit' }
      format.ext { render :action => 'edit',:layout=>false }
      format.pdf  { render_pdf :action => 'edit',:layout=>false }
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
     end
  end

##
# copy a task
  def copy
    old_task = current( Task, params[:id] )
    @task = old_task.copy
    @task.experiment = nil
    @task.started_at = Time.now
    @task.ended_at =  Time.now + (old_task.ended_at-old_task.started_at)
    old_task.experiment.tasks << @task
    @data_sheet = TreeGrid.from_task(@task)
    @task.save
      redirect_to :action => 'show', :id => @task
  end
  
  
  def transform
    @task = Task.find(params[:id])
    render :partial => 'stats'
  end
  
##
# Post from edit to update database
#
  def update
    session[:data_sheet] =nil
    @task = current_user.task(params[:id])
    if @task.update_attributes(params[:task])
      @task.update_queued_items
      flash[:notice] = 'Task was successfully updated.'
      redirect_to :action => 'show', :id => @task
    else
      render :action => 'edit'
    end
  end

##
# destroy the task
#
  def destroy
    session[:data_sheet] =nil
    @task = current_user.task(params[:id])
    @experiment = @task.experiment
    @task.destroy
    redirect_to :controller =>'experiments',:action => 'show',:id => @experiment.id
  end
  
#
#  export Report of Elements as CVS
#  
  def export
    set_task
    filename = "#{@task.experiment.name}-#{@task.name}.csv"
    send_data( @task.to_csv, :type => 'text/csv; charset=iso-8859-1; header=present',
                            :filename => filename)   
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      redirect_to :action => 'show', :id => @task
  end  

##
# Import form
  def import
    set_task
    respond_to do | format |
      format.html { render :action => 'import' }
      format.ext { render :action => 'import',:layout=>false }
     end
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
    set_task
    file = params[:file] || params['File']
    if file.is_a? StringIO or file.is_a? File
      Experiment.transaction do 
        @experiment = @task.experiment
        @task = @experiment.import_task(file)  
      end
      session.data[:current_params]=nil    
      flash[:info]= "import task #{@task.name}" 
      redirect_to  task_url( :action => 'view', :id => @task)
    else
      session.data[:current_params]=nil    
      flash[:error] ="Appears that there was to file selected. "
      render :action => 'import'   
    end 

  rescue  Exception => ex
     session.data[:current_params]=nil
     logger.error ex.message
     logger.error ex.backtrace.join("\n") 
     flash[:error] = "Import Failed:" + ex.message
     flash[:info] = " Double check file format is CSV and matches template from above, common problem is files saved from excel as xls and not cvs"
     render :action => 'import'   
  end
  

  def cell_value
    @task = Task.find(params[:id])
    @task.cell()
  end
##
# Handle cell change events to save data back to the database
# 
# param[:id] = task
# param[:row]= row_no (test_context.row_no)
# param[:col]= column_no for parameter
# param[:cell]= dom_id for the cell changes
# 
# content of message is the data for the value
# 
  def cell_change
   begin
    @successful = false 
    @dom_id = params[:element]  
    @row =@dom_id.split('_')[2].to_i
    @col = @dom_id.split('_')[3].to_i

    @task = Task.find(params[:id])    
    @grid = @task.grid
    @cell = @grid.cell(@row,@col)
    @cell.value = URI.unescape(params[:value])    
    @successful = @cell.save

  rescue Exception => ex
    flash[:error]="Problems with save of cell "+@dom_id
    logger.debug ex.backtrace.join("\n")  
    logger.error "Problem with save"+ $!.to_s
  end  
  respond_to do | format |
    format.html { render :action => 'task'}
    format.xml  { render :xml =>  @task.to_xml}
    format.text  { render :xml =>  @task.to_csv}
    format.js   { render :update do | page |
          if  @successful 
            page[@dom_id].value=@cell.value
            page.visual_effect :highlight, @dom_id, {:endcolor=>"'#99FF99'",:restorecolor=>"'#99FF99'"}
          else
            page.visual_effect :highlight, @dom_id, {:endcolor=>"'#FFAAAA'",:restorecolor=>"'#FFAAAA'"}
          end      
       end }
  end
  end

protected
  
  def set_task
    @task = current_user.task( params[:id] )
    @experiment =@task.experiment
    ProjectFolder.current = @folder = @task.folder
  end
  
  def set_experiment(experiment_id)
    if experiment_id
      @experiment = current_user.experiment(experiment_id )
    else
      @experiment = current_project.experiments.last    
    end
    @protocol_options= []
    @current_project.protocols.each do |item|
      @protocol_options << ["#{item.study.name}/#{item.process.name} [release]",item.process.id]
      unless item.process.id == item.lastest.id
         @protocol_options << ["#{item.study.name}/#{item.lastest.name} [lastest]",item.lastest.id]
      end
    end
  end
end
