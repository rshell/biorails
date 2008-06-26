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
    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
    :rights =>  :current_team  

  helper :calendar
  
  in_place_edit_for :team, :name
  in_place_edit_for :team, :description
  # ## Generate a index teams the user can see
  # 
  # @return list of teams in html,xml,csv,json or as diagram page update
  # 
  # 
  def index
    @teams = Team.find(:all) if User.current.admin?
    @teams ||= User.current.teams
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
    setup_team
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
    @team = Team.new
    @user = current_user
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
        set_team(@team)
        respond_to do |format|
          format.html { redirect_to  :action => 'show',:id => @team    }
          format.xml  { head :created, :location => teams_url(@team   ) }
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
    setup_team
    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml {render :xml =>  @team.to_xml}
      format.json  { render :text => @team.to_json }
    end
  end
  # 
  # Update model and change to show team
  # 
  def update
    Team.transaction do
      setup_team
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
    setup_team
    unless @team.in_use?
      @team.destroy 
      set_team(Team.find(1))    
    end
    respond_to do |format|
      format.html { redirect_to  :action => 'list' }
      format.xml  { head :ok }
    end
  end  

  protected

  def setup_team
    if params[:id]
      @team = Team.find(params[:id])
    else 
      @team = current_team  
    end
    @memberships = @team.memberships
  end
      
end
