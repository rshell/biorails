# == Process Flow Controller
# This manages a creation and editing of a multiple step process flow. Here the user
# generates a table of processes with relative time offsets.
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
#
class Organize::ProcessFlowsController < ApplicationController

  use_authorization :organization,
                    :use => [:show,:list,:index],
                    :build => [:new,:add,:change,:copy,:create,:edit,:release,
                               :step,:update,:withdraw]

  before_filter :setup_for_process_step_id ,  
                :only => [ :remove,:change,:step]
              
  before_filter :setup_for_process_flow_id ,  
                :only => [ :show, :edit, :update,:add, :tree,:release,:withdraw,:purge,:copy,:modernize, :destroy]
              
  before_filter :setup_for_project ,  :only => [ :new,:list,:index]
  
  def index
    list
  end
  
##
#List the protocols in the assay
#
# @return list of protocols in html or xml
#
  def list
    if params[:id]
      @assay_protocols = @assay.protocols
    else
        @assay_protocols = current_project.protocols
    end  
    @assay_protocols
    respond_to do | format |
      format.html { render :action => 'list' }
      format.ext { render :partial => 'list' }
      format.xml  { render :xml =>  @assay_protocols.to_xml }
    end  
  end  
  
##
#Set the release protocol version
#
# # @return redirect to list
#
  def release
    @process_flow.released
    @process_flow.save
    redirect_to :action => 'show', :id => @process_flow.id
  end
  
##
#Set the withdraw protocol version
#
# @return redirect to list
#
  def withdraw
    @process_flow.withdrawn
    @process_flow.save
    redirect_to :action => 'show', :id => @process_flow.id
  end
    
##
#
# remove unused versions of the protocol
# 
  def purge
    @assay_protocol.purge
    @assay_protocol.save
    redirect_to :action => 'show', :id => @assay_protocol.latest
  end
#
# Create a new version of a workflow
#
  def copy
    @process_flow = @process_flow.copy
    @process_flow.modernize
    redirect_to :action => 'show', :id => @process_flow.id
  end

  def modernize
    @process_flow.modernize
    redirect_to :action => 'show', :id => @process_flow.id
  end

# Show details for a protocol
# 
#  @return protocol definition in html,xml,json or ajax partial page update
# 
  def show
    respond_to do | format |
      format.html { render :action => 'show' }
      format.xml  { render :xml =>  @assay_protocol.to_xml(:except=>[:assay]) }
    end  
  end

##
# Puts up the form for a new protocol, this created new Protocol, ProtocolVersion objects
# 
  def new
    @assay_protocol = AssayWorkflow.new(:assay_id => @assay.id)
    @process_flow = ProcessFlow.new
    respond_to do | format |
      format.html { render :action => 'new' }
      format.xml  { render :xml =>  @assay_protocol.to_xml(:except=>[:assay]) }
      format.js   { 
        render :update do | page |
           page.replace_html 'center',  :partial => 'new' 
           page.replace_html 'messages',  :partial => 'shared/messages' 
         end
       }
    end  
  end
  
#
# Create a new process flow in a assay protocol. 
#  
  def create 
    @assay          = Assay.load(params[:id])   
    @assay.protocols << @assay_protocol = AssayWorkflow.new(params[:assay_protocol])
    if @assay_protocol.save
      @project_folder = @assay_protocol.folder
      @process_flow   = @assay_protocol.new_version
      flash[:notice] = 'Assay Workflow was successfully created.'
      redirect_to :action => 'show', :id =>  @process_flow,:tab=>2
    else  
      render :action => 'new'
     end    
  end
#
# loader for tree of protocols 
# 
# projects->stuides->versions(release)
# 
#
  def tree
    object = from_dom_id(params[:node])
    @items = @process_flow.linked_items(object)    
    return render( :text => @items.collect{|i|{
                                :id=>i.dom_id,
                                :iconCls=>"icon-#{i.class.to_s.underscore}",
                                :leaf => i.is_a?(ProtocolVersion),
                                :text=>i.name}}.to_json )
  rescue Exception => ex
    logger.warn "failed to run SQL for tree items "+ex.message
    logger.debug ex.backtrace.join("\n")  
    return render( :text => [{:id=>'error',:text=>ex.message}].to_json )
  end  
###
# Destory a protocol totally
#
  def destroy
    AssayProtocol.transaction do
      if @process_flow.used?
        flash[:warning] =" This version is fixed and cant be destroyed as its in use"
      else
        protocol = @process_flow.protocol
        (protocol.versions.size<2 ?  protocol.destroy : @process_flow.destroy)
      end
    end
    redirect_to assay_url(:action => 'show', :id => @assay);
  end

