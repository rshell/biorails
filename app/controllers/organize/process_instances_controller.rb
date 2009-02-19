# == Process Instance Controller
# This manages a creation and editing of a single step process. Here the user
# generates a data entry sheet definition.
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
class Organize::ProcessInstancesController < ApplicationController
  use_authorization :organization,
    :use => [:show,:context,:format,:index,:layout,:list,:metrics,:purge,:show],
    :build => [:new,:update,:add_context,:test,
    :add_parameter,:copy,:create,
    :destroy,:move_parameter,:release,
    :remove_context,:remove_parameter,:update,
    :update_context,:update_parameter,:withdraw]
                                    
  before_filter :setup_for_protocol_version_id ,  
    :only => [ :show,:format, :edit,:layout,:copy,:purge,:release,:withdraw,:metrics,:update,:destroy,:template,:test]
              

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
      format.xml  { render :xml =>  @assay_protocol.to_xml(:except=>[:assay]) }
      format.js   {
        render :update do | page |
          page.replace_html 'center',  :partial => 'show'
          page.replace_html 'messages',  :partial => 'shared/messages'
        end
      }
    end
  end


  def format
    unless params[:task_id].blank?
      @task = Task.find(params[:task_id])
    end
    unless params[:output_style].blank?
      @protocol_version.reformat(params[:output_style])
      flash[:info] = "Updated formats for process"
      if @task
        redirect_to task_url(:action => 'show', :id => @task.id)
      else
        redirect_to :action => 'show',:id=>@protocol_version.id
      end
    else  
      respond_to do | format |
        format.html { render :action => 'format' }
        format.ext  { render :partial => 'format' }
      end
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
  #
  # Create a QA test experiment for the process
  #
  def test
    @experiment = @protocol_version.test
    if @experiment and @experiment.tasks[0]
       flash[:notice] =" Created QA testing experiment"
       redirect_to task_url(:action => 'show', :id => @experiment.tasks[0].id,:tab=>2)
    else
       flash[:warning] =" Cant test create a test experiment"
       redirect_to :action => 'show', :id => @protocol_version.id
    end
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
    @assay = Assay.load(params[:id])   
    @assay_protocol = AssayProcess.new(params[:assay_protocol])
    @assay_protocol.assay = @assay
    if @assay_protocol.save
      @project_folder   = @assay_protocol.folder
      @protocol_version = @assay_protocol.new_version
      @protocol_version.update_attributes(params[:protocol_version])
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
    unless @protocol_version.update_attributes(params[:protocol_version]) and
        @assay_protocol.update_attributes(params[:assay_protocol])
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
    AssayProtocol.transaction do
      if @protocol_version.used?
        flash[:warning] =" This version is fixed and cant be destroyed as its in use"
      else
        protocol = @protocol_version.protocol
        (protocol.versions.size==1 ?  protocol.destroy : @protocol_version.destroy)
      end
    end
    redirect_to assay_url(:action => 'show', :id => @assay);
  end

  ##
  # update the a parameter context. This will update the label, default row and extra details
  # for all the parameters. Parametters are passed via params[:cell] and the context is passed
  # via params[:parameter_context]
  #
  def update_context
    ProtocolVersion.transaction do
      if  context_changeable?
        unless  @parameter_context.update_attributes({:label =>params[:label],
              :output_style =>params[:output_style],
              :default_count=>params[:default_count]})
          flash[:warning] = "Failed to updated in context [#{@parameter_context.path}] "
        end   
      end
    end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>2}
      format.xml  { render :xml =>  @protocol_version.to_xml(:include=>[:protocol])}
      format.js   { render :update do | page |
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['protocol_version','parameter_context','parameter'] }
          page.replace_html @parameter_context.dom_id, :partial => 'current_context', :locals => {:parameter_context => @parameter_context, :hidden => false }
          @parameter_context.children.each do |context| 
            page.replace_html context.dom_id, :partial => 'current_context',:locals => {:parameter_context => context, :hidden => false }
          end          
        end
      }
    end
  end
  ##
  # Create a new basic protocol_version context
  #
  def add_context
    begin
      @parent = @parameter_context
      if context_changeable?
        @parameter_context = @protocol_version.new_context( @parent, params[:label] )
        @parameter_context.default_count = params[:default_count] ||1
        @parameter_context.output_style = params[:output_style] ||'default'
        if @parameter_context.save
          @protocol_version.reload
          @successful  = true
          flash[:info] =" added context #{@parameter_context.label}"
        else
          flash[:warning] = "Failed to add context #{params[:label]}"
        end
      end
    rescue
      logger.warn flash[:error]= "Failed to add context"+$!.to_s
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
    if  @parameter_context.children.size>0
      flash[:error] = ' Cant delete a context row with children'
    elsif  @parameter_context.parent_id.nil?    
      flash[:error] = ' Cant delete a root context form of task'
    elsif context_changeable?
      @dom = @parameter_context.dom_id
      @successful = @parameter_context.destroy
      @protocol_version.resync_columns
      flash[:info] = 'Context successfully removed ' if @successful
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
    begin
      if context_changeable?
        Parameter.transaction do
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
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['parameter_context','parameter'] }
          if @successful
            page.replace_html @parameter_context.dom_id, :partial => 'current_context',  :locals => {:parameter_context => @parameter_context, :hidden => false }
          end
        end
      }
    end
  end
  ##
  # Update a parameter in a context with a new name or other value
  #
  def update_parameter
    @mode = 2
    ProtocolVersion.transaction do
      @parameter = Parameter.find(params[:id])
      @parameter_context =  @parameter.context
      if context_changeable?
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
    @mode = params[:mode] || 0
    ProtocolVersion.transaction do
      @parameter = Parameter.find(params[:id])
      @other = Parameter.find(params[:after])
      @parameter_context = @other.context
      if context_changeable?
        @protocol_version = @parameter_context.process
        @source = @parameter.context
        if @source != @parameter_context
          @parameter.context = @parameter_context
          @successful = @parameter.save
          flash[:notice] = "#Parameter #{@parameter.name} moved from #{@source.label} to context #{@parameter_context.label}"
        else
          @parameter.before(@other)
          @parameter_context.reload
          @successful = true
          logger.info "reorder #{@parameter_context.parameters.collect{|i|i.name}.join(',')}"
        end
      end
    end
    respond_to do | format |
      format.html { redirect_to :action => 'show', :id =>  @protocol_version, :tab=>2 }
      format.xml  { render :xml => @parameter_context.to_xml }
      format.js   {
        render :update do | page |
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['parameter_context','parameter'] }
          if @successful
            page.replace_html @parameter_context.dom_id, :partial => 'current_context', :locals => {:parameter_context => @parameter_context, :hidden => false }
          end
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
    @mode = params[:mode] || 2
    if context_changeable?
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

  def context_changeable?
    if @parameter_context.nil?
      true
    elsif !@parameter_context.process.flexible?
      flash[:warning] =" This version is fixed and cant be changed"
      false
    elsif params[:lock_version].blank?
      true
    elsif (@parameter_context.lock_version.to_s != params[:lock_version].to_s)
      flash[:warning] =" Display out of sync,looks like #{@parameter_context.updated_by} also editing it from another browser"
      false
    else
      true
    end
  end
  #
  # Setup for assay or current project is no id is passed , starting point for index,list etc
  #
  def setup_for_project
    @successful = false
    if params[:id]
      @assay = Assay.load( params[:id] )
      return show_access_denied   unless @assay
      @assay_protocols = @assay.protocols
      set_project(@assay.project)
      set_element(@assay.folder)
    else
      @assay_protocols = current_project.protocols
    end

  rescue
    return show_access_denied
  end 
  #
  # Setup for a protocol_version flow 
  #
  def setup_for_protocol_version_id
    @successful = false
    @tab=params[:tab] ||0
    @protocol_version = ProcessInstance.load(params[:id])  
    return show_access_denied  unless @protocol_version
    @assay_protocol    = @protocol_version.protocol
    @assay             = @assay_protocol.assay
    set_project(@protocol_version.protocol.project)
    set_element(@project_folder = @protocol_version.folder)
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end 

  #
  # Setup for a protocol_version flow 
  #
  def setup_for_parameter_context_id
    @successful = false
    @tab=params[:tab] ||2
    @mode = params[:mode] || 0
    @parameter_context = ParameterContext.find(params[:id],:include=>[:process=>[:protocol=>[:assay]]])
    @protocol_version = @parameter_context.process
    @assay_protocol    = @protocol_version.protocol 
    @assay = @assay_protocol.assay
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end 
  

  #
  # Setup for a protocol_version flow 
  #
  def setup_for_parameter_id
    @successful = false
    @tab=params[:tab] ||2
    @mode = params[:mode] || 0
    @parameter = Parameter.find(params[:id],:include=>[:context=>[:process=>[:protocol=>[:assay]]]])
    @parameter_context = @parameter.context
    @protocol_version = @parameter_context.process
    @assay_protocol    = @protocol_version.protocol
    @assay = @assay_protocol.assay
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end 
  
  
end
