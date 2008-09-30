# ##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights

# ## This manages the list of Parameter Types in the system. It was added to
# provide the bases for parameterized data entry. Parameters have rules on the
# type of data they accept. The key one of theses is a allow vocabary
# 
# Actions supported:-
# * list         list all items
# * new/create   create a new item
# * edit/update  edit a exiting item
# * destroy      destroy item and all its dependent objects
# 
class Admin::ParameterTypesController < ApplicationController

  use_authorization :catalogue, 
              :actions => [:list,:show,:new,:create,:edit,:update,:destroy], 
              :rights => :current_user
 
  before_filter :setup_parameter_type ,  :only => [ :show, :edit, :update,:destroy,:add]

  def index
    list
    render :action => 'list'
  end

  # 
  # List of parameter types
  # 
  def list
    @parameter_types = ParameterType.paginate(:page => params[:page],:order=>'name')
  end

  # 
  # Show the current parameter type and associated collections
  #  * aliases : Names for the parameter type
  #  * usages : Assay Parameters linked to this type
  # 
  def show
    @parameter_type_alias = ParameterTypeAlias.new(:name =>@parameter_type.name,:description=>@parameter_type.description)
    @parameter_type_alias.parameter_type= @parameter_type    
  end
  # 
  # New Parameter Type form, basically a simple name,description dialog
  # 
  def new
    @parameter_type = ParameterType.new
    @parameter_type.data_type_id = 2
    @parameter_type.storage_unit = ""
  end
  # 
  # Create a parameter type based on data returned from form.
  # 
  def create
    @parameter_type = ParameterType.new(params[:parameter_type])
    if @parameter_type.save
      flash[:notice] = 'ParameterType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  # 
  # Parameter type in form in edit mode
  # 
  def edit
  end
  # 
  # update parameter type based on post from form
  # 
  def update
    if @parameter_type.update_attributes(params[:parameter_type])
      flash[:notice] = 'ParameterType was successfully updated.'
      redirect_to :action => 'show', :id => @parameter_type
    else
      render :action => 'edit'
    end
  end
  # 
  # destroy a parameter if not used?
  # 
  def destroy
    unless @parameter_type.used?
      @parameter_type.destroy
      flash[:notice]="#{@parameter_type.name } has been successfully deleted"
      redirect_to :action=>'list'
    else
      flash[:error]="#{@parameter_type.name } is in use so cant be deleted"
      redirect_to :action=>'show', :id=>@parameter_type.id
    end
  end
  #
  # add a alias to a parameter type
  #
  def add
    @parameter_type_alias = ParameterTypeAlias.new(params[:parameter_type_alias])
    @parameter_type.aliases << @parameter_type_alias    
    if @parameter_type_alias.save
      redirect_to :action=>'show', :id=>@parameter_type.id  
    else       
      @parameter_type.reload
      flash[:error]="#{@parameter_type.name } cant add alias"
      render :action=>'show'
    end
  end
  #
  # remove a alias
  #
  def remove
    @parameter_type_alias = ParameterTypeAlias.find(params[:id])
    @parameter_type = @parameter_type_alias.parameter_type
    @parameter_type_alias.destroy
    redirect_to :action=>'show', :id=>@parameter_type.id    
  end
  
  protected 

  def setup_parameter_type
    @parameter_type = ParameterType.find(params[:id])    
  end

end
