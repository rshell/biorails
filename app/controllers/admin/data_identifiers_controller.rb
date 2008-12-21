##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Admin::DataIdentifiersController < ApplicationController

  use_authorization :system,
              :admin => [:new,:create,:destroy,:edit,:index,:list,:show,:update]
  def index
    list
    render :action => 'list'
  end

  def list
     @data_identifiers =Identifier.paginate(:page => params[:page])
  end

  def show
    @data_identifier = Identifier.find(params[:id])
  end

  def new
    @data_identifier = Identifier.new
  end

  def create
    @data_identifier = Identifier.new(params[:data_identifier])
    if @data_identifier.save
      flash[:notice] = 'Data Identifier was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @data_identifier = Identifier.find(params[:id])
  end

  def update
    @data_identifier = Identifier.find(params[:id])
    if @data_identifier.update_attributes(params[:data_identifier])
      flash[:notice] = 'Data identifier was successfully updated.'
      redirect_to :action => 'show', :id => @data_identifier
    else
      render :action => 'edit'
    end
  end

  def destroy
    Identifier.find(params[:id]).destroy
    redirect_to :action => 'list'
  end


      
end
