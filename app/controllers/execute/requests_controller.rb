##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Execute::RequestsController < ApplicationController

  use_authorization :experiment,
                    :actions => [:list,:show,:new,:create,:edit,:update,:desrroy],
                    :rights => :current_project


##
# Catch for queue model needed to include helper model for it to work in queue.action
# 


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }


##
# List of all the items for set queue
# 
  def list      
   @report = Report.find_by_name("RequestList") 
   unless @report
      @report = report_list_for("RequestList",Request)
      @report.save
   end  
    @report.params[:controller]='requests'   
    @report.params[:action]='show'   
    @report.set_filter(params[:filter])if  params[:filter] 
    @report.add_sort(params[:sort]) if params[:sort]
    @queue_items_pages = Paginator.new self, QueueItem.count, 50, params[:page]
    @queue_items = @report.run({:limit  =>  @queue_items_pages.items_per_page,
                                :offset =>  @queue_items_pages.current.offset })
  end


##
# List of all reports related to requests
#
  def reports
   @report = Report.find_by_name("RequestReports") 
   unless @report
      @report = reports_on_models("RequestReports",[QueueItem,StudyQueue])  
      @report.save
   end  
   @report.params[:controller]='requests'
   @report.params[:action]='show'   
   @report.set_filter(params[:filter])if params[:filter] 
   @report.add_sort(params[:sort]) if params[:sort]
  end
  
##
# Show the status of a request item with a history of testing of the requested item in the 
# current study. eg a schedule of task data entry
  def show
    @user_request = current(Request,params[:id])
    @project_folder =current_project.folder(@user_request)
  end

##
# Display form for a new request item
  def new
    @user_request = Request.new(:name=> Identifier.next_id(Request))
    @user_request.requested_by_user_id = current_user.id
    @user_request.status_id = 0
  end

##
# Create a new request item 
# Allows multiple items to be created in a single request 
#
  def create
    ok = true
    @user_request = Request.create(params[:user_request])
    @user_request.project = current_project
    if @user_request
      @project_folder =current_project.folder(@user_request)
      flash[:notice] = 'Request was successfully created.'
      redirect_to :action => 'edit',:id=> @user_request.id
    else
      flash[:warning] = " Failed to create request "
      render :action => 'new'
    end
  end

##
# add a item to the request
# 
  def add_item
    @user_request = Request.find(params[:id])
    @item = @user_request.add_item(params[:name])
    unless @item
      flash[:warning] = " Could not find #{@user_request.data_element.name} with name #{params[:name]} in database "
    end
    return render(:action => 'add_item.rjs') if request.xhr?
    redirect_to :action => 'edit',:id=>@user_request.id
  end

##
# remove a service from the requested list  
# 
  def remove_item
    @user_request = Request.find(params[:request_id])
    @list_item = ListItem.find(params[:id])
    @user_request.remove_item(@list_item.value)
    @list_item.destroy
    return render(:action => 'refresh_services.rjs') if request.xhr?
    redirect_to :action => 'edit',:id=>@user_request.id
  end

###
# add a service to the current request
#   
  def add_service
    @user_request = Request.find(params[:id])
    @queue = StudyQueue.find(params[:service][:id])
    @user_request.add_service(@queue)
    return render(:action => 'add_service.rjs') if request.xhr?
    redirect_to :action => 'edit',:id=>@user_request.id
  end

##
# remove a service from the requested list  
# 
  def remove_service
    @request_service = RequestService.find(params[:id])
    @user_request = @request_service.request
    @request_service.destroy
    return render(:action => 'refresh_services.rjs') if request.xhr?
    redirect_to :action => 'edit',:id=>@user_request.id
  end
##
# Display the edit form for a item in the request
  def edit
    @user_request = Request.find(params[:id])
    @project_folder =current_project.folder(@user_request)
  end


##
# update a item in the request
# 
  def update
    @user_request = Request.find(params[:id])
    @user_request.status_id = params[:user_request][:status_id]
    if @user_request.update_attributes(params[:user_request])
      
      @user_request.services.each{|item|item.submit}   
      flash[:notice] = 'QueueItem was successfully updated.'
      redirect_to :action => 'show',:id=>@user_request.id
    else
      render :action => 'edit'
    end
  end

##
# Delete the current request
# 
  def destroy
    Request.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  

  
end
