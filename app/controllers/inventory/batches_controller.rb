##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class Inventory::BatchesController < ApplicationController

  use_authorization :inventory,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights =>  :current_user  

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @batch_pages, @batches = paginate :batches, :per_page => 10
  end

  def show
    @batch = Batch.find(params[:id])
  end

  def new
    @batch = Batch.new
  end

  def create
    @batch = Batch.new(params[:batch])
    name = params[:compound][:name]
    @compound = Compound.find_by_name(name)
    @compound.batches << @batch
    if @batch.save
      flash[:notice] = 'Batch was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @batch = Batch.find(params[:id])
  end

  def update
    @batch = Batch.find(params[:id])
    if @batch.update_attributes(params[:batch])
      flash[:notice] = 'Batch was successfully updated.'
      redirect_to :action => 'show', :id => @batch
    else
      render :action => 'edit'
    end
  end


  def auto_complete_for_compound_name
    text = params[:compound][:name]
    @compounds = Compound.find(:all, :limit => 12, :conditions => ['name like ?', text + '%'])
    render :action => 'autocomplete',:layout => false
  end

  def destroy
    Batch.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
