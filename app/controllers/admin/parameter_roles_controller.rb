##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights

##
# This manages the list of Parameter Types in the system. It was added to provide
# the bases for parameterized data entry. Parameters have rules on the type of data
# they accept. The key one of theses is a allow vocabary
# 
# Actions supported:-
# * list         list all items
# * new/create   create a new item
# * edit/update  edit a exiting item
# * destroy      destroy item and all its dependent objects
# 
class Admin::ParameterRolesController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'
 

  in_place_edit_for :parameter_role, :name
  in_place_edit_for :parameter_role, :description

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @parameter_role_pages, @parameter_roles = paginate :parameter_roles, :per_page => 30
  end

  def show
    @parameter_role = ParameterRole.find(params[:id])
  end

  def new
    @parameter_role = ParameterRole.new
  end

  def create
    @parameter_role = ParameterRole.new(params[:parameter_roles])
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
    if @parameter_role.update_attributes(params[:parameter_roles])
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
