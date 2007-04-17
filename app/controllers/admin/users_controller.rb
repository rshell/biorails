class Admin::UsersController < ApplicationController
##
#  
  use_authorization :user,
                    {:actions => [:list,:show,:new,:create,:edit,:update,:desrroy],
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
    @user.save!
    @user.memberships.create(:project_id=> PUBLIC_PROJECT_ID, :role_id=> @user.role_id)
    flash[:notice] = "User created."
    redirect_to :action => 'index'
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Save failed."
    render :action => 'new'
  end

  def update
    render :update do |page|
      if @user.update_attributes(params[:user])
        page.call 'Flash.notice', 'Profile updated.'
      else
        page.call 'Flash.errors', "Save failed: #{@user.errors.full_messages.to_sentence}"
      end
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
