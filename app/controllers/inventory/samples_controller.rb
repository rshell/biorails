##
# Copyright � 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class Inventory::SamplesController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @sample_pages, @samples = paginate :samples, :per_page => 10
  end

  def show
    @sample = Sample.find(params[:id])
  end

  def new
    @sample = Sample.new
  end

  def create
    @sample = Sample.new(params[:sample])
    if @sample.save
      flash[:notice] = 'Sample was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sample = Sample.find(params[:id])
  end

  def update
    @sample = Sample.find(params[:id])
    if @sample.update_attributes(params[:sample])
      flash[:notice] = 'Sample was successfully updated.'
      redirect_to :action => 'show', :id => @sample
    else
      render :action => 'edit'
    end
  end

  def destroy
    Sample.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
