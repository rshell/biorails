# == Experiment Controller
# The experiment controller change the key container for capture of data this is 
# based on the Experiment model. The Experiment is built of a open collection of tasks.
#  
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#

class Execute::ExperimentsController < ApplicationController

  use_authorization :execution,
                    :build => [:destroy],
                    :use => [:list,:show,:new,:create,:edit,:update]
                  

 before_filter :setup_experiments,
    :only => [ :new,:list,:index,:create]

  before_filter :setup_experiment,
    :only => [ :show, :edit,:copy, :update,:destroy,:print,:import_file,:import, :export,:metrics]  
  helper :calendar
##
# default action is linked to list
  def index
    list
  end

###
# list all the experiments 
# 
  def list
   @report = Biorails::ReportLibrary.experiment_list("Experiment_List")
    respond_to do | format |
      format.html { render :action => 'list' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report } }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end

##
# show the current experiment
# 
  def show
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext { render :partial => 'show' }
      format.xml  { render :xml => @experiment.to_xml }
     end
  end
  
##
# Printed output for a model
# 
  def print
    respond_to do | format |
      format.html { render :text => @experiment.to_html }
      format.ext  { render :text => @experiment.to_html }
      format.pdf  { send_as('pdf',"#{@experiment.name}.pdf", @experiment.to_html) }
      format.csv { render :json => @experiment.to_csv}
      format.xml  { render :xml => @experiment.to_xml }
    end
  end 

#
# Generate a display Statistics on data collected in this taks
#
  def metrics
    respond_to do | format |
      format.html { render :action => 'metrics' }
      format.ext  { render :partial => 'metrics' }
      format.pdf  { render_pdf "metrics.pdf", :action => 'metrics',:layout=>false }
      format.xml  { render :xml => @task.statistics.to_xml }
    end
  end
###
# Create a duplicate experiment based on the current one and redirect to it
#
  def copy
    @experiment = @experiment.copy    
    redirect_to :action => 'show', :id => @experiment.id
  end
##
# create a new experiment
  def new
    flash[:warning] = l(:text_project_not_runnable) unless current_project.runnable?
    @experiment = Experiment.new
    @experiment.assay = @assay
  end
  
  def refresh
    if params[:assay_id]
      @assay = Assay.find( params[:assay_id] )
    elsif params[:protocol_version_id]
      @process = ProtocolVersion.find(params[:protocol_version_id])
      @assay = @process.protocol.assay
    end
    @assay ||= Assay.list(:first)
    @process ||= @assay.protocols.first.released
    @experiment = Experiment.new(:protocol_version_id=>@process.id, :assay_id=>@assay.id)
    @experiment.description = @process.description if @process
    respond_to do | format |
      format.html { render :action => 'new' }
      format.ext  { render :partial => 'process_selector' }
      format.js   { render :update do | page |
          page.replace_html('process_selector', :partial => 'process_selector' )
          page.visual_effect :highlight, 'experiment_description',:duration => 1.5
          page.visual_effect :highlight, 'experiment_protocol_version_id',:duration => 1.5
          page[:experiment_description][:value]="A run of #{@process.description}"
      end }
    end
  end
##
# Return from new to create a Experiment record
  def create
    return show_access_denied unless current_project.changeable?
    begin
      Experiment.transaction do
        @experiment = Experiment.new(params[:experiment])
        if @experiment.save
          set_project @experiment.project
          set_element @folder = @experiment.folder
          @experiment.run
          flash[:notice] = 'Experiment was successfully created.'
          return redirect_to :action => 'show', :id => @experiment.id
        end
      end
    rescue Exception => ex
      flash[:error] = ex.message
    end
    render :action => 'new'
  end

##
# Edit a experiment details
# 
  def edit
    return show_access_denied unless @experiment.changeable?
    respond_to do | format |
      format.html { render :action => 'edit' }
      format.ext  { render :partial => 'edit' }
      format.xml  { render :xml => @experiment.to_xml }
    end
  end

