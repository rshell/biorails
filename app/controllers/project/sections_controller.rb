class Project::SectionsController < ApplicationController
  def index
    list
    render :action => 'new'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }


  def show
    @section = Section.find(params[:id])
  end

  def new
    @project = current_project
    @section = Section.new
  end

  def create
    @section = Section.new(params[:sections])
    if @section.save
      flash[:notice] = 'Sections was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    if @section.update_attributes(params[:sections])
      flash[:notice] = 'Section was successfully updated.'
      redirect_to :action => 'show', :id => @section
    else
      render :action => 'edit'
    end
  end

  def destroy
    Section.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
