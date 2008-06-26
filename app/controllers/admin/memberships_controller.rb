##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class Admin::MembershipsController < ApplicationController

  use_authorization :teams,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights =>  :current_project  

def index
    list
    render :action => 'list'
  end

  def list
    @team = Team.find(params[:id]) if params[:id]
    @team ||= current_project.team
    @memberships = Membership.paginate  :conditions=>['team_id=?',@team.id], :order=>'role_id,updated_at', :page => params[:page]
  end

  def show
    @membership = Membership.find(params[:id])
    @team = @membership.team
  end

  def new    
    @team = Team.find(params[:id]||params[:team_id])
    @membership = Membership.new(:team_id=>current_team)
  end

  def create
    @team = Team.find(params[:id]||params[:team_id])
    @membership = Membership.new(params[:membership])
    @team.memberships << @membership
    if @membership.save
      flash[:notice] = 'Membership was successfully created.'
      redirect_to :action => 'list',:id=>@team
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
      redirect_to :action => 'list',:id=>@team
    else
      render :action => 'edit'
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    @team = @membership.team
    if @membership.team_id == 1
        flash[:warning]="Cant delete user from the default public group"
        redirect_to :action => 'list',:id=>@team
    else
        @membership.destroy
        redirect_to :action => 'list',:id=>@team
    end
  end
end
