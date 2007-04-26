##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Execute::RequestServicesController < ApplicationController

  use_authorization :request,
                    :actions => [:list,:show,:new,:create,:edit,:update,:desrroy],
                    :rights => :current_project


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @request_service_pages, @request_services = paginate :request_services, :per_page => 10
  end

  def show
    @request_service = RequestService.find(params[:id])
    @project_folder =current_project.folder(@request_service.request)
    
  end

  def new
    @request_service = RequestService.new
  end

  def create
    @request_service = RequestService.new(params[:request_service])
    if @request_service.save
      flash[:notice] = 'RequestService was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @request_service = RequestService.find(params[:id])
    @project_folder =current_project.folder(@request_service.request)
  end

  def update
    @request_service = RequestService.find(params[:id])
    if @request_service.update_attributes(params[:request_service])
      flash[:notice] = 'RequestService was successfully updated.'
      redirect_to :action => 'show', :id => @request_service
    else
      render :action => 'edit'
    end
  end

  def update_item
    logger.debug "got item status_id= #{params[:status_id]} priority_id= #{params[:priority_id]}"
    @queue_item = QueueItem.find(params[:id])
       
    if params[:status_id]
      @queue_item.current_state_id = params[:status_id]
    elsif params[:priority_id]
      @queue_item.priority_id = params[:priority_id] 
    elsif params[:comments]
      @queue_item.comments << params[:comments] 
    end
    @queue_item.save
    return render(:action => 'queue_item.rjs') if request.xhr?
    redirect_to :action => 'show', :id => @request_service
  end

  def destroy
    RequestService.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
