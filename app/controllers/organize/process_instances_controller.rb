##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Organize::ProcessInstancesController < ApplicationController
  use_authorization :assay_protocols,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_project
                                    
  before_filter :setup_for_protocol_version_id ,  
                :only => [ :show, :edit,:layout,:copy,:purge,:release,:withdraw,:metrics,:update,:destroy,:template]
              

  before_filter :setup_for_project ,  :only => [ :new,:list,:index]

  before_filter :setup_for_parameter_context_id ,  :only => [ :add_parameter,:add_context,:remove_context,:update_context]

  before_filter :setup_for_parameter_id ,  :only => [ :update_parameter,:remove_parameter]

  helper SheetHelper

  def index
    list
  end

  def list
    respond_to do | format |
      format.html { render :action => 'list' }
      format.ext { render :partial => 'list' }
      format.json { render :json => @assay_protocols.to_json }
      format.xml  { render :xml =>  @assay_protocols.to_xml }
    end  
  end

##
# Show details for a protocol
# 
#  @return protocol definition in html,xml,json or ajax partial page update
# 
  def show
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext  { render :partial => 'show' }
      format.json { render :json => @assay_protocol.to_json }
      format.xml  { render :xml =>  @assay_protocol.to_xml(:except=>[:assay]) }
      format.js   { 
         render :update do | page |
           page.replace_html 'center',  :partial => 'show' 
           page.replace_html 'messages',  :partial => 'shared/messages' 
         end          
         }
    end  
  end
  
##
#Set the release protocol version
#
# @return redirect to list
#
  def release
    @protocol_version.released
    @protocol_version.save
    redirect_to :action => 'show', :id => @protocol_version.id
  end
  
##
#Set the withdraw protocol version
#
# @return redirect to list
#
  def withdraw
    @protocol_version.withdrawn
    @protocol_version.save
    redirect_to :action => 'show', :id => @protocol_version.id
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
    @protocol_version = @protocol_version.copy
    redirect_to :action => 'show', :id => @protocol_version.id
  end
    
##
# Puts up the form for a new protocol, this created new Protocol, ProtocolVersion objects
# 
  def new
    @assay_protocol = AssayProcess.new(:assay_id => @assay.id)
    @protocol_version = ProcessInstance.new
    respond_to do | format |
      format.html { render :action => 'new' }
      format.json { render :json => @assay_protocol.to_json }
      format.xml  { render :xml =>  @assay_protocol.to_xml(:except=>[:assay]) }
    end  
  end
##
# Create new Assay Protocol and linked AssayProcess and ProtocolVersion
# This routine expects a params[:assay_protocol] to provide the basic data needed for this
# this completes step 1 in definition of assay protocol. If this works control is 
# passed to the standard protocol editor
#
  def create
    @assay = current_user.assay(params[:id])   
    @assay.protocols <<  @assay_protocol = AssayProcess.new(params[:assay_protocol])
    if @assay_protocol.save
      @project_folder = @assay_protocol.folder
      @protocol_version   = @assay_protocol.new_version
      flash[:notice] = 'AssayProtocol was successfully created.'
      redirect_to :action => 'show', :id => @protocol_version,:tab=>2
    else  
      render :action => 'new', :id => @assay
     end
  end

###
# Update Assay to use new protocol. This saves the used defined label for the process instance
# and the allocated stage of the protocol.
#
  def update
    @tab=1
    unless @assay_protocol.update_attributes(params[:assay_protocol]) and
           @protocol_version.update_attributes(params[:protocol_version])
        respond_to do | format |
           format.html { render :action => 'show'}
          format.xml  { render :xml =>  @protocol_version.to_xml(:include=>[:protocol])}
        end
    else    
        respond_to do | format |
           format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>0}
           format.xml  { render :xml =>  @protocol_version.to_xml(:include=>[:protocol])}
        end
    end
  end  
  ##
# Show QA matrics for a protocol
# 
#  @return protocol usages stats 
# 
  def metrics
    @tab=3
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext  { render :partial => 'metrics' }
      format.json { render :json => @assay_protocol.to_json }
      format.xml  { render :xml => @assay_protocol.to_xml }
    end
  end  
###
# Edit the protocol creating a new version of the instance if the protocol is in use 
# in a existing task. As a special feature if protocol is already in use a copy is 
# ProtocolVersion is created so not to advisely effect a running task. 
# 
  def layout
    @tab=2
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext { render :partial => 'layout' }
      format.json { render :json => @assay_protocol.to_json }
      format.xml  { render :xml =>  @assay_protocol.to_xml(:except=>[:assay]) }
      format.js   { 
        render :update do | page |
           page.replace_html 'layout',  :partial => 'layout' 
           page.replace_html 'messages',  :partial => 'shared/messages' 
         end
       }
    end  

  end  
  


