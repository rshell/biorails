# This manages the creation of Roles
#
# @TODO needs to be be rewritten now goldberg is removed

class Admin::RolesController < ApplicationController

  use_authorization :users,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end

  def list
    @user_roles = UserRole.find(:all,:order => 'name')
    @project_roles = ProjectRole.find(:all,:order => 'name')
  end

  def show
    @role = Role.find(params[:id])
  end

  def new
    @role = Role.new(:name=> Identifier.next_id(Role))
  end

  def create
    if params[:role_type]=='UserRole'
    @role = UserRole.new(params[:role])
    else
    @role = ProjectRole.new(params[:role])
    end
    if @role.save
      flash[:notice] = 'Role was successfully created.'
      redirect_to :action => 'edit',:id=>@role.id
    else
      render :action => 'new'
    end
  end

  def edit
    @role = Role.find(params[:id])

  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])    
          @role.reset_rights(params[:allowed])
          
          flash[:notice] = 'Role was successfully updated.'
          redirect_to :action => 'show', :id => @role.id
    else
         render :action => 'edit'
    end
  end

  def destroy
    Role.find(params[:id]).destroy
    redirect_to :action => 'list'
  end


    
end
