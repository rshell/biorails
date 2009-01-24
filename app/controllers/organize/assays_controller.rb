# 
# == Assay controller
# This manages the assign definitions and change responses to the key requests for organization of 
# structured data in the system
# 
# === Assay Definition 
#
# An assay definition provides the organisation for capturing structured data within experiments. 
# Each assay definition has its own name space built from the catalogue by assigning parameter types, 
# with roles as assay parameters.  Once the parameters are assigned, services can be registered against
#  which users can make requests.  These services are implemented as service queue parameters. 
#  These queue parameters can be built into the assays processes as a way of automatically 
#  returning data against items submitted in a request to a service.
#
# === Structure ¶
# Once the parameters are assigned, Process processes can be built. These processes are implemented 
# as data entry sheets within tasks . The idea is that there are likely to be a collection of 
# processes used to run an experiment.  Some of these processes may be used to set up the experiment, 
# others to capture data and others to analyse the data within an experiment.  The processes therefore
#  map to the steps that must be executed in order to run an experiment.  These steps can be 
#  formalised in a work-flow recipe?, where the processes can be added with default owners and 
#  starting points from the start of the experiment.
#
# === Content ¶
#
#An assay definition will automatically have a folder and show up on the project tree.  
#Documentation for running the assays (executing experiments) can be stored here as articles or files, 
#word documents for example).# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class Organize::AssaysController < ApplicationController

  use_authorization :organization,
    :build => [:new,:create,:edit,:update,:destroy],
    :use => [:list,:show, :processes, :recipes,:unlink,:link]

  before_filter :setup_assays ,
    :only => [ :list,:index]
  
  
  before_filter :setup_assay ,
    :only => [ :show, :edit, :update,:destroy,:print,:experiments,:processes, :parameters, :queues,:export,:protocols,:metrics, :recipes]

  def index
    list
  end
  
  ##
  # Display a List of Available assays for this user
  #
  #
  def list
    respond_to do | format |
      format.html { render :action => 'list' }
      format.ext  { render :partial =>'list'}
    end
  end
  ##
  # Show a overview of the current assay
  #
  def show
    respond_to do | format |
      format.html { render :action => 'show' }
      format.xml  { render :xml => @assay.to_xml }
    end
  end 

  ##
  # Printed output for a model
  #
  def print
    respond_to do | format |
      format.html { render :text => @assay.to_html }
      format.ext  { render :text => @assay.to_html }
      format.pdf  { send_as('pdf',"#{@assay.name}.pdf", @assay.to_html) }
      format.xml  { render :xml => @assay.to_xml }
    end
  end 
  
  ##
  # List of exparametersperiments for the assay.
  #
  def experiments
    @report = Biorails::ReportLibrary.experiment_list("Experiments_In_#{@assay.name}") do | report |
      report.column('assay.id').customize(:filter => @assay.id, :is_visible => true)
    end
    respond_to do | format |
      format.html { render :action => 'experiments' }
      format.ext  { render :partial => 'experiments' }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end
  ##
  # Show the summary stats for the assay
  #
  def metrics
    @report = Biorails::ReportLibrary.assay_statistics("Statistics #{@assay.name}") do | report |
      report.column('assay_id').customize(:filter => @assay.id, :is_visible => true)
    end
    respond_to do | format |
      format.html { render :action => 'metrics' }
      format.ext  { render :partial => 'metrics' }
      format.xml  { render :xml => @assay.to_xml }
    end
  end
  ##
  # Show the services queues for the assay
  #
  def queues
    @report = Biorails::ReportLibrary.assay_queue_list(
      "Assay Queues in #{@assay.name}") do | report |
      report.column('assay_id').customize(:filter => @assay.id, :is_visible => false)
    end
    respond_to do | format |
      format.html { render :action => 'queues' }
      format.ext  { render :partial => 'queues' }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end
  ##
  # Configuration of a Assay. This manages the setup of parameter list and
  # list of users associated with a assay
  #
  def parameters
    @report = Biorails::ReportLibrary.assay_parameter_list(
      "Assay Parameters in #{@assay.name}") do | report |
      report.column('assay_id').customize(:filter => @assay.id, :is_visible => false)
    end
    respond_to do | format |
      format.html { render :action => 'parameters' }
      format.ext  { render :partial => 'parameters' }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end
  ##
  # Standard entry point for data entry mode for assays. This will display a list of
  #
  def protocols
    redirect_to process_instance_url(:action => 'list',:id=>@assay)
  end

  def processes
    @report = Biorails::ReportLibrary.assay_processes_list(
      "Assay Processes in #{@assay.name}") do | report |
      report.column('assay_id').customize(:filter => @assay.id, :is_visible => false)
    end
    respond_to do | format |
      format.html { render :action => 'report' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report } }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end
  
  def recipes
    @report = Biorails::ReportLibrary.assay_recipe_list(
      "Assay Recipes in #{@assay.name}") do | report |
      report.column('protocol.assay.id').customize(:filter => @assay, :is_visible => false)

    end
    respond_to do | format |
      format.html { render :action => 'report' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report } }
      format.xml  { render :xml => @report.data.to_xml }
    end
  end
    
  #
  # Generate a New Assay and put up dialog for creation of assay
  #
  def new
    @assay = Assay.new
    @assay.started_at =Time.new
    @assay.expected_at = Time.new + 3.months
  end
  
  ##
  # response to new with details to created a assay
  #
  def create
    @assay = Assay.new(params[:assay])
    if @assay.save
      set_project @assay.project
      @project_folder = @assay.folder    
      flash[:notice] = 'Assay was successfully created.'
      redirect_to :action => 'show', :id => @assay.id
    else
      render :action => 'new'        
    end
  end

  ##
  #Edit the current assay
  #
  def edit
    respond_to do | format |
      format.html { render :action => 'edit' }
      format.ext  { render :partial => 'edit' }
      format.xml  { render :xml => @assay.to_xml }
    end
  end

  ##
  #manage the response to edit
  #
  def update
    @successful = @assay.update_attributes(params[:assay])
    if @successful
      flash[:notice] = 'Assay was successfully updated.'
      redirect_to :action => 'show', :id => @assay.id
    else
      render :action => 'edit'
    end
  end

  ##
  #Export a protocool as a XML file
  #
  def export
    xml = @assay.to_xml()
    send_data(xml,:type => 'text/xml; charset=iso-8859-1; header=present', :filename => @assay.name+'.xml')     
  end

  ##
  #Import a a assay xml file
  #
  def import
    @tab = params[:tab]||0
    @project = current_project
    render :action => 'list'   
  end
  #
  # Share a assay with another project
  #
  def  link
    @assay = Assay.find(params[:assay_id])
    if @assay.shareable?(current_project)
      current_project.share(@assay)
    else
      flash[:warning]="Not allowed to share #{@assay.name} with project"
    end
    redirect_to assay_url(:action => 'list')
  end

  def unlink
    @assay = Assay.find(params[:id])
    unless current_project.folder.contains?(@assay.folder)
      current_project.remove_link(@assay)
    else
      flash[:warning]="Cant remove as is owned by this domain or its children"
    end
    redirect_to assay_url(:action => 'list')
  end

  ASSAY_MODELS = [:assay,:assay_parameter,:assay_queue,:assay_protocol,
    :assay_process,:process_instance,
    :assay_workflow, :process_flow,
    :protocol_version,:parameter_context,:parameter] unless defined? ASSAY_MODELS
  ##
  #Import a a assay xml file
  #
  def import_file
    @tab=1
    Assay.transaction do
      options = {:override=>{:project_id=>current_project.id,:name=>params[:name] },
        :include=>[],:ignore=>[], :create  =>ASSAY_MODELS }
           
      options[:include] << :parameters
      options[:include] << :queues if params[:assay_queue] 
      options[:include] << :processes if params[:assay_processes]
      options[:include] << :workflows if params[:assay_workflows]
      @assay = Assay.from_xml(params[:file]||params['File'],options)  
      @assay.project = current_project
      unless @assay.save 
        flash[:error] = "Import Failed "
        return render( :action => 'import'  ) 
      end 
    end
    session.data[:current_params]=nil    
    flash[:info]= "Import Assay #{@assay.name}" 
    redirect_to( assay_url(:action => 'show', :id => @assay))

  rescue Exception => ex
    session.data[:current_params]=nil
    logger.error ex.backtrace.join("\n")
    logger.error "current error: #{ex.message}"
    flash[:error] = "Import Failed #{ex.message}"
    redirect_to assay_url(:action => 'list')
  end
  ##
  # Destroy a assay
  #
  def destroy
    begin
      Assay.transaction do
        if @assay.changeable? and right?(:data,:destroy)
          @assay.destroy
        else
          flash[:warning] ="Can not destroy #{@assay.name}"
        end
      end
    rescue Exception => ex
      flash[:error] ="destroy Failed with error: #{ex.message}"
    end
    redirect_to :action => 'list'

  end

  protected

  def setup_assays
    @tab = params[:tab]||0
    set_project(Project.load( params[:id] )) if  params[:id]
    set_element(Project.current.folder(Assay.root_folder_under))
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end

  def setup_assay
    @tab = params[:tab]||0
    @assay = Assay.load(params[:id])  
    return show_access_denied unless @assay
    @folder = current_project.folder.folder?(@assay)
    unless @folder
      set_project @assay.project
    end
    @folder ||= @assay.folder
    set_element(@folder)
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end
    
  
  
end
