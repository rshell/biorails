##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class Admin::UsersController < ApplicationController
 
##
#  
  use_authorization :users,
                    :use => [:list,:show,:new,:create,:edit,:update,:destroy]

 ##
 # List all the users on the systems. Currently not paginated 
 #
  def index
    list
    render :action=>'list'
  end
  
  def list 
    @users = User.find(:all, :order=>:name)
  end

  def ldap
    page = params[:id]||'a'     
    @users = User.ldap_users(page)
  end


  def show
    @user = current(User,params[:id])
    @ldap = User.ldap_user(@user.login) if User.respond_to?(:ldap_user)
  end

  def memberships
    @user = current(User,params[:id])
  end

  def add
    @user = current(User,params[:id])
    @team = current(Team,params[:team_id])
    return show_access_denied unless @team.owner?(User.current)
    @membership = @team.memberships.new(:user_id=>@user.id)
    if @membership.save
      flash[:notice] = 'Membership was successfully created.'
    else
      flash[:warning] = 'Failed to add membership because, ',@membership.errors.full_messages().join(',')
    end
    redirect_to :action => 'memberships',:id=>@user
  end

  def remove
    @membership =Membership.find(params[:id])
    @user = @membership.user
    @team = @membership.team
    return show_access_denied unless @team.owner?(User.current)
    if @membership.destroy
      flash[:notice] = 'Membership was removed.'
    else
      flash[:warning] = 'Failed to add membership because ',@membership.errors.full_messages().join(',')
    end
    redirect_to :action => 'memberships',:id=>@user
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
    users = User.ldap_users(@value) 
    @list = { :matches=>@value,  
              :total=>users.size, 
              :items=> users.collect {|e|  {:id => e[:uid].to_s,  :name => e[:cn].to_s}  }     }
     render :text => @list.to_json
  end  
  

  ##
  # create a  user based on a set of hash of attibutes in param[:user]
  #
  def create
    @user = User.new(params[:user])
    if @user.password.blank?
       @user.password = nil
    else
        @user.set_password(@user.password)
    end
    @user.fill_from_ldap
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
    @user.fill_from_ldap
    @user.update_attributes(params[:user])
    if @user.password.blank?
       @user.password = nil
    else
        @user.set_password(@user.password)
    end
    if @user.save
      flash[:notice] ='Profile updated.'
      redirect_to :action => 'index'
    else
      flash[:error] = "Save failed"
      render :action => 'edit'
    end
  end

end
