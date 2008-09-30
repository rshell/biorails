# == Request Controller
# This managages a request to run a list fo services with a list of inventory
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
#
class Execute::RequestsController < ApplicationController

  use_authorization :execution,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user
                  
  before_filter :setup_requests,
    :only => [ :list,:index,:new,:create] 

  before_filter :setup_request,
    :only => [ :show, :edit, :update,:destroy,:results,:add_item,:add_service] 
##
# Catch for queue model needed to include helper model for it to work in queue.action
# 
  def index
    list
    render :action => 'list'
  end

##
# List of all the items for set queue
# 
  def list                                     
    @report = Biorails::ReportLibrary.project_request_list 
    @report.column('project_id').filter = current_project.id
    @report.set_filter(params[:filter])if params[:filter] 
    @report.add_sort(params[:sort]) if params[:sort]
  end
  
##
# Show the status of a request item with a history of testing of the requested item in the 
# current assay. eg a schedule of task data entry
  def show
  end

# Show the status of a request item with a history of testing of the requested item in the 
# current assay. eg a schedule of task data entry
  def results
   @report = Biorails::ReportLibrary.request_results_list do | report |
      report.column('service.request_id').filter = @user_request.id.to_s
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   render :action => :report
  end
##
# Display form for a new request item
  def new
    @user_request = Request.new(:expected_at=> Time.new+14.day,:name=> Identifier.next_id(Request))
  end

##
# Create a new request item 
# Allows multiple items to be created in a single request 
#
  def create
    ok = true
    @user_request = Request.create(params[:user_request])
    if @user_request.valid?
       set_project @user_request.project
       @project_folder =@user_request.folder
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
    @item = @user_request.add_item(params[:value])
    unless @item
      flash[:warning] = " Could not find '#{@user_request.data_element.name}' with name '#{params[:value]}' in database "
    end
    
    respond_to do | format |
      format.html { redirect_to :action => 'edit',:id=> @user_request.id }
      format.xml  { render :xml => @user_request.to_xml }
      format.js   { 
        render :update do | page |
           if @item and @item.valid?
              page.replace_html 'current_items',  :partial => 'list_items', :locals => { :request => @user_request }
           end           
           page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['user_request','item'] }
         end 
         }
    end
  end

##
# remove a service from the requested list  
# 
  def remove_item
    @user_request = Request.find(params[:request_id])
    @list_item = ListItem.find(params[:id])
    @user_request.remove_item(@list_item.value)
    @list_item.destroy

    respond_to do | format |
      format.html { redirect_to :action => 'show',:id=> @user_request.id }
      format.xml  { render :xml => @user_request.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html 'current_items',  :partial => 'list_items', :locals => { :request => @user_request } 
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['user_request'] }
         end 
         }
    end

  end

###
# add a service to the current request
#   
  def add_service
    @queue = AssayQueue.find(params[:service][:id])
    @user_request.add_service(@queue)
    
    respond_to do | format |
      format.html { redirect_to :action => 'edit',:id=> @user_request.id }
      format.xml  { render :xml => @user_request.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html 'current_services',  :partial => 'list_services', :locals => { :request => @user_request } 
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['user_request','queue'] }
         end 
         }
    end
  end

##
# remove a service from the requested list  
# 
  def remove_service
    @request_service = RequestService.find(params[:id])
    @user_request = @request_service.request
    @request_service.destroy

    respond_to do | format |
      format.html { redirect_to :action => 'edit',:id=> @user_request.id }
      format.xml  { render :xml => @user_request.to_xml }
      format.js   { 
        render :update do | page |
          page.replace_html 'current_services',  :partial => 'list_services', :locals => { :request => @user_request } 
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['user_request'] }
         end 
         }
    end

  end
  
##
# Display the edit form for a item in the request
  def edit
  end


##
# update a item in the request
# <Merge Conflict>
  def update
    Request.transaction do
      @user_request.status_id = params[:user_request][:status_id] if params[:user_request]
      @user_request.started_at ||= Time.new
      if @user_request.update_attributes(params[:user_request])
          @user_request.services.each do |service|
             service.submit 
        end
        flash[:notice] = 'QueueItem was successfully updated.'
        redirect_to :action => 'show',:id=>@user_request.id
      else
        render :action => 'edit'
      end
    end   
  end

##
# Delete the current request
# 
  def destroy
    @user_request.destroy
    redirect_to :action => 'list'
  end
  
protected

  def setup_requests
    set_project(Project.load( params[:id] )) if  params[:id]    
  end  

  def setup_request
    @user_request = Request.find(params[:id])
    return show_access_denied unless @user_request   
    @project_folder =current_project.folder(@user_request)
    return true
  rescue
    return show_access_denied
  end  
  
end
