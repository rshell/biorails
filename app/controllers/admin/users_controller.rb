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
  end

  ##
  # create a  user based on a set of hash of attibutes in param[:user]
  #
  def create
    @user = User.new params[:user]
    @user.set_password( params[:user][:password])
    @user.save!
    @user.memberships.create(:team_id=> Biorails::Record::DEFAULT_TEAM_ID, :role_id=> params[:project][:role_id])
    flash[:notice] = "User created."
    redirect_to :action => 'index'
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Save failed."
    render :action => 'new'
  end

  def update
    @user = User.find(params[:id]) 
    if  @user.update_attributes(params[:user])
      @user.set_password( params[:user][:password])   
      @user.save!
 
      flash[:notice] ='Profile updated.'
      redirect_to :action => 'index'
    else
      flash[:error] = "Save failed"
      render :action => 'edit'
    end

  end

  def destroy
    @user.deleted_at = Time.now.utc
    @user.save!
  end

  def enable
    @user.deleted_at = nil
    @user.save!
  end

end
