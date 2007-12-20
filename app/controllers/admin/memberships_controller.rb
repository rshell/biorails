class Admin::MembershipsController < ApplicationController

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
    @team = current_project.team
    @memberships = Membership.paginate  :conditions=>['team_id=?',@team.id], :order=>'role_id,updated_at', :page => params[:page]
  end

  def show
    @membership = Membership.find(params[:id])
    @team = @membership.team
  end

  def new    
    @team = current_project.team
    @membership = Membership.new(:team_id=>current_team)
  end

  def create
    @team = current_project.team
    @membership = Membership.new(params[:membership])
    @team.memberships  << @membership    
    if @membership.save
      flash[:notice] = 'Membership was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @membership = Membership.find(params[:id])
    @team = @membership.team
  end

  def update
    @membership = Membership.find(params[:id])
    @team = @membership.team
    if @membership.update_attributes(params[:membership])
      flash[:notice] = 'Membership was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    @team = @membership.team
    if @membership.project_id == 1
        flash[:warning]="Cant delete user from the default public group"
        redirect_to :action => 'list'
    else
        @membership.destroy
        redirect_to :action => 'list'
    end
  end
end
