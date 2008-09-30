##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class Admin::UsersController < ApplicationController
 
##
#  
  use_authorization :users,
                    {:actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user }

 ##
 # List all the users on the systems. Currently not paginated 
 #
  def index
    list
    render :action=>'list'
  end
  
  def list 
    @users = User.find(:all)
  end

  def show
    @user = current(User,params[:id])
  end 

  def edit
    @user = current(User,params[:id])
  end 
 ##
 # put up a new default user account form 
 #
  def new
    @user  = User.new
    @user.login = params[:login]
    @user.role_id= Biorails::Record::DEFAULT_USER_ROLE
  end
 #
 # List of possible username options from LDAP server
 #
   def choices
    @value   = params[:query] || ""
     render :text =>[].to_json
  end  
  

  ##
  # create a  user based on a set of hash of attibutes in param[:user]
  #
  def create
    @user = User.new(params[:user])
    @user.set_password( params[:user][:password]) unless  params[:user][:password].empty?  
    if @user.save
    @user.memberships.create(:team_id=> Biorails::Record::DEFAULT_TEAM_ID)
    flash[:notice] = "User created."
    redirect_to :action => 'index'
    else
       render :action => 'new'
    end
  end

  def update
    @user = User.find(params[:id]) 
    if  @user.update_attributes(params[:user])
      @user.set_password( params[:user][:password]) unless  params[:user][:password].empty?  
      @user.save!
      flash[:notice] ='Profile updated.'
      redirect_to :action => 'index'
    else
      flash[:error] = "Save failed"
      render :action => 'edit'
    end
  end

end
