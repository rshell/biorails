##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

##
# Teams Dashboard controller
# 
# This manages the creation of new teams and the main pages for a team. This should allow easy
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
##
# Generate a index teams the user can see
# 
# @return list of teams in html,xml,csv,json or as diagram page update
#  
#   
  def index
    @teams = User.current.teams
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

##
# Generate a dashboard for the team 
#  
  def show
    setup_team
    respond_to do | format |
      format.html { render :action => 'show'}
    end
  end
#
# Show new team form
# 
  def new
    @team = team.new
    @user = current_user
	respond_to do |format|
      format.html # new.rhtml
    end
  end
#
# Create a new team
#Create
  def create
    Team.transaction do
	  @team = current_user.create_team(params['team'])
 	  if @team.save
		  flash[:notice] = "team was successfully created."
		  set_team(@team)
		  respond_to do |format|
			  format.html { redirect_to  :action => 'show',:id => @team    }
			  format.xml  { head :created, :location => teams_url(@team   ) }
			  format.js  { render :update do | page |  
				  page.actions_panel  :partial => 'actions'
				  page.help_panel     :partial => 'help'
				  page.status_panel   :partial => 'status'
				  page.main_panel     :partial => 'show'
				end
			   }
			end   
  	  else
		  respond_to do |format|
			  format.html { render :action => "new" }
			  format.xml  { render :xml => @teams.errors.to_xml }
			  format.js  { render :update do | page |  
				  page.actions_panel  :partial => 'actions'
				  page.help_panel     :partial => 'help'
				  page.status_panel   :partial => 'status'
				  page.main_panel     :partial => 'new'
				end
			   }
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
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'edit'
        end
      }
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
			  format.js  { render :update do | page |  
				  page.actions_panel  :partial => 'actions'
				  page.help_panel     :partial => 'help'
				  page.status_panel   :partial => 'status'
				  page.main_panel     :partial => 'show'
				end
			   }
			end   
      else
		  respond_to do |format|
			  format.html { render :action => "edit" }
			  format.xml  { render :xml => @teams.errors.to_xml }
			  format.js  { render :update do | page |  
				  page.actions_panel  :partial => 'actions'
				  page.help_panel     :partial => 'help'
				  page.status_panel   :partial => 'status'
				  page.main_panel     :partial => 'edit'
				end
			   }
			end
      end
    end
  end
  
##
# Destroy a study
#
  def destroy
    setup_team
    unless @team.in_use?
        @team.destroy 
        set_team(team.find(1))    
    end
    respond_to do |format|
      format.html { rredirect_to home_url(:action => 'index') }
      format.xml  { head :ok }
      format.js  { render :update do | page |  
            page.actions_panel  :partial => 'actions'
            page.help_panel     :partial => 'help'
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'list'
          end
      }
    end
  end  

##
# List of the membership of the team
# 
  def members
    setup_team
    @membership = Membership.new(:team_id=>@team)
    respond_to do | format |
      format.html { render :action => 'members'}
      format.xml {render :xml =>  @team.to_xml(:include =>[:memberships,:owners,:users])}
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
