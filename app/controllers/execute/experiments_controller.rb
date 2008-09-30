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
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user

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
   @report = Biorails::ReportLibrary.experiment_list do | report |
      report.column('project_id').customize(:filter => current_project.id, :is_visible => false)
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
    respond_to do | format |
      format.html { render :action => 'list' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report } }
      format.pdf  { render_pdf :action => 'list',:layout=>false }
      format.json { render :json => @report.data.to_json }
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
      format.pdf  { render_pdf :action => 'show',:layout=>false }
      format.json { render :json => @experiment.to_xml }
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
      format.pdf  { html_send_as_pdf(@experiment.name, @experiment.to_html) }
      format.csv { render :json => @experiment.to_csv}
      format.json { render :json => @experiment.tasks.to_json }
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
      format.pdf  { render_pdf :action => 'metrics',:layout=>false }
      format.json { render :json => @task.statistics.to_json }
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
    ok = true
    if params[:assay_id]
      @assay = Assay.find( params[:assay_id] ) 
      @process ||= @assay.protocols.first.released
    elsif params[:protocol_version_id]
      @process = ProtocolVersion.find(params[:protocol_version_id])
      @assay = @process.protocol.assay
    else 
      ok = false
    end
    @experiment = Experiment.new(:protocol_version_id=>@process.id, :assay_id=>@assay.id)
    @experiment.description = @process.description if @process
    respond_to do | format |
      format.html { render :action => 'new' }
      format.ext  { render :partial => 'process_selector' }
      format.js   { render :update do | page |
          if ok
            page.replace_html('process_selector', :partial => 'process_selector' ) 
            page.visual_effect :highlight, 'experiment_description',:duration => 1.5 
            page.visual_effect :highlight, 'experiment_protocol_version_id',:duration => 1.5 
            page[:experiment_description][:value]="A run of #{@process.description}"
          end
      end }
    end
  end
##
# Return from new to create a Experiment record
  def create
    Experiment.transaction do
      @experiment = Experiment.new(params[:experiment])    
      if @experiment.save
        set_project @experiment.project 
        set_element @folder = @experiment.folder  
        @experiment.run 
        flash[:notice] = 'Experiment was successfully created.'
        redirect_to :action => 'show', :id => @experiment.id
      else
        render :action => 'new'
      end
    end
  end

##
# Edit a experiment details
# 
  def edit
    respond_to do | format |
      format.html { render :action => 'edit' }
      format.ext  { render :partial => 'edit' }
      format.pdf  { render_pdf :action => 'edit',:layout=>false }
      format.json { render :json => @experiment.to_json }
      format.xml  { render :xml => @experiment.to_xml }
    end
  end

##
# Update a existing experiment
# 
  def update
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
    @task.attributes.keys.each do |key|
        @task[key] = params[key] unless params[key].blank? 
    end        
    ok = @task.save
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id => task.experiment }
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
    @experiment.destroy
    redirect_to :action => 'list'
  end
#
#  export Report of Elements as CVS
#  
  def export
    @assay_protocol = AssayProtocol.find(params[:assay_protocol_id])
    task = @experiment.add_task(:assay_protocol_id =>params[:assay_protocol_id] )
    task.protocol = @assay_protocol
    task.process = @assay_protocol.process  
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
      format.json { render :json => @task.statistics.to_json }
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
      if params[:file] # Firefox style
         @task = @experiment.import_task(params[:file])  
      elsif params['File'] # IE6 style tmp/file
         @task = @experiment.import_task(params['File'])  
      end 
    end
    session.data[:current_params]=nil
    flash[:info]= "import task #{@task.name}" 
    redirect_to :controller => 'tasks', :action => 'show', :id => @task

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
    set_project(Project.load( params[:id] )) if  params[:id]
    @assay = current_project.usable_assays[0]    
  end  
  
  def setup_experiment
    @experiment = Experiment.load(params[:id])
    if  @experiment
      @folder = set_element( @experiment.folder)
      return @experiment
    else
      return show_access_denied
    end

  end
end
