# ##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
# ##

# ## Teams Dashboard controller
# 
# This manages the creation of new teams and the main pages for a team. This
# should allow easy
#  nagavation to current work in the team.
# 
# 
class Admin::TeamsController < ApplicationController

  use_authorization :teams,
    :actions => [:list,:show,:new,:grant,:deny,:create,:edit,:update,:destroy],
    :rights =>  :current_user
  
  before_filter :setup_team,
    :only => [ :show,:destroy, :add,:remove, :grant,:deny,:print,:edit,:update]
  
  before_filter :setup_teams,
    :only => [ :index,:list]
  
  in_place_edit_for :team, :name
  in_place_edit_for :team, :description
  # ## Generate a index teams the user can see
  # 
  # @return list of teams in html,xml,csv,json or as diagram page update
  # 
  # 
  def index
    respond_to do |format|
      format.html { render :action=>'index'}
      format.xml  { render :xml => @teams.to_xml }
      format.csv  { render :text => @teams.to_csv }
      format.json { render :json =>  @teams.to_json } 
    end
  end    
  # 
  # Defailt index
  # 
  def list
    index
  end

  # ## Generate a dashboard for the team
  # 
  def show
    respond_to do | format |
      format.html { render :action => 'show'}
      format.xml  { render :xml => @team.to_xml }
      format.csv  { render :text => @team.to_csv }
      format.json { render :json =>  @team.to_json } 
    end
  end
  # 
  # Show new team form
  # 
  def new
    @team= Team.new
    respond_to do |format|
      format.html # new.rhtml
    end
  end
  # 
  # Create a new team #Create
  def create
    Team.transaction do
      @team = current_user.create_team(params['team'])
      if @team.save
        flash[:notice] = "team was successfully created."
        respond_to do |format|
          format.html { redirect_to  :action => 'show',:id => @team}
          format.xml  { head :created, :location => teams_url(@team) }
        end   
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @teams.errors.to_xml }
        end
      end
    end
  end
  # 
  # Edit the team
  # 
  def edit
    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml {render :xml =>  @team.to_xml}
      format.json  { render :text => @team.to_json }
    end
  end
  
  def add
    @membership = @team.memberships.new(params[:membership])
    if @membership.save
      flash[:notice] = 'Membership was successfully created.'
    else
      flash[:error] = 'Failed to add membership because ',@membership.errors.full_messages().join(',')
    end
    redirect_to :action => 'show',:id=>@team
  end

  def remove
    @membership =@team.memberships.find(params[:membership_id])
    if @membership.destroy
      flash[:notice] = 'Membership was removed.'
    else
      flash[:warn] = 'Failed to add membership because ',@membership.errors.full_messages().join(',')
    end
    redirect_to :action => 'show',:id=>@team
  end
  
# Add a team to the access control list
# :id  the acess control list
# :team_id
# :role_id
#
  def grant
    @ace = @acl.grant(params[:owner_id],params[:role_id],params[:owner_type])
    if @ace.valid?
      flash[:notice] = "Granted Access to #{@ace.to_s}"
    else
      flash[:warn] = "Failed to grant access #{@ace.errors.full_messages().join(',')}"
    end
    redirect_to :action => 'show',:id=>@team   
  end
  #
  # Remove Access control element from the list
  # :id = AccessControlElement.id
  #
  def deny
    if @acl.deny(params[:owner_id],params[:role_id],params[:owner_type])
      flash[:notice] = "Denied access to #{params[:owner_type]}[#{params[:owner_id]}]"
    else
      flash[:warn] = "Failed deny access to #{params[:owner_type]}[#{params[:owner_id]}]"
    end
    redirect_to :action => 'show',:id=>@team   
  end  
  # 
  # Update model and change to show team
  # 
  def update
    Team.transaction do
      if @team.update_attributes(params[:team])
        flash[:notice] = 'team was successfully updated.'
        respond_to do |format|
          format.html { redirect_to  :action => 'show',:id => @team    }
          format.xml  { head :created, :location => teams_url(@team   ) }
        end   
      else
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @teams.errors.to_xml }
        end
      end
    end
  end
      
  
  # ## Destroy a team
  # 
  def destroy
    unless @team.in_use?
      @team.destroy 
    end
    respond_to do |format|
      format.html { redirect_to  :action => 'list' }
      format.xml  { head :ok }
    end
  end  

  protected
    
  def setup_teams
    @user = current_user
    @teams ||= Team.find(:all) if User.current.admin?
    @teams ||= User.current.teams
  end

  def setup_team
    @user = current_user
    @team ||= Team.find(params[:team_id]) unless params[:team_id].blank?
    @team ||= Team.find(params[:id]) unless params[:id].blank?
    @acl  = AccessControlList.from_team(@team)
    return show_access_denied unless @team.owner?(User.current)
  end  
      
end
