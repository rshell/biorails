##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Admin::StudyStagesController < ApplicationController
  use_authorization :catalogue,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user
 

  in_place_edit_for :study_stage, :name
  in_place_edit_for :study_stage, :description

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @study_stage_pages, @study_stages = paginate :study_stages, :per_page => 30
  end

  def show
    @study_stage = StudyStage.find(params[:id])
  end

  def new
    @study_stage = StudyStage.new
  end

  def create
    @study_stage = StudyStage.new(params[:study_stage])
    if @study_stage.save
      flash[:notice] = 'StudyStage was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @study_stage = StudyStage.find(params[:id])
  end

  def update
    @study_stage = StudyStage.find(params[:id])
    if @study_stage.update_attributes(params[:study_stage])
      flash[:notice] = 'StudyStage was successfully updated.'
      redirect_to :action => 'show', :id => @study_stage
    else
      render :action => 'edit'
    end
  end

  def destroy
    StudyStage.find(params[:id]).destroy
    redirect_to :action => 'list'
  end


      
end