###
# Destory a protocol totally
#
  def destroy
    unless @protocol_version.used? 
      @protocol_version.destroy
    else  
      flash[:warning] =" This version is fixed and cant be destroyed as its in use"     
    end
    redirect_to protocol_url(:action => 'show', :id => @protocol_version);    
  end

##
# update the a parameter context. This will update the label, default row and extra details
# for all the parameters. Parametters are passed via params[:cell] and the context is passed
# via params[:parameter_context]
# 
  def update_context
   ProtocolVersion.transaction do
      if  @protocol_version.flexible? 
        unless  @parameter_context.update_attributes({:label =>params[:label],:default_count=>params[:default_count]}) 
          flash[:warning] = "Failed to updated in context [#{@parameter_context.path}] "
        end
      else  
        flash[:warning] =" This version is fixed and cant be changed"     
      end
   end
   respond_to do | format |
       format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>2}
       format.xml  { render :xml =>  @protocol_version.to_xml(:include=>[:protocol])}
       format.js   { render :update do | page |
          page.replace_html @parameter_context.dom_id, :partial => 'current_context', :locals => {:parameter_context => @parameter_context, :hidden => false }
          @parameter_context.children.each do |context| 
            page.replace_html context.dom_id, :partial => 'current_context',:locals => {:parameter_context => context, :hidden => false }
          end          
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['protocol_version','parameter_context','parameter'] }
         end 
       }
    end
  end
##
# Create a new basic protocol_version context
# 
  def add_context
   @successful  = false
   begin
      @parent = @parameter_context
      if @protocol_version.flexible? 
         @parameter_context = @protocol_version.new_context( @parent, params[:label] )
         @parameter_context.default_count = params[:default_count] ||1
         @successful  = @parameter_context.save
      else
        flash[:warning] =" This version is fixed and cant be changed"     
        @process_step=nil
       end
   rescue
      logger.warn $!.to_s
      flash[:error]= $!.to_s
   end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>2}
      format.xml  { render :xml => @parameter_context.to_xml }
      format.js   { 
        render :update do | page |
          if @successful
            page.insert_html :after,@parent.dom_id,:partial => 'current_context', :locals => {:parameter_context => @parameter_context, :hidden => false }
          end
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['parameter_context','parameter'] }
         end
       }
    end
  end

##
# This deletes a context and all its children
#
 def remove_context
    @successful = false
    if !@protocol_version.flexible? 
        flash[:warning] =" This version is fixed and cant be changed"           
    elsif  @parameter_context.children.size>0
        flash[:error] = ' Cant delete a context row with children'   
    elsif  @parameter_context.parent_id.nil?    
        flash[:error] = ' Cant delete a root context form of task'   
    else
       @dom = @parameter_context.dom_id
       @successful = @parameter_context.destroy
       @protocol_version.resync_columns
       flash[:notice] = 'Context successfully removed '
    end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>2}
      format.xml  { render :xml => @parameter_context.to_xml }
      format.js   { 
        render :update do | page |
            page.remove @dom if @successful
            page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['parameter_context','parameter'] }
         end
       }
    end
 end
  
##
# Add a new parameter to the current parameters for the instance this expects the id of parameter type, 
# instance and role to create the new record. parameter name is automatically generated
# based on the max(sequence_num) for parameters of type in the process, so you will get 
# dose,dose_1,dose_2 etc. 
#
 def add_parameter
   @successful  = false
   begin
     Parameter.transaction do
       if !@protocol_version.flexible? 
           flash[:warning] =" This version is fixed and cant be changed"   
       elsif (@parameter_context.lock_version.to_s != params[:lock_version].to_s)   
           flash[:warning] =" Display out of sync,looks liked #{@parameter_context.updated_by} also editing it from another browser"          
       else
           @mode = params[:mode] || 0
           style, id = params[:node].split("_")
           case style
             when 'sp' then @parameter = @parameter_context.add_parameter( AssayParameter.find(id) )
             when 'sq' then @parameter = @parameter_context.add_queue( AssayQueue.find(id) )
           end
           if @parameter
             @successful = @parameter.save
             @parameter.process.resync_columns
             @parameter_context.updated_at = DateTime.now
             @parameter_context.save
             @parameter_context.reload
           else
             flash[:error] = 'Parameter creation failed.'
           end
        end
     end
   rescue Exception => ex
        @successful  = false
        flash[:error] ="Failed to add parameter #{ex.message}"             
   end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>2}
      format.xml  { render :xml => @parameter_context.to_xml }
      format.js   {
        render :update do | page |
          if @successful
            page.replace_html @parameter_context.dom_id, :partial => 'current_context',  :locals => {:parameter_context => @parameter_context, :hidden => false }
          end
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['parameter_context','parameter'] }
         end
       }
    end
 end
