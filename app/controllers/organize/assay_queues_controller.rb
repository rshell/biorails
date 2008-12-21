# == Assay Queue Controller
# This manages a creation and editing of a queue for accepting stuff to 
# be processed. The AssayQueue is linked to specific data catalogue type 
# which defines the type of sample accepted.
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
class Organize::AssayQueuesController < ApplicationController

  use_authorization :organization,
                    :use => [:list,:show],
                    :build => [:new,:create,:edit,:update,:destroy]

          
  before_filter :setup_assay , :only => [ :new, :create]
  
  before_filter :setup_assay_queue , :only => [:results,:manage, :show,:items, :edit, :update,:destroy]
      
  def index
    list
    render :action => 'list'
  end
  #
  # List of queues in the current queue
  #
  def list
    if params[:id]
      @assay =  Assay.load(params[:id] )
      @assay_queues = AssayQueue.paginate  :conditions => ["assay_id=?",params[:id]], :order=>'name', :page => params[:page]
    else
      @assay_queues = AssayQueue.paginate :conditions => ["assay_id in (select id from assays where project_id = ?)",current_project.id], :order=>'name', :page => params[:page]
    end
  end
  #
  # List of results related to the current queue
  #
  def results
   @assay_queue = AssayQueue.find(params[:id])
   @assay = @assay_queue.assay
   @report = Biorails::SystemReportLibrary.queue_results("Service Queue Results") do | report |
      report.column('assay_queue_id').filter = @assay_queue.id
   end
   render :action => :report
  end
  
  #
  # manage queue page for a specific queue
  #
  def manage
    @queue_items = QueueItem.paginate :conditions => ["assay_queue_id=?",@assay_queue.id], :page => params[:page]
  end

  def show
  end

  def items
  end

  def new
    @assay_queue = AssayQueue.new
  end

##
# Create a new queue and append to list of queues in the assay
  def create
    @assay_queue = AssayQueue.new(params[:assay_queue])
    @assay.queues << @assay_queue
    if @assay_queue.save
      flash[:notice] = 'AssayQueue was successfully created.'
      redirect_to assay_url(:action => 'show',:id => @assay, :tab=>3)
    else
      render :action => 'new'
    end
  end

  def edit
    logger.info "@assay_queue #{@assay_queue.new_record?}"
    @assay = @assay_queue.assay
  end

  def update
   if @assay_queue.update_attributes(params[:assay_queue])
      flash[:notice] = 'AssayQueue was successfully updated.'
      redirect_to :action => 'show', :id => @assay_queue
    else
      render :action => 'edit'
    end
  end

##
# Update the service 
# 
  def update_service
    logger.info "got service status_id= #{params[:status_id]} priority_id= #{params[:priority_id]}"
    
    RequestService.transaction do 
      @request_service = RequestService.find(params[:id])
      @assay_queue = @request_service.queue
      @assay = @assay_queue.assay
      @request_service.update_state(params)
    end
    
    respond_to do | format |
      format.html { render :action => 'show' }
      format.js   { render :update do | page |
          page.replace_html @request_service.dom_id(:updated_at), :partial => 'request_service',:locals => { :queue_item => @request_service } 
          page.message_panel(:partial => 'shared/messages', :locals => { :objects => [:request_service,:assay_queue] })
          page.visual_effect :highlight, @request_service.dom_id(:updated_at),:duration => 1.5
      end }
      format.json { render :json => @request_service.to_json }
      format.xml  { render :xml => @request_service.to_xml }
    end
  end
  
  def update_item
    logger.debug "got item status_id= #{params[:status_id]} priority_id= #{params[:priority_id]}"
    @queue_item = QueueItem.find(params[:id])
       
    if params[:status_id]
      logger.warn "updating status #{@queue_item.status_id} to #{ params[:status_id]}"
      @queue_item.status_id = params[:status_id]
    elsif params[:priority_id]
      logger.warn "updating priority #{@queue_item.priority_id} to  #{ params[:priority_id]}"
      @queue_item.priority_id = params[:priority_id] 
    elsif params[:comments]
      logger.warn "updating commets to  #{ params[:comments]}"
      @queue_item.comments << params[:comments] 
    end
    @queue_item.save
    render :partial => 'queue_item', :locals => { :queue_item => @queue_item}
  end

  def destroy
    AssayQueue.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
protected  
  
  #
  # Setup for a assay with check access
  #
  def setup_assay
    @assay = Assay.load(params[:id])    
    @assay ||= current_project.assay(params[:id])
    unless @assay
      return show_access_denied      
    end
    set_element(@assay.folder)
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end
  #
  # Setup for a specific assay queue with check access
  #
  def setup_assay_queue
    @assay_queue = AssayQueue.load(params[:id])
    unless @assay_queue
      return show_access_denied      
    end
    @assay = @assay_queue.assay
    set_project(@assay.project)   
    set_element(@assay_queue.folder)
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end  
end
