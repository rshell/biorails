##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

# This manages the creation of Roles
#

class Admin::RolesController < ApplicationController

  use_authorization :catalogue,
              :admin => [:new,:create,:destroy,:edit,:index,:list,:show,:update]

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
