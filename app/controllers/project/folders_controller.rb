class ProjectFoldersController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @project = current_project
  end

  def show
    @project = current_project
    @project_folder = ProjectFolder.find(params[:id])
  end

  def new
    @project = current_project
    @project_folder = ProjectFolder.new
  end

  def create
    @project = current_project
    @project_folder = ProjectFolder.new(params[:project_folder])
    if @project_folder.save
      flash[:notice] = 'ProjectFolder was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @project = current_project
    @project_folder = ProjectFolder.find(params[:id])
  end

  def update
    @project = current_project
    @project_folder = ProjectFolder.find(params[:id])
    if @project_folder.update_attributes(params[:project_folder])
      flash[:notice] = 'ProjectFolder was successfully updated.'
      redirect_to :action => 'show', :id => @project_folder
    else
      render :action => 'edit'
    end
  end

  def destroy
    ProjectFolder.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