###
# Edit the protocol creating a new version of the instance if the protocol is in use 
# in a existing task. As a special feature if protocol is already in use a copy is 
# ProtocolVersion is created so not to advisely effect a running task. 
# 
  def edit
    @tab=1
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext  { render :partial => 'edit' }
      format.xml  { render :xml => @assay_protocol.to_xml }
    end
  end
###
# Update Assay to use new protocol. This saves the used defined label for the process instance
# and the allocated stage of the protocol.
#
  def update
    ok = true
    begin
      ok = @process_flow.update_attributes(params[:process_flow]) and
           @assay_protocol.update_attributes(params[:assay_protocol])
    rescue 
      ok =false
    end
    @tab=1    
    unless ok
        logger.warn flash[:warning] = "Failed to update workflow [#{@assay_protocol.name}] "
        respond_to do | format |
          format.html { render :action => 'show'}
          format.xml  { render :xml =>  @process_flow.to_xml(:include=>[:protocol])}
        end
    else    
        respond_to do | format |
           format.html { redirect_to :action => 'show', :id =>  @process_flow, :tab=>0}
           format.xml  { render :xml =>  @process_flow.to_xml(:include=>[:protocol])}
        end
    end
  end

#
# add a step to the worflow
#  
  def add
   @tab =2   
   if @process_flow.flexible? 
     if params[:process_step]
       @process = ProcessInstance.find(params[:process_step][:protocol_version_id]) 
     elsif params[:node]
       @process = from_dom_id(params[:node]) 
     end
     @process_step = @process_flow.add(@process) if @process
     @versions = @process_step.process.protocol.versions.released.collect{|i|[i.name,i.id]} if  @process_step
   else
     flash[:warning] =" This version is fixed and cant be changed"     
   end
   respond_to do | format |
        format.html { render :action => 'show' }
        format.xml  { render :xml => @process_flow.to_xml }
        format.js   { 
          render :update do | page |
            page.replace_html 'schedule', :partial => 'schedule'
            page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['process_flow'] }
           end
         }
      end
  end
#
# remove a step from the workflwo
#
  def remove
   @tab =2   
   if @process_flow.flexible?
     @process_step.destroy
   else
     flash[:warning] =" This version is fixed and cant be changed"     
   end
   @process_step=nil
   respond_to do | format |
        format.html { render :action => 'show' }
        format.xml  { render :xml => @process_flow.to_xml }
        format.js   { 
          render :update do | page |
            page.replace_html 'schedule', :partial => 'schedule'
            page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['process_flow'] }
           end
         }
      end
  end
#
# Show Step Edit form
#
  def step
   @tab =2
   unless @process_flow.flexible? 
     flash[:warning] =" This version is fixed and cant be changed"     
     @process_step=nil
   end
   respond_to do | format |
        format.html { render :action => 'show' }
        format.xml  { render :xml => @process_flow.to_xml }
        format.js   { 
          render :update do | page |
            page.replace_html 'schedule', :partial => 'schedule'
           end 
           }
      end
  end  
 #
 # Update the a step with new protocol version or reschedule
 #
  def change
   if params[:commit]== l(:Save) and @process_flow.flexible?
      @process_step.update_attributes(params[:process_step])
   end
   @process_step =nil if @process_step.valid?     
   @tab =2   
   respond_to do | format |
        format.html { render :action => 'show' }
        format.xml  { render :xml => @process_flow.to_xml }
        format.js   {
          render :update do | page |
            page.replace_html 'schedule', :partial => 'schedule'
           end
         }
      end
  end

  protected  
 
 def setup_for_project
    @tab = params[:tab]||0
    if params[:id]
      @assay = current_project.assay( params[:id] )
      return show_access_denied unless @assay
      @assay_protocols = @assay.protocols
      set_project(@assay.project)
      set_element(@assay.folder)
    else
      @assay_protocols = current_project.protocols
    end
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end 
  #
  # Setup for a process flow 
  #
  def setup_for_process_flow_id
    @tab = params[:tab]||0
    @process_flow = ProcessFlow.load(params[:id])  
    return show_access_denied unless @process_flow
    @assay_protocol  = @process_flow.protocol
    @assay           = @assay_protocol.assay
    set_project(@process_flow.protocol.project)
    set_element(@project_folder  = @process_flow.folder)
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end 
  #
  # Filter to setup scope for a process step
  #
  def setup_for_process_step_id
    @tab = params[:tab]||0
    @process_step    = ProcessStep.find(params[:id])
    @process_flow    = @process_step.flow
    @versions = @process_step.process.protocol.versions.released.collect{|i|[i.name,i.id]} if  @process_step
    @assay_protocol  = @process_flow.protocol
    @assay           = @assay_protocol.assay
    set_element @project_folder  = @process_flow.folder
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end 
  
end
