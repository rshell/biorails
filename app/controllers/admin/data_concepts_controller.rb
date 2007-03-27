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
# * list         all root concepts
# * show         one concept and its child concepts
# * new/create   create a concepts
# * edit/update  edit a concepts
# * destroy      destroy concept and all its concepts+elements
# * export       export all concept tree as CVS
# 
class Admin::DataConceptsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    
    @data_concept_pages, @data_concepts = paginate(:data_concepts, 
                            :conditions => ['parent_id is null'], 
                            :order         => 'name ASC', 
                            :per_page     => 20)
  end

#
# Show a Data Concept with its related Children 
#
  def show
    @data_concept = DataConcept.find(params[:id])
  end

#
# Create a new data concept
#
  def new    
    @data_concept = DataConcept.new
    if params[:data_context]
       @data_context = DataContext.find(params[:data_context])
       @data_concept.data_context = @data_context
    end
    if params[:id]
       @concept = DataConcept.find(params[:id])
       @data_concept.parent = @concept
       @data_concept.data_context = @concept.data_context
    end
  end

#
# Create a new root concept for the current context
#
  def create
    @data_concept = DataConcept.new(params[:data_concept]) 
    puts @data_concept     
    if params[:data_concept][:parent_id]
      @parent = DataConcept.find(params[:data_concept][:parent_id])
      @parent.children <<@data_concept
      puts @parent
    end

    if @data_concept.save
      flash[:notice] = 'DataConcept was successfully created.'
      if @data_concept.parent
        redirect_to :action => 'show', :id => @data_concept.parent
      else
        redirect_to :controller=> 'data_contexts', :action => 'show', :id => @data_concept.data_context
      end
    else
      render :action => 'new'
    end

end

#
# Edit a concept
#
   def edit
    @data_concept = DataConcept.find(params[:id])
  end

#
# Update a existing data concept on the system
#
def update
    @data_concept = DataConcept.find(params[:id])
    if @data_concept.update_attributes(params[:data_concept])
      flash[:notice] = 'DataConcept was successfully updated.'
      redirect_to :action => 'show', :id => @data_concept
    else
      render :action => 'edit'
    end
  end

 #
 # Remove a existing data concept from the system
 #
 def destroy
    DataConcept.find(params[:id]).destroy
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
