##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights

#
# This manages the list of Parameter Roles in the system. It was added to provide
# the bases for parameterized data entry. Parameters have rules on the role of data
# they accept. The key one of theses is a allow vocabary
# 
# Actions supported:-
# * list         list all items
# * new/create   create a new item
# * edit/update  edit a exiting item
# * destroy      destroy item and all its dependent objects
# 
class Admin::ParameterRolesController < ApplicationController

  use_authorization :catalogue,
              :use => [:list,:show],
              :admin => [:new,:create,:destroy,:edit,:index,:update]
 
  def index
    list
    render :action => 'list'
  end

  def list
     @parameter_roles = ParameterRole.paginate(:page => params[:page])
  end

  def show
    @parameter_role = ParameterRole.find(params[:id])
  end

  def new
    @parameter_role = ParameterRole.new
  end

  def create
    @parameter_role = ParameterRole.new(params[:parameter_role])
    if @parameter_role.save
      flash[:notice] = 'ParameterRole was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @parameter_role = ParameterRole.find(params[:id])
  end

  def update
    @parameter_role = ParameterRole.find(params[:id])
    if @parameter_role.update_attributes(params[:parameter_role])
      flash[:notice] = 'ParameterRole was successfully updated.'
      redirect_to :action => 'show', :id => @parameter_role
    else
      render :action => 'edit'
    end
  end

  def destroy
    ParameterRole.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

end
