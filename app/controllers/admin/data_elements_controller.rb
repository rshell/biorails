##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class Admin::DataElementsController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'

#
# default action is list
#
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :update ],
         :redirect_to => { :action => :list }

#
# List all the data_elements
#
  def list
    data_system = DataSystem.find(:first)
    redirect_to :controller=>'data_systems',:action => 'show', :id => data_system
  end
#
# show a selected DataElement by Id
#
  def show
    @data_element =DataElement.find( params[:id] )
  end

##
# Autocomplete for a data element lookup return a list of matching records.
# This is simple helper for lots of forms which want drop down lists of items
# controller from the central catalog.
# 
#  * url is in the form /data_element/choices/n with value=xxxx parameter
#
  def choices
    element =DataElement.find( params[:id] )
    text = request.raw_post || request.query_string
    @value = text.split("=")[1]
    @choices = element.like(@value)
    render :inline => "<%= auto_complete_result(@choices, 'name') %>"
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      render :partial =>'shared/messages',:locals => { :objects => ['data_element','data_value'] }
  end  
  
##
# Add a Child Data Element  
  def add
     @data_element = DataElement.find( params[:id] )
     @child = @data_element.add_child(params[:child][:name] )
     if @child.save
        flash[:notice] = 'Child Data Element was successfully created.'
        redirect_to :action => 'show', :id => @data_element
     else
       render :action => 'show'        
     end
  end
  
#
#  edit the record
#  
  def edit
    @data_element = current( DataElement, params[:id] )
  end

#
# Update a existing data element on the system
#
  def update
    @data_element = current( DataElement, params[:id] )
    if @data_element.update_attributes(params[:data_element])
      flash[:notice] = 'DataElement was successfully updated.'
      redirect_to :action => 'show', :id => @data_element
    else
      render :action => 'edit'
    end
  end

 #
 # Remove a existing data element from the system
 #
  def destroy
    item = current( DataElement, params[:id] )
    data_system = item.data_system
    puts item.name
    puts 'distroy'+ item.destroy
    
    redirect_to :controller=>'data_systems', :action => 'show',:id=> data_system
  end
  
#
#  export Report of Elements as CVS
#  
def export
    @items = DataElement.find(:all)
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |csv|
      csv << %w(id, context, name, description)
      @items.each do |item|
        csv << [item.id, item.data_concept.name, item.name, item.description]
      end
    end

    report.rewind
    send_data(report.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => 'report.csv')
  end  
    
end
