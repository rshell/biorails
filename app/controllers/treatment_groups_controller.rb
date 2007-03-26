##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class TreatmentGroupsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @treatment_group_pages, @treatment_groups = paginate :treatment_groups, :per_page => 10
  end

  def show
    @treatment_group = TreatmentGroup.find(params[:id])
  end

  def new
    @treatment_group = TreatmentGroup.new
  end

  def create
    @treatment_group = TreatmentGroup.new(params[:treatment_group])
    if @treatment_group.save
      flash[:notice] = 'TreatmentGroup was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @treatment_group = TreatmentGroup.find(params[:id])
  end

  def update
    @treatment_group = TreatmentGroup.find(params[:id])
    if @treatment_group.update_attributes(params[:treatment_group])
      flash[:notice] = 'TreatmentGroup was successfully updated.'
      redirect_to :action => 'show', :id => @treatment_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    TreatmentGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
