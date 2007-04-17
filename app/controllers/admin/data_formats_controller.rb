##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Admin::DataFormatsController < ApplicationController
  
  use_authorization :catalogue,
                    :actions => [:list,:show,:new,:create,:edit,:update,:desrroy],
                    :rights => :current_user
                     
  in_place_edit_for :data_format, :name
  in_place_edit_for :data_format, :description

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @data_format_pages, @data_formats = paginate :data_formats, :per_page => 30
  end

  def show
    @data_format = DataFormat.find(params[:id])
  end

  def new
    @data_format = DataFormat.new
  end

  def create
    @data_format = DataFormat.new(params[:data_formats])
    if @data_format.save
      flash[:notice] = 'DataFormat was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @data_format = DataFormat.find(params[:id])
  end

  def update
    @data_format = DataFormat.find(params[:id])
    if @data_format.update_attributes(params[:data_formats])
      flash[:notice] = 'DataFormat was successfully updated.'
      redirect_to :action => 'show', :id => @data_format
    else
      render :action => 'edit'
    end
  end

  def destroy
    DataFormat.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
