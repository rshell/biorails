##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Admin::DataTypesController < ApplicationController
  
  use_authorization :system,
              :admin => [:new,:create,:destroy,:edit,:index,:list,:show,:update]

  def index
    list
    render :action => 'list'
  end

  def list
    @data_types = DataType.paginate( :page=>params[:page])
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