##
# Update a parameter in a context with a new name or other value
#  
  def update_parameter
    @mode = params[:mode] || 1
   ProtocolVersion.transaction do
     @parameter = Parameter.find(params[:id])
     @parameter_context =  @parameter.context      
     unless @protocol_version.flexible? 
         flash[:warning] =" This version is fixed and cant be changed"           
     else
        @parameter.set(params[:field],params[:value])
        unless @parameter.save
          logger.error flash[:warning] = "#{flash[:warning]}\n Parameter [#{@parameter.name}] not updated in context [#{@parameter_context.path}] "
        end
     end
   end
   respond_to do | format |
      format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>2}
       format.xml  { render :xml =>  @protocol_version.to_xml(:include=>[:protocol])}
       format.js   {
         render :update do | page |
          page.replace_html @parameter_context.dom_id, :partial => 'current_context', :locals => {:parameter_context => @parameter_context, :hidden => false }
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['protocol_version','parameter_context','parameter'] }
         end 
       }
    end
 end     
##
# Change the Role of a parameter in the protocol. Afraid with drag and drop
# its easy to drop things in the wrong place so a simple recovery is needed. 
#
def move_parameter
  ProtocolVersion.transaction do
    @parameter = Parameter.find(params[:id])
    @mode = params[:mode] || 0
    @after = Parameter.find(params[:after])
    @parameter_context = @after.context 
    @protocol_version = @parameter_context.process
    @source = @parameter.context 
    if @source != @parameter_context
       @parameter.context = @parameter_context
       @successful = @parameter.save
       flash[:notice] = "#Parameter #{@parameter.name} moved from #{@source.label} to context #{@parameter_context.label}"
    else   
       @parameter.after(@after)
       @parameter_context.reload
       @successful = true
       logger.info "reorder #{@parameter_context.parameters.collect{|i|i.name}.join(',')}"
    end 
  end 
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>2 }
      format.xml  { render :xml => @parameter_context.to_xml }
      format.js   {
        render :update do | page |
          if @successful
            page.replace_html @parameter_context.dom_id, :partial => 'current_context', :locals => {:parameter_context => @parameter_context, :hidden => false }
          end
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['parameter_context','parameter'] }
         end
       }
    end
end

##
# Remove a parameter from the protocol_version context. In the drag and drop the id is sp_nnn in known its 
# a simple nnnn. 
#  
def remove_parameter
   @successful = false
   @mode = params[:mode] || 0
   begin
      id = params[:id].split("_")[1]
      id = params[:id] unless id
      logger.info "remove parameter "+id
      parameter = Parameter.find(id)
      @parameter_context = parameter.context     
      @successful = parameter.destroy
      @parameter_context.process.resync_columns
      flash[:notice] = 'Parameter successfully removed '
   rescue
      logger.warn "problem with create "+$!.to_s
      flash[:error]  = $!.to_s
   end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>2 }
      format.xml  { render :xml => @parameter_context.to_xml }
      format.js   {
        render :update do | page |
          if @successful
            page.replace_html @parameter_context.dom_id, :partial => 'current_context',:locals => {:parameter_context => @parameter_context, :hidden => false }
          end
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['parameter_context','parameter'] }
         end
       }
    end
end  

 #
 # Get a table of data for a context definition
 #
 def context
   @parameter_context = ParameterContext.find(params[:id])
   render :inline => '<%= context_model(@parameter_context) %>'
 end  

  protected  
  #
  # Setup for assay or current project is no id is passed , starting point for index,list etc
  #
  def setup_for_project
   if params[:id]
      @assay = current_project.assay( params[:id] )
      unless @assay
         return show_access_denied      
      end
      @assay_protocols = @assay.protocols
    else
      @assay_protocols = current_project.protocols
    end 
  end 
  #
  # Setup for a protocol_version flow 
  #
  def setup_for_protocol_version_id
    @tab=params[:tab] ||0
    @protocol_version = current_user.process_instance(params[:id])  
    set_project(@protocol_version.protocol.project) if @protocol_version  and @protocol_version.protocol
    @protocol_version  ||= current_project.process_instance(params[:id])
    unless @protocol_version
      return show_access_denied      
    end
    @assay_protocol    = @protocol_version.protocol
    @assay             = @assay_protocol.assay
    @project_folder    = @protocol_version.folder 
  end 

  #
  # Setup for a protocol_version flow 
  #
  def setup_for_parameter_context_id
    @tab=params[:tab] ||2
    @mode = params[:mode] || 0
    @parameter_context = ParameterContext.find(params[:id],:include=>[:process=>[:protocol=>[:assay]]])
    @protocol_version = @parameter_context.process
    @assay_protocol    = @protocol_version.protocol 
    @assay = @assay_protocol.assay
  end 
  

  #
  # Setup for a protocol_version flow 
  #
  def setup_for_parameter_id
    @tab=params[:tab] ||2
    @mode = params[:mode] || 0
    @parameter = Parameter.find(params[:id],:include=>[:context=>[:process=>[:protocol=>[:assay]]]])
    @parameter_context = @parameter.context
    @protocol_version = @parameter_context.process
    @assay_protocol    = @protocol_version.protocol
    @assay = @assay_protocol.assay
  end 
  
  
end