##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Inventory::SpecimensController < ApplicationController

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
    @specimen_pages, @specimens = paginate :specimens, :per_page => 10
  end

  def show
    @specimen = Specimen.find(params[:id])
  end

  def new
    @specimen = Specimen.new
  end

  def create
    @specimen = Specimen.new(params[:specimen])
    if @specimen.save
      flash[:notice] = 'Specimen was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @specimen = Specimen.find(params[:id])
  end

  def update
    @specimen = Specimen.find(params[:id])
    if @specimen.update_attributes(params[:specimen])
      flash[:notice] = 'Specimen was successfully updated.'
      redirect_to :action => 'show', :id => @specimen
    else
      render :action => 'edit'
    end
  end

  def destroy
    Specimen.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
