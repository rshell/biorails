##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Admin::DataTypesController < ApplicationController
  
  use_authorization :dba,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user
                     

  in_place_edit_for :data_type, :name
  in_place_edit_for :data_type, :description

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @data_type_pages, @data_types = paginate :data_types, :per_page => 30
  end

  def show
    @data_type = DataType.find(params[:id])
  end

  def new
    @data_type = DataType.new
  end

  def create
    @data_type = DataType.new(params[:data_types])
    if @data_type.save
      flash[:notice] = 'DataType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @data_type = DataType.find(params[:id])
  end

  def update
    @data_type = DataType.find(params[:id])
    if @data_type.update_attributes(params[:data_types])
      flash[:notice] = 'DataType was successfully updated.'
      redirect_to :action => 'show', :id => @data_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    DataType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

end
