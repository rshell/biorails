##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
# This class deals with the logical structure of data in the system.
# It implements classic univerial entities, attibutes+relationships 
# meta data model.
# 
#  Please remember this model is defined for a high level catalogue 
#  for generation of lookup lists in the application. Its not for 
#  storage of all the data in system.
# 
# Actions supported:-
# * list         all contexts
# * show         one context and its root concepts
# * new/create   create a context
# * edit/update  edit a context
# * destroy      destroy context and all its concepts+systems+elements
# * export       export all context/concept tree as CVS
# 
class Admin::DataContextsController < ApplicationController
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

#
# List the top level list of contextual frameworks in the Dictionaries
#
  def list
   @report = Report.find_by_name("DataContextList") 
   unless @report
      @report = report_list_for("DataContextList",DataContext)
      @report.save
   end  
   @report.set_filter(params[:filter])if params[:filter] 
   @report.add_sort(params[:sort]) if params[:sort]

   @data_pages = Paginator.new self, 1000, 20, params[:page]
   @data = @report.run({:limit  =>  @data_pages.items_per_page,
                        :offset =>  @data_pages.current.offset })
  end
#
# Show current context form
# 
  def show
    @data_context = DataContext.find(params[:id])
  end

#
# new context form
# 
  def new
    @data_context = DataContext.new
  end

#
# Create a data context 
#
  def create
    @data_context = DataContext.new(params[:data_context])
    if @data_context.save
      flash[:notice] = 'DataContext was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

#
# Edit a data context
#
  def edit
    @data_context = DataContext.find(params[:id])
  end
#
# Update a existing data context with new values
# 
  def update
    @data_context = DataContext.find(params[:id])
    if @data_context.update_attributes(params[:data_context])
      flash[:notice] = 'DataContext was successfully updated.'
      redirect_to :action => 'show', :id => @data_context
    else
      render :action => 'edit'
    end
  end
#
# destroy a data context
#
  def destroy
    DataContext.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

#
#  export Report of Concepts as CVS
#  
def export
    @items = DataConcept.find(:all)
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
