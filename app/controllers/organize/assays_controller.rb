##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Organize::AssaysController < ApplicationController

  use_authorization :assays,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_project

  before_filter :setup_assay ,
    :only => [ :show, :edit, :update,:destroy,:print,:experiments, :parameters, :queues,:export,:protocols,:metrics]
  
  
  def index
    list
  end
  
##
# Display a List of Available assays for this user
# 
# 
  def list
   @project = current_project
    respond_to do | format |
      format.html { render :action => 'list' }
    end
  end
##
# Show a overview of the current assay
# 
  def show
    respond_to do | format |
      format.html { render :action => 'show' }
      format.json { render :json => @assay.to_json }
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
      format.pdf  { html_send_as_pdf(@assay.name, @assay.to_html) }
      format.json { render :json => @assay.to_json }
      format.xml  { render :xml => @assay.to_xml }
    end
  end 
  
##
# List of exparametersperiments for the assay.
#
  def experiments
    respond_to do | format |
      format.html { render :action => 'experiments' }
      format.ext  { render :partial => 'experiments' }
      format.json { render :json => @assay.to_json }
      format.xml  { render :xml => @assay.to_xml }
    end
  end
##
# Show the summary stats for the assay
#
  def metrics
    respond_to do | format |
      format.html { render :action => 'metrics' }
      format.ext  { render :partial => 'metrics' }
      format.json { render :json => @assay.to_json }
      format.xml  { render :xml => @assay.to_xml }
    end
  end
##
# Show the services queues for the assay
#
  def queues
    respond_to do | format |
      format.html { render :action => 'queues' }
      format.ext  { render :partial => 'queues' }
      format.json { render :json => @assay.queues.to_json }
      format.xml  { render :xml => @assay.queues.to_xml }
    end
end
##
# Configuration of a Assay. This manages the setup of parameter list and 
# list of users associated with a assay
#   
  def parameters
    respond_to do | format |
      format.html { render :action => 'parameters' }
      format.ext { render :partial => 'parameters' }
      format.json { render :json => @assay.parameters.to_json }
      format.xml  { render :xml =>  @assay.parameters.to_xml }
    end
  end
##
# Standard entry point for data entry mode for assays. This will display a list of   
# 
  def protocols
    redirect_to protocol_url(:action => 'list',:id=>@assay)
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
    @project = current_project
    @assay = Assay.new(params[:assay])
    @project.assays << @assay
    @assay.project = current_project
    @assay.team = current_team
    if @assay.save
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
      format.pdf  { render_pdf :action => 'edit',:layout=>false }
      format.json { render :json => @assay.to_json }
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
 def share 
    @assay = Assay.find(params[:assay_id])
    if @assay.shareable?(current_project)
       current_project.share(@assay)
    else
      flash[:warning]="Not Allowed to share #{@assay.name} with project"
    end
    redirect_to assay_url(:action => 'list')
 end

ASSAY_MODELS = [:assay,:assay_parameter,:assay_queue,:assay_protocol, :protocol_version,:parameter_context,:parameter] unless defined? ASSAY_MODELS
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
      options[:include] << :protocols if params[:assay_protocol]
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
    logger.error "current error: #{ex.message}"
    flash[:error] = "Import Failed #{ex.message}"
    redirect_to assay_url(:action => 'list')
 end
##
# Destroy a assay
#
  def destroy
    begin
      @successful = @assay.destroy
      session[:assay] = nil
      session[:experiment] = nil
      session[:task] = nil
      @assay = nil
    rescue
       flash[:error] = $!.to_s
       @successful  = false
    end
    redirect_to :action => 'show'
  end

protected


  def setup_assay
    @assay = current_user.assay(params[:id])  
    set_project(@assay.project) if @assay  
    @assay ||= current_project.assay(params[:id] )
    @tab = params[:tab]||0
    if @assay
      logger.info "set_assay_content(#{@assay.name})"
      @folder = @assay.folder
      ProjectFolder.current = @folder
    else
      return show_access_denied      
    end
  end
    
  
  
end
