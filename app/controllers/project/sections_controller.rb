class Project::SectionsController < ApplicationController

  def index
    redirect_to :action => 'new'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

##
# Find the current section of the project
# 
  def show
    @project = current_project
    @section = Section.find(params[:id])
  end

##
# Create a new section within the current_project 
# 
# * params[:project_id] project to created the section in
# * params[:section_id] section which is the parent of this one
# 
  def new
    @project ||= current_project
    @section = Section.new
    @section.parent = Section.find(params[:section_id]) if params[:section_id]    
  end


##
# Create a new section within the current_project 
# 
# * params[:project_id] project to created the section in
# * params[:section][<attribute>] field for item to create
# 
  def create
    @project ||= current_project
    @section   = Section.new(params[:section])  
    @section.project = @project   
    if @section.save
      flash[:notice] = 'Section was successfully created.'
      redirect_to :action => 'show',:id => @section
    else
      render :action => 'new'
    end
  end

  def edit
    @project ||= current_project
    @section = Section.find(params[:id])
  end

  def update
    @project ||= current_project
    @section = Section.find(params[:id])
    if @section.update_attributes(params[:section])
      flash[:notice] = 'Section was successfully updated.'
      redirect_to :action => 'show', :id => @section
    else
      render :action => 'edit'
    end
  end

  def destroy
    @project ||= current_project
    Section.find(params[:id]).destroy
    redirect_to :action => 'new'
  end
end
