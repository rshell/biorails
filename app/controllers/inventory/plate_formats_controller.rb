##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Inventory::PlateFormatsController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @plate_format_pages, @plate_formats = paginate :plate_formats, :per_page => 10
  end

  def show
    @plate_format = PlateFormat.find(params[:id])
  end

  def new
    @plate_format = PlateFormat.new
  end

  def create
    @plate_format = PlateFormat.new(params[:plate_format])
    if @plate_format.save
      flash[:notice] = 'PlateFormat was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @plate_format = PlateFormat.find(params[:id])
  end

  def update
    @plate_format = PlateFormat.find(params[:id])
    if @plate_format.update_attributes(params[:plate_format])
      flash[:notice] = 'PlateFormat was successfully updated.'
      redirect_to :action => 'show', :id => @plate_format
    else
      render :action => 'edit'
    end
  end

  def destroy
    PlateFormat.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
