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
# * list         all concepts in tree
# * show         one concept and its child concepts,elements and parameter type usages
# * new/create   create a concepts
# * edit/update  edit a concepts
# * add/added    add a element implementing a concept
# * destroy      destroy concept and all its concepts+elements
# * export       export all concept tree as CVS
# 
class Admin::CatalogueController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :update,:added ],
         :redirect_to => { :action => :list }
         
##
# List the Concepts in the the current context
# 
def list
  @context = DataContext.find(:first)
  if params[:id]
    @data_concept = DataConcept.find(params[:id])
  else
    @data_concept = @context
  end
end


def tree
  @context = DataContext.find(:first)
  render :action=>'tree',:layout=>false
end

##
# Show details of the the current concept. This is now a usages ajax to update the 
# current-% panels on the client with correct information for the current concept
# 
def show 
   @data_concept = DataConcept.find(params[:id])
   @context = @data_concept.context
   return render(:action => 'show.rjs') if request.xhr?
   render :action => 'show'
end

##
# Create a new concept this updates the current-children panel to be a data entry form for the 
# entry of a new concept under the current one.
# 
def new
    @parent = DataConcept.find(params[:id])
    @context = @parent.context
    @data_concept = DataConcept.new
    @data_concept.parent = @parent
    @data_concept.context = @context
    return render(:action => 'new_concept.rjs') if request.xhr?
    render(:partial => 'new_concept')
end

#
# Create a new  concept for the current concept. Afterwards does a full 
# redirect to redo whole forms as tree and detail panels have changed.
#
  def create
    @parent = DataConcept.find(params[:id])
    @data_concept = DataConcept.new(params[:data_concept]) 
    @data_concept.parent = @parent
    @parent.children <<@data_concept
    @current_tab = 0
    if @data_concept.save
      flash[:notice] = 'DataConcept was successfully created.'
      return render(:action => 'show.rjs') if request.xhr?
      redirect_to :action => 'list', :id => @data_concept.parent
    else
       return render(:action => 'new_concept.rjs') if request.xhr?
       render(:partial => 'new_concept')
    end
end

##
# Edit a Concept.
# 
def edit
    @data_concept = DataConcept.find(params[:id])
   return render( :action => 'edit_concept.rjs' ) if request.xhr?
   render(:partial => 'edit_concept')
end

##
#Update the current data concept with values from the form
def update
    @data_concept = DataConcept.find(params[:id])
    if @data_concept.update_attributes(params[:data_concept])
      flash[:notice] = 'DataConcept was successfully updated.'
    end
    redirect_to :action => 'list', :id => @data_concept
end

##
# Put up Ajax from for a new Element
def new_element
    @data_concept = DataConcept.find(params[:id])    
    @data_element = DataElement.new
    @data_element.style=='list'
    @data_element.concept = @data_concept
    @data_element.parent = nil
#   return render(:action => 'concept.rjs') if request.xhr?
   return render( :action => 'new_element')   if request.xhr?
   render( :partial => 'new_element')
end

##
# Create a new DataElement for the concept to link in a list of real entities into the catalogue
#
def create_element 
    @data_concept = DataConcept.find(params[:id])
    @data_element = DataElement.create(params[:data_element],params[:content]) 
    @data_element.concept = @data_concept
    @data_system =  @data_element.system
  
    @data_element.estimated_count = @data_element.values.size
    @current_tab =1
    if @data_element.save
      flash[:notice] = 'DataElement was successfully created.'
      return render(:action => 'show.rjs') if request.xhr?
      redirect_to :action => 'list', :id => @data_element.concept
    else
      flash[:warning] = 'DataElement failed  to save.'
      return render( :action => 'new_element')   if request.xhr?
      render( :partial => 'new_element')
    end
   rescue Exception => ex
      flash[:error] = 'DataElement has problems:'+ ex.message
      logger.error flash[:error]
      logger.error ex.backtrace.join("\n")
      redirect_to :action => 'list', :id => @data_element.concept
end


def new_usage
    @data_concept = DataConcept.find(params[:id])    
    @parameter_type = ParameterType.new
    @parameter_type.data_concept = @data_concept
    @parameter_type.data_type_id=5
    return render( :action => 'new_parameter_type')  if request.xhr?
    render( :partial => 'new_parameter_type')
end

def create_usage
    @data_concept = DataConcept.find(params[:id])
    @parameter_type = ParameterType.new(params[:parameter_type])     
    @current_tab =2
    if @parameter_type.save
      flash[:notice] = 'ParameterType was successfully created.'
      return render(:action => 'show.rjs') if request.xhr?
      redirect_to :action => 'list', :id => @data_concept
    else
      flash[:warning] = 'ParameterType failed  to save.'
      redirect_to :action => 'list', :id => @data_concept
    end
   rescue Exception => ex
      flash[:error] = 'ParameterType has problems:'+ ex.message
      logger.error flash[:error]
      logger.error ex.backtrace.join("\n")
      redirect_to :action => 'list', :id => @data_concept
end


##
# remove data element from catalog
# 
def remove_element
    @data_element = DataElement.find(params[:id])    
    @data_concept = @data_element.concept
    @data_element.destroy
    
    return render( :action => 'show',:id => @data_concept)  if request.xhr?
    redirect_to :action => 'list',:id => @data_concept
  end

 #
 # Remove a existing data concept from the system
 #
 def destroy
    @data_concept = DataConcept.find(params[:id])    
    @parent = @data_concept.parent
    @data_concept.destroy
    redirect_to :action => 'list',:id => @parent
  end
  

end
