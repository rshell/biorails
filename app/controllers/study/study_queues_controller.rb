##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Study::StudyQueuesController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @study = current( Study, params[:id] )
    @study_queue_pages, @study_queues = paginate :study_queues, :conditions => ["study_id=?",@study.id], :per_page => 10
  end

  def manage
    @study_queue = StudyQueue.find(params[:id])
    @study = @study_queue.study
    @queue_item_pages, @queue_items = paginate :queue_items,:conditions => ["study_queue_id=?",@study_queue.id], :per_page => 10
  end

  def show
    @study_queue = current(StudyQueue,params[:id])
  end

  def new
    @study = current( Study, params[:id] )
    @study_queue = StudyQueue.new
  end

##
# Create a new queue and append to list of queues in the study
  def create
    @study = current( Study, params[:id] )
    @study_queue = StudyQueue.new(params[:study_queue])
    @study.queues << @study_queue
    if @study_queue.save
      flash[:notice] = 'StudyQueue was successfully created.'
      redirect_to :action => 'list',:id => @study
    else
      render :action => 'new'
    end
  end

  def edit
    @study_queue = StudyQueue.find(params[:id])
    @study = @study_queue.study
  end

  def update
   @study_queue = StudyQueue.find(params[:id])
   @study = @study_queue.study
   if @study_queue.update_attributes(params[:study_queue])
      flash[:notice] = 'StudyQueue was successfully updated.'
      redirect_to :action => 'show', :id => @study_queue
    else
      render :action => 'edit'
    end
  end

  
  def update_item
    logger.debug "got item status_id= #{params[:status_id]} priority_id= #{params[:priority_id]}"
    @queue_item = QueueItem.find(params[:id])
       
    if params[:status_id]
      logger.warn "updating status #{@queue_item.status_id} to #{ params[:status_id]}"
      @queue_item.current_state_id = params[:status_id]
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
    StudyQueue.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
