##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Execute::RequestsController < ApplicationController

  use_authorization :requests,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
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
   @project = current_project
   @report = Report.internal_report("RequestList",Request) do | report |
      report.column('project_id').filter = @project.id
      report.column('project_id').is_visible = false
      report.column('name').customize(:order_num=>1)
      report.column('name').is_visible = true
      report.column('name').action = :show
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   
   @data_pages = Paginator.new self, @project.reports.size, 20, params[:page]
   @data = @report.run({:limit  =>  @data_pages.items_per_page, :offset =>  @data_pages.current.offset })                            
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
    @project_folder =@user_request.folder
  end


##
# Show the status of a request item with a history of testing of the requested item in the 
# current study. eg a schedule of task data entry
  def results
    @user_request = current(Request,params[:id])
    @project_folder =@user_request.folder
  end

  def results
   @user_request = current(Request,params[:id])
   @project_folder =@user_request.folder

   @report = Report.internal_report("Request Results",QueueResult) do | report |
      report.column('service.request_id').filter = @user_request.id.to_s
      report.column('service.name').is_filterible = true
      report.column('queue.name').is_filterible = true
      report.column('subject').is_filterible = true
      report.column('label').is_filterible = true
      report.column('parameter_name').is_filterible = true
      report.column('data_value').is_visible = true
      report.column('id').is_visible = false
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   @data_pages = Paginator.new self, 1000, 20, params[:page]
   @data = @report.run({:limit  =>  @data_pages.items_per_page, :offset =>  @data_pages.current.offset })
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
    @user_request = Request.find(params[:id])
    @item = @user_request.add_item(params[:value])
    unless @item
      flash[:warning] = " Could not find '#{@user_request.data_element.name}' with name '#{params[:value]}' in database "
    end
    
    respond_to do | format |
      format.html { redirect_to :action => 'edit',:id=> @user_request.id }
      format.xml  { render :xml => @user_request.to_xml }
      format.js   { render :update do | page |
           page.replace_html 'current_items',  :partial => 'list_items', :locals => { :request => @user_request } 
           page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['user_request','item'] }
         end }
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
      format.js   { render :update do | page |
          page.replace_html 'current_items',  :partial => 'list_items', :locals => { :request => @user_request } 
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['user_request'] }
         end }
    end

  end

###
# add a service to the current request
#   
  def add_service
    @user_request = Request.find(params[:id])
    @queue = StudyQueue.find(params[:service][:id])
    @user_request.add_service(@queue)
    
    respond_to do | format |
      format.html { redirect_to :action => 'edit',:id=> @user_request.id }
      format.xml  { render :xml => @user_request.to_xml }
      format.js   { render :update do | page |
          page.replace_html 'current_services',  :partial => 'list_services', :locals => { :request => @user_request } 
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['user_request','queue'] }
         end }
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
      format.js   { render :update do | page |
          page.replace_html 'current_services',  :partial => 'list_services', :locals => { :request => @user_request } 
          page.replace_html "messages", :partial => 'shared/messages', :locals => { :objects => ['user_request'] }
         end }
    end

  end
  
##
# Display the edit form for a item in the request
  def edit
    @user_request = Request.find(params[:id])
    @project_folder =current_project.folder(@user_request)
  end


##
# update a item in the request
# <Merge Conflict>
  def update
    Request.transaction do
      @user_request = Request.find(params[:id])
      @user_request.status_id = params[:user_request][:status_id]
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
    Request.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  

  
end
