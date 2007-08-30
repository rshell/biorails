class Project::MembershipsController < ApplicationController

  use_authorization :membership,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights =>  :current_project  

def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @membership_pages, @memberships = paginate :memberships, :conditions=>['project_id=?',current_project.id], :per_page => 10
  end

  def show
    @membership = current_project.memberships.find(params[:id])
  end

  def new
    
    @membership = Membership.new(:project_id=>current_project)
  end

  def create
    @membership = Membership.new(params[:membership])
    current_project.memberships  << @membership    
    if @membership.save
      flash[:notice] = 'Membership was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update_attributes(params[:membership])
      flash[:notice] = 'Membership was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    if @membership.project_id == 1
       flash[:warning]="Cant delete user from the default public group"
       render :action => 'edit'
    else
       @membership.destroy
      redirect_to :action => 'list'
    end
  end
end
