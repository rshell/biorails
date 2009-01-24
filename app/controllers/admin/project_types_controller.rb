##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
#

#
# This manages the list of Project Types in the system. It was added to provide
# the bases for customization of project dashboards. Each Project Type as a
# specific set of views associated with it.
# 
# Actions supported:-
# * list         list all items
# * new/create   create a new item
# * edit/update  edit a exiting item
# * destroy      destroy item and all its dependent objects
# 

class Admin::ProjectTypesController < ApplicationController

  use_authorization :catalogue,
              :admin => [:new,:create,:destroy,:edit,:index,:list,:show,:update]
   
  before_filter :find_project_type ,
    :only => [ :show, :edit, :update,:destroy]

  before_filter :find_project_types ,
    :only => [ :grid,:list,:index]
  
  #
  # Get the current page of project_types tables
  # 
  # GET /project_types
  # GET /project_types.xml
  # GET /project_types.csv
  # GET /project_types.json
  #
  def list
    respond_to do |format|
      format.html { render :action => 'list'}
      format.xml  { render :xml => @project_types.to_xml }
      format.csv  { render :text => @project_types.to_csv }
    end
  end
  #
  # Alias to list
  #
  def index 
    return list
  end
  #
  # Show the current project_type value
  #
  # GET /project_types/1
  # GET /project_types/1.xml
  def show
    @project_type = ProjectType.find(params[:id])
    @state_flow = @project_type.state_flow
     @state_flow ||= StateFlow.find(:first)
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @project_type.to_xml }
    end
  end

  #
  # Show a new record form to be filled in
  # params[:id] primary key of the record
  #
  # GET /project_types/new
  #
  def new
    @project_type = ProjectType.new
    respond_to do |format|
      format.html # new.rhtml
      format.xml  { render :xml => @project_type.to_xml }
     end  
   end
  #
  # Show a edit form of the current record
  # params[:id] primary key of the record
  #
  # GET /project_types/1;edit
  #
  def edit
    @project_type = ProjectType.find(params[:id])
    respond_to do |format|
      format.html # edit.rhtml
      format.xml  { render :xml => @project_type.to_xml }
    end
  end

  #
  # Create a project_type bassed on passed data
  # params[:project_type][<columns>] contain the data
  # 
  # POST /project_types
  # POST /project_types.xml
  def create
    @project_type = ProjectType.new(params[:project_type])

    respond_to do |format|
      if @project_type.save
        flash[:notice] = 'ProjectType was successfully created.'
        format.html { redirect_to project_type_url() }
        format.xml  { head :created, :location => project_type_url(@project_type) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_type.errors.to_xml }
      end
    end
  end

  # PUT /project_types/1
  # PUT /project_types/1.xml
  def update
    @project_type = ProjectType.find(params[:id])
    respond_to do |format|
      if @project_type.update_attributes(params[:project_type])
        flash[:notice] = 'ProjectType was successfully updated.'
        format.html { redirect_to project_type_url() }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_type.errors.to_xml }
      end
    end
  end

  # DELETE /project_types/1
  # DELETE /project_types/1.xml
  def destroy
    @project_type = ProjectType.find(params[:id])
    @project_type.destroy

    respond_to do |format|
      format.html { redirect_to project_type_url() }
      format.xml  { head :ok }
    end  
  end

protected  
  def find_project_type
    @project_type = ProjectType.find(params[:id])
  end

  
#
# Get the current page of objects
# 
  def find_project_types
    start = (params[:start] || 0).to_i
    size = (params[:limit] || 25).to_i 
    sort_col = (params[:sort] || 'id')
    sort_dir = (params[:dir] || 'ASC')
    page = ((start/size).to_i)+1   
    @project_types = ProjectType.find(:all, 
           :limit=> size,
           :offset=> start, 
           :order=> sort_col+' '+sort_dir)
  end

end