##
# Update a existing experiment
# 
  def update
    return show_access_denied unless @experiment.changeable?
    Experiment.transaction do
      if @experiment.update_attributes(params[:experiment])
        flash[:notice] = 'Experiment was successfully updated.'
        redirect_to :action => 'show', :id => @experiment
      else
        render :action => 'edit'
      end
    end
  end

  
  def update_row
    @task = Task.load(params[:id])
    if @task
      @task.attributes.keys.each do |key|
          @task[key] = params[key] unless params[key].blank?
      end
      ok = @task.save
    else
      ok =false
    end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id => @task.experiment_id }
      format.js   { render :update do | page |
        if ok 
          page.replace_html(@task.dom_id(:row), :partial => 'task',:locals => { :task => @task } ) 
          page.visual_effect :highlight, @task.dom_id(:row),:duration => 1.5
        else
          logger.warn("failed to update task")
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => [:task] }
        end  
      end }
      format.json { render :json => @task.to_json }
      format.xml  { render :xml => @task.to_xml }
    end    
  end
##
# Delete the passed experiment
# 
  def destroy
    return show_access_denied unless @experiment.changeable?
    begin
    Experiment.transaction do
      if @experiment.changeable? and right?(:data,:destroy)
         @experiment.destroy
      else
        flash[:warning] ="Can not destroy #{@experiment.name}"
      end
    end
    rescue Exception => ex
      flash[:error] ="destroy Failed with error: #{ex.message}"
    end
    redirect_to :action => 'list'
  end
#
#  export Report of Elements as CVS
#  
  def export
    task = @experiment.add_task(:protocol_version_id =>params[:protocol_version_id] )
    task.process = ProcessInstance.find(params[:protocol_version_id])
    filename = "#{@experiment.name}-#{task.name}.csv"
    task.description ="This task is linked to external cvs file for import created called #{filename}"
    task.save  
    send_data(task.to_csv,  :type => 'text/csv; charset=iso-8859-1; header=present',  :filename => filename)
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")
      flash[:error] = ex.message
      flash[:trace] = ex.backtrace.join("<br \>")
      render :action => 'import'   
  end    
##
# Import form to allow experimental tasks to be uploaded
#
  def import
   respond_to do | format |
      format.html { render :action => 'import'}
      format.ext  { render :partial => 'import'}
      format.pdf  { render_pdf :action => 'import',:layout=>false }
      format.xml  { render :xml => @task.statistics.to_xml }
    end

  end

##
# Import file into the task
# 
# first  
# Task   assay,experiment,task,status
# note   description
# Header label  [name,]
# Data   row    [value,]
# 
  def import_file
    Experiment.transaction do 
      return show_access_denied unless @experiment.changeable?
      file = params[:file] || params['File']
      if file.is_a? StringIO or file.is_a? File
         @task = @experiment.import_task(file)
      end 
    end
    if @task.errors.size==0
      session.data[:current_params]=nil
      flash[:info]= "import task #{@task.name}"
      redirect_to :controller => 'tasks', :action => 'show', :id => @task
    else
     flash[:warning] = "There were warning in inport"
     flash[:info] = " Double check file format is CSV and matches template from above, common problem is files saved from excel as xls and not cvs"
     redirect_to :action => 'import'
    end

  rescue  Exception => ex
     session.data[:current_params]=nil
     logger.error ex.message
     logger.error ex.backtrace.join("\n") 
     flash[:error] = "Import Failed:" + ex.message
     flash[:info] = " Double check file format is CSV and matches template from above, common problem is files saved from excel as xls and not cvs"
     redirect_to :action => 'import'
  end
  
 protected

  def setup_experiments
    if  params[:id]
      set_project(Project.load( params[:id] ))
      @assay = Assay.load(params[:assay_id]) if params[:assay_id]
    end
    set_element(current_project.folder(Experiment.root_folder_under))
    @assay ||= current_project.usable_assays[0]
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end  
  
  def setup_experiment
    @experiment = Experiment.load(params[:id])
    if  @experiment
      set_project(@experiment.project)
      @folder = set_element( @experiment.folder)
      return @experiment
    else
      return show_access_denied
    end
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end
end
