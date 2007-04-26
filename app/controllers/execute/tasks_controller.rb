##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Execute::TasksController < ApplicationController

  use_authorization :experiment,
                    :actions => [:list,:show,:new,:create,:edit,:update,:desrroy],
                    :rights => :current_project

  helper SheetHelper

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end

##
# List tasks in the the current experiment
# 
  def list
    @task_pages, @tasks = paginate :tasks, :per_page => 10
  end

##
# This will show the task and provide a read only view of the entered data on the screen
# 
  def show
    @task = current( Task, params[:id] )
    @folder = set_folder(current_project.folder(@task.experiment).folder(@task))
    redirect_to project_url(:action => 'show') if @task.nil?
  end

##
# show statics on task
  def metrics
    show
  end

##
# show data entry sheet readonly
  def view
    show
  end

##
# show data entry sheet 
  def sheet
    show
  end

##
# show data task analysis options
# 
  def analysis
    show
  end

##
# show task notces,comments etc
  def folder
    show
    @project_folder = current_project.folder(@task.experiment).folder(@task)    
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
    @task = current( Task, params[:id] )
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
    @experiment = current( Experiment, params[:id] )
    @task = Task.new(:name=> Identifier.next_id(Task))
    @task.reset
    @task.experiment = @experiment
    @task.protocol = @experiment.protocol
    @task.process = @experiment.process
    @task.project = current_project
    @task.assigned_to_user_id = current_user.id
    @task.expected_hours =1
    @task.done_hours = 0
    @task.name =  @experiment.name+"-"+@experiment.tasks.size.to_s 
    @task.description = " Task in experiment #{@experiment.name} "      
  end

  def refresh_instances
    text = request.raw_post || request.query_string
    puts text
    @source = StudyProtocol.find(text)
    render :partial => 'select_process', :layout => false      
  end
##
# Post of new to task back to the database
#
  def create
    @task = Task.new(params[:task])
    @task.project = current_project
    @experiment = @task.experiment
    if @task.save
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
    @task = current( Task, params[:id] )
    session[:data_sheet] = @data_sheet
  end

##
# copy a task
  def copy
    old_task = current( Task, params[:id] )
    @task = old_task.copy
    @task.experiment = nil
    @task.start_date = Time.now
    @task.end_date =  Time.now + (old_task.end_date-old_task.start_date)
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
    @task = Task.find(params[:id])
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
    @task = Task.find(params[:id])
    @experiment = @task.experiment
    @task.destroy
    redirect_to :controller =>'experiments',:action => 'show',:id => @experiment.id
  end
  
#
#  export Report of Elements as CVS
#  
  def export
    @task = current( Task, params[:id] )
    set_context(@task)
    filename = "#{@task.experiment.name}-#{@task.name}.csv"
    send_data( @task.grid.to_csv, :type => 'text/csv; charset=iso-8859-1; header=present',
                            :filename => filename)   
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      redirect_to :action => 'show', :id => @task
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
    @successful = false 
    @dom_id = params[:element]  
    @row =@dom_id.split('_')[2].to_i
    @col = @dom_id.split('_')[3].to_i
    @task_id = params[:id].to_i
    @value = params[:value]     
    unless session[:data_sheet] ## Catch all to reload task into session if messing
           flash[:info] = "Data_sheet for #{@task_id} had to be reloading from database "
           session[:data_sheet] = TreeGrid.from_task(Task.find(@task_id))       
    end
    grid = session[:data_sheet]
    if grid.task.id != @task_id
        flash[:warning]= "Task #{ @task_id} does not match expecting #{grid.task.name} in server session.\n"+
                          "Expect your trying to edit two task at same time, which is not currently supported."        
    else
        @task = grid.task
        @cell = grid.cell(@row,@col)
        @cell.value = @value
        @successful = @cell.save
        unless @successful
        flash[:warning] = "Failed to save value '#{@value}' into #{@cell.item.class} cell :- <ul><li>  "
        flash[:warning] += @cell.item.errors.full_messages().join('</li><li>')
        flash[:warning] += "</li></ul>"
        end
    end
    return render(:action => 'cell_saved.rjs') if request.xhr?
  rescue Exception => ex
    flash[:error]="Problems with save of cell "+@dom_id
    logger.debug ex.backtrace.join("\n")  
    logger.error "Problem with save"+ $!.to_s
    return render(:action => 'cell_saved.rjs') if request.xhr?
  end


end
