##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Execute::RequestServicesController < ApplicationController

  use_authorization :request,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
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

##
# Update the service 
# 
  def update_service
    logger.debug "got service status_id= #{params[:status_id]} priority_id= #{params[:priority_id]}"
    RequestService.transaction do 
      @request_service = RequestService.find(params[:id])
      @request_service.update_state(params)
      @request_service.items.each do |item| 
         item.update_state(params)
         item.save
      end   
      @request_service.save
    end
    respond_to do | format |
      format.html { render :action => 'show' }
      format.js   { render :update do | page |
        for item in @request_service.items
          page.replace_html item.dom_id(:updated_at), :partial => 'queue_item',:locals => { :queue_item => item } 
          page.visual_effect :highlight, item.dom_id(:updated_at),:duration => 1.5
        end
      end }
      format.json { render :json => @request_service.to_json }
      format.xml  { render :xml => @request_service.to_xml }
    end
  end

##
# Update a single service queue item
# 
  def update_item
    logger.debug "got item status_id= #{params[:status_id]} priority_id= #{params[:priority_id]}"
    RequestService.transaction do 
      @queue_item = QueueItem.find(params[:id])
      @queue_item.update_state(params)
      @queue_item.save
    end

    respond_to do | format |
      format.html { render :action => 'show' }
      format.js   { render :update do | page |
          page.replace_html @queue_item.dom_id(:updated_at), :partial => 'queue_item',:locals => { :queue_item => @queue_item } 
          page.visual_effect :highlight, @queue_item.dom_id(:updated_at),:duration => 1.5
      end }
      format.json { render :json => @request_service.to_json }
      format.xml  { render :xml => @request_service.to_xml }
    end
  end
  ##
  # Remove the request service
  #
  def destroy
    @request_service = RequestService.find(params[:id])
    @user_request = @request_service.request
    @request_service.destroy
    redirect_to request_url(:action => 'show', :id=>@user_request.id)
  end
  ##
  # Remove a item from a service
  # 
  def destroy_item
    QueueItem.find(params[:item_id]).destroy
    @request_service = RequestService.find(params[:id])
    redirect_to service_url(:action => 'show', :id=> @request_service.id)
  end

end
