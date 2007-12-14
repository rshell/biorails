##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Inventory::ContainersController < ApplicationController

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
    @containers = Container.paginate :order=>'name', :page => params[:page]
  end

  def show
    @container = Container.find(params[:id])
  end

  def new
    @container = Container.new
  end

  def create
    @container = Container.new(params[:container])
    if @container.save
      flash[:notice] = 'Container was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @container = Container.find(params[:id])
  end

  def update
    @container = Container.find(params[:id])
    if @container.update_attributes(params[:container])
      flash[:notice] = 'Container was successfully updated.'
      redirect_to :action => 'show', :id => @container
    else
      render :action => 'edit'
    end
  end

  def destroy
    Container.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
