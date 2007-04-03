##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

#
# This describes a data enviroment the system is linked to. This may
# be either a collection of web service methods or a database schema. 
#
#
class Admin::DataSystemsController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

#
# List of all available data environmenjts
  def list
    @data_system_pages, @data_systems = paginate :data_systems, :per_page => 10
  end

#
# Show the passed data environment
  def show
    if params[:id]
       @data_system = DataSystem.find(params[:id])
    else
      index
    end
  end

#
# Create a new data environement
  def new
    @data_system = DataSystem.new
    if params[:id] 
        @data_system.data_context = DataContext.find(params[:id])
    end
  end

#
# create a new Data Environment
  def create
    @data_system = DataSystem.new(params[:data_system])
    if @data_system.save
      flash[:notice] = 'DataSystem was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

#
# edit the current Data Environment
  def edit
    @data_system = DataSystem.find(params[:id])
  end

  def update
    @data_system = DataSystem.find(params[:id])
    if @data_system.update_attributes(params[:data_system])
      flash[:notice] = 'DataSystem was successfully updated.'
      redirect_to :action => 'show', :id => @data_system
    else
      render :action => 'edit'
    end
  end

  def destroy
    DataSystem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
   
#
#  export Report of DataSystem as CVS
#  
  def export
    @items = DataSystem.find(:all)
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |csv|
      csv << %w(id, context, name, description)
      @items.each do |item|
        csv << [item.id, item.data_context.name, item.name, item.description]
      end
    end

    report.rewind
    send_data(report.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => 'report.csv')
  end  

  
end
