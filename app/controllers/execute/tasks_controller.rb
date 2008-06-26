# ##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
class Execute::TasksController < ApplicationController

  use_authorization :tasks,
    :actions => [:list,:show,:new,:create,:edit,:update,:make_flexible],
    :rights => :current_project

  helper SheetHelper

  before_filter :setup_task,
    :only => [ :show, :edit,:assign,:update_queue,:copy, :update,:destroy,:print,:import, :export,:modify,:folder,
    :sheet,:entry,:export,:metrics,:analysis,:report,:make_flexible]

  def index
    list
  end

  # ## List tasks in the the current experiment
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

  # ## This will show the task and provide a read only view of the entered data
  # on the screen
  # 
  def show
    respond_to do | format |
      format.html {
        if browser_is? :ie6
          render :action => 'show_ie6'
        else
          render :action => 'show'
        end
      }
      format.ext { render :partial => 'show',:layout=>false }
      format.pdf  { render_pdf "#{@task.name}.pdf", :partial => 'show',:layout=>false }
      format.csv { render :text => @task.to_csv}
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
    end    
  end
  # 
  # Auto Assign queued items
  # 
  def assign
    @task.assign_queued_items
    redirect_to :action => 'show',  :id=> @task  
  end  
  
  def update_queue
    if params[:any]=='y'
      @task.update_queued_items(@task.possible_queue_items)
    else
      @task.update_queued_items(@task.queue_items)
    end      
    redirect_to :action => 'show',  :id=> @task  
  end  
  
  # ## show statics on task
  def metrics
    respond_to do | format |
      format.html { render :action => 'metrics' }
      format.ext { render :partial => 'metrics',:layout=>false }
      format.pdf  { render_pdf :action => 'metrics',:layout=>false }
      format.csv { render :json => @task.grid.to_csv}
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
    end
  end

  # ## Printed output for a model
  # 
  def print
    respond_to do | format |
      format.html { render :text => @task.to_html }
      format.ext  { render :text => @task.to_html }
      format.pdf  { html_send_as_pdf(@task.name, @task.to_html) }
      format.csv { render :json => @task.grid.to_csv}
      format.json { render :json => @task.to_json }
      format.xml  { render :xml => @task.to_xml }
    end
  end 

  # ## show data entry sheet
  def sheet
    @tab=3
    @task.populate
    respond_to do | format |
      format.html {
        if browser_is? :ie6
          render :action => 'sheet_ie6'
        else
          render :action => 'sheet'
        end
      }
      format.ext { render :partial => 'sheet',:layout=>false }
      format.pdf  { render_pdf :action => 'sheet',:layout=>false }
      format.csv { render :json => @task.grid.to_csv}
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
    end
  end

  # ## show data entry sheet
  def entry
    @task.populate
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
  
  # ## show data task analysis options {"run"=>"yes", "commit"=>"Run",
  # "action"=>"analysis", "id"=>"10549",
  # "setting"=>{"x"=>{"parameter_id"=>"10657"},
  #             "title"=>{"default_value"=>"x/y plot"},
  #             "y"=>{"parameter_id"=>"10658"},
  #             "filename"=>{"default_value"=>"plot_xy.jpg"},
  #             "label"=>{"parameter_id"=>"10655"}},
  # "controller"=>"execute/tasks"}

  def analysis
    @level1 =  @task.process.parameters.reject{|i|i.context.parent.nil?}.collect{|i|["#{i.name} [#{i.data_type.name}]" ,i.id]}
    @level0 =  @task.process.parameters.reject{|i|!i.context.parent.nil?}.collect{|i|["#{i.name} [#{i.data_type.name}]",i.id]}
    @analysis = @task.process.analysis_method
    @analysis.configure(params[:setting],@task) if params[:setting]
    @analysis.run(@task)  if params[:run]
    respond_to do | format |
      format.html { render :action => 'analysis'}
      format.ext { render :partial => 'analysis',:layout=>false }
      format.xml  { render :xml =>  @task.to_xml}
      format.text  { render :xml =>  @task.to_csv}
      format.js   { 
        render :update do | page |
          page.replace_html 'analysis-form',  :partial => 'analysis' 
          page.replace_html 'analysis-run',  :inline => @analysis.report(@task) if @analysis.run? 
        end
      }
    end
  end

  # ## show task notces,comments etc
  def folder
    @project_folder = @task.folder  
  end
  # ## show reporting options
  # 
  def report
    show
  end

  # ## Create a new task in the the current experiment
  # 
  def new
    set_experiment(params[:id])
    @task = @experiment.add_task
  end


  # ## Post of new to task back to the database
  # 
  def create
    @task = Task.new(params[:task])
    @task.protocol = @task.process.protocol if @task.process
    @task.project = current_project
    set_experiment(@task.experiment_id)
    if @task.save
      ProjectFolder.current = @task.folder
      session[:task_id] = @task.id
      flash[:notice] = 'Task was successfully created.'
      redirect_to task_url(:action => 'show', :id=>@task.id,:tab=>3)
    else
      render :action => 'new'
    end
  end
  
  # ## Update the details on the current task
  # 
  # This is used for validation of task and changing of schedule
  # 
  def edit
    respond_to do | format |
      format.html { render :action => 'edit' }
      format.ext { render :partial => 'edit',:layout=>false }
      format.pdf  { render_pdf :action => 'edit',:layout=>false }
      format.json { render :json => @task.to_json}
      format.xml  { render :xml => @task.to_xml }
    end
  end

  # ## copy a task
  def copy
    old_task = @task
    @task = old_task.copy
    @task.experiment = nil
    @task.started_at = Time.now
    @task.ended_at =  Time.now + (old_task.finished_at-old_task.started_at)
    old_task.experiment.tasks << @task
    @task.save
    redirect_to :action => 'show', :id => @task
  end
  
  # ## Post from edit to update database
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
  # ## destroy the task
  # 
  def destroy
    session[:data_sheet] =nil
    @experiment = @task.experiment
    @task.destroy
    redirect_to :controller =>'experiments',:action => 'show',:id => @experiment.id
  end 
  # 
  #  export Report of Elements as CVS
  # 
  def export
    filename = "#{@task.experiment.name}-#{@task.name}.csv"
    send_data( @task.to_csv, :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => filename)   
  end  
  # ## Import form
  def import
    respond_to do | format |
      format.html { render :action => 'import' }
      format.ext { render :partial => 'import',:layout=>false }
    end
  end
  # ## Import file into the task
  # 
  # first Task   assay,experiment,task,status note   description Header label
  # [name,] Data   row    [value,]
  # 
  def import_file
    set_experiment(params[:id])
    file = params[:file] || params['File']
    if file.is_a? StringIO or file.is_a? File
      Experiment.transaction do 
        #        @experiment = @task.experiment
        @task = @experiment.import_task(file)  
      end
      flash[:info]= "import task #{@task.name}" 
      redirect_to :action => 'show', :id=>@task.id,:tab=>3
    else
      flash[:error] ="Appears that there was to file selected. "
      render :action => 'import'   
    end 
  rescue  Exception => ex
    logger.error ex.message
    logger.error ex.backtrace.join("\n") 
    flash[:error] = "Import Failed:" + ex.message
    flash[:info] = " Double check file format is CSV and matches template from above, common problem is files saved from excel as xls and not cvs"
    render :action => 'import'   
  end
  # 
  # Make the task flexible to can add columns
  # 
  def make_flexible
    @successful  = false
    begin
      @task.make_flexible
      @successful  = true
    rescue
    end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id=>@task.id,:tab=>3}
      format.xml  { render :xml => @task.to_xml }
    end
  end
  
  # 
  # Add a row to a context appending to the end of the block the passed previous
  # context was in
  # 
  def add_row
    @successful  = false
    begin
      prev_context = TaskContext.find(params[:id])
      @task = prev_context.task
      @context = prev_context.append_copy
      @successful  = true
    rescue
      logger.warn $!.to_s
      flash[:error]= $!.to_s
    end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id=>@task.id,:tab=>3 }
      format.xml  { render :xml => @task.to_xml }
      format.js   { 
        render :update do | page |
          if @successful
            page.replace_html "#{@task.dom_id('entry')}",:partial => 'entry' 
          else
            page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['task_context','task'] }
          end
        end          
      }
    end
  end
  # 
  # List of possible column parameters to add at this point
  # 
  def list_columns
    @task_context = TaskContext.find(params[:id])
    @value   = params[:query] || ""
    @choices =  @task_context.assay.parameters
    @list = {:element_id=>params[:id],
      :matches=>@value,
      :total=>@choices.size ,
      :items =>@choices.collect{|i|{ :id=>i.id,:name=>i.name}}
    }
    render :text => @list.to_json
  end  
  # 
  # If the task is flexible the add a column to it
  # 
  def add_column
    @successful  = false
    begin
      @task_context = TaskContext.find(params[:id])
      @task = @task_context.task
      if @task.flexible?
        @task_context.add_parameter(params[:name])
        @successful  = true
      else
        flash[:error]= 'this is not a flexible process' 
        logger.warn("not a flexible task")        
      end
    rescue 
    end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id=>@task.id,:tab=>3 }
      format.xml  { render :xml => @task.to_xml }
      format.js   { 
        render :update do | page |
          if @successful
            page.replace_html @task.dom_id('entry'),:partial => 'entry' 
          else
            page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['task_context','task'] }
          end
        end        
      }
    end
  end
  # 
  # update a cell valuei in the task
  # 
  def cell_value
    item = {:row=>params[:row],:column =>params[:column],:passed=>params[:value]}
    begin
      Task.transaction do
        @context = TaskContext.find(params[:id],:include=>[:task,:values,:texts,:references])
        item = item.merge(@context.set_value(from_dom_id(params[:field]),params[:value]))
      end
    rescue Exception => ex
      logger.warn ex.backtrace.join("\n")  
      item[:errors] = ex.message
    end  
    logger.info "returned value #{item.to_json}"
    logger.warn item[:errors] if item[:errors]
    render :text =>  item.to_json
  end
  

  protected
  
  def setup_task
    @tab = params[:tab]||0
    @task = current_user.task( params[:id] )
    if @task 
      @experiment =@task.experiment    
      ProjectFolder.current = @task.folder
      if set_project(@experiment.project) 
        if set_team(@experiment.team)
          return true
        end
      end
    else
      return show_access_denied
    end
    return false
  end
  
  def set_experiment(experiment_id)
    @tab = params[:tab]||0
    if experiment_id
      @experiment = current_user.experiment(experiment_id )
    else
      @experiment = current_project.experiments.last    
    end
  end
end
