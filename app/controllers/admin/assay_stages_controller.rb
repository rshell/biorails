##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Admin::AssayStagesController < ApplicationController
  use_authorization :catalogue,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user

  def index
    list
    render :action => 'list'
  end

  def list
     @assay_stages = AssayStage.paginate(:page => params[:page])
  end

  def show
    @assay_stage = AssayStage.find(params[:id])
  end

  def new
    @assay_stage = AssayStage.new
  end

  def create
    @assay_stage = AssayStage.new(params[:assay_stage])
    if @assay_stage.save
      flash[:notice] = 'AssayStage was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @assay_stage = AssayStage.find(params[:id])
  end

  def update
    @assay_stage = AssayStage.find(params[:id])
    if @assay_stage.update_attributes(params[:assay_stage])
      flash[:notice] = 'AssayStage was successfully updated.'
      redirect_to :action => 'show', :id => @assay_stage
    else
      render :action => 'edit'
    end
  end

  def destroy
    AssayStage.find(params[:id]).destroy
    redirect_to :action => 'list'
  end


      
end
