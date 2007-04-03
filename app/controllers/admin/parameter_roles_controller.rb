##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights

##
# This manages the list of Parameter Types in the system. It was added to provide
# the bases for parameterized data entry. Parameters have rules on the type of data
# they accept. The key one of theses is a allow vocabary
# 
# Actions supported:-
# * list         list all items
# * new/create   create a new item
# * edit/update  edit a exiting item
# * destroy      destroy item and all its dependent objects
# 
class Admin::ParameterRolesController < ApplicationController
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'
 
  include AjaxScaffold::Controller
  
  after_filter :clear_flashes
  before_filter :update_params_filter
  
  def update_params_filter
    update_params :default_scaffold_id => "parameter_role", :default_sort => nil, :default_sort_direction => "asc"
  end
  def index
    redirect_to :action => 'list'
  end
  
  def return_to_main
    # If you have multiple scaffolds on the same view then you will want to change this to
    # to whatever controller/action shows all the views 
    # (ex: redirect_to :controller => 'AdminConsole', :action => 'index')
    redirect_to :action => 'list'
  end

  def list
  end
  
  # All posts to change scaffold level variables like sort values or page changes go through this action
  def component_update
    @show_wrapper = false # don't show the outer wrapper elements if we are just updating an existing scaffold 
    if request.xhr?
      # If this is an AJAX request then we just want to delegate to the component to rerender itself
      component
    else
      # If this is from a client without javascript we want to update the session parameters and then delegate
      # back to whatever page is displaying the scaffold, which will then rerender all scaffolds with these update parameters
      return_to_main
    end
  end

  def component  
    @show_wrapper = true if @show_wrapper.nil?
    @sort_sql = ParameterRole.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ? "#{ParameterRole.table_name}.#{ParameterRole.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @parameter_roles = paginate(:parameter_roles, :order => @sort_by, :per_page => default_per_page)
    
    render :action => "component", :layout => false
  end

  def new
    @parameter_role = ParameterRole.new
    @successful = true

    return render(:action => 'new.rjs') if request.xhr?

    # Javascript disabled fallback
    if @successful
      @options = { :action => "create" }
      render :partial => "new_edit", :layout => true
    else 
      return_to_main
    end
  end
  
  def create
    begin
      @parameter_role = ParameterRole.new(params[:parameter_role])
      @successful = @parameter_role.save
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'create.rjs') if request.xhr?
    if @successful
      return_to_main
    else
      @options = { :scaffold_id => params[:scaffold_id], :action => "create" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def edit
    begin
      @parameter_role = ParameterRole.find(params[:id])
      @successful = !@parameter_role.nil?
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'edit.rjs') if request.xhr?

    if @successful
      @options = { :scaffold_id => params[:scaffold_id], :action => "update", :id => params[:id] }
      render :partial => 'new_edit', :layout => true
    else
      return_to_main
    end    
  end

  def update
    begin
      @parameter_role = ParameterRole.find(params[:id])
      @successful = @parameter_role.update_attributes(params[:parameter_role])
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'update.rjs') if request.xhr?

    if @successful
      return_to_main
    else
      @options = { :action => "update" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def destroy
    begin
      @successful = ParameterRole.find(params[:id]).destroy
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'destroy.rjs') if request.xhr?
    
    # Javascript disabled fallback
    return_to_main
  end
  
  def cancel
    @successful = true
    
    return render(:action => 'cancel.rjs') if request.xhr?
    
    return_to_main
  end
end
