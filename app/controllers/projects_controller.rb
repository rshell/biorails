# == Project Dashboard controller
# 
# This manages the creation of new projects and the main pages for a project.
# This should allow easy nagavation to current work in the project.
# 
# === Project 
#
# A project is the top level of organisation of data under each team.  
# It forms the root of a folder system and within a project assays are defined, 
# Requests are made, Documents are published.  The Project is therefore the driving 
# force behind the BioRails system.
#
# Projects in BioRails can map to a variety of real world organisational units. 
# The default are to an assay group or a laboratory or a discovery project. 
# The difference between the two is simply shown in the contents of their respective home pages, 
# with assay groups being focused around defining assays and running experiments.
#
# Projects are owned by teams.  The members of the teams carry over their team role to these projects. 
# 
# == Copyright
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ProjectsController < ApplicationController

  use_authorization :project,
    :use => [:list,:index,:show,:publish],
    :new_root => [:new_root],
    :build => [:new,:share,:edit,:create,:update,:destroy]
 
 
  before_filter :setup_project ,
    :only => [ :link,:unlink,:show, :edit, :share, :publish, :update, :destroy, :members, :calendar,:gantt,:tree,:list_signed_files]
  
  helper :calendar
  
  in_place_edit_for :project, :name
  in_place_edit_for :project, :summary
  # ## Generate a index projects the user can see
  # 
  # @return list of projects in html,xml,csv,json or as diagram page update
  # 
  # 
  def index
    @projects = Project.list(:all)
    respond_to do |format|
      format.html { render :action=>'index'}
      format.xml  { render :xml => @projects.to_xml }
      format.csv  { render :text => @projects.to_csv }
      format.json { render :json =>  @projects.to_json } 
    end
  end    

  def list
    index
  end
  
  def published
    @report = Biorails::SystemReportLibrary.internal_signed_elements_within(
             "Published within #{current_project.path}", current_project.folder)
  end
  

  # ## Generate a dashboard for the project
  # 
  def show
    respond_to do | format |
      format.html { render :template=> @project.project_type.action_template(:show)}
      format.xml {render :xml =>  @project.to_xml(:include=>[:team,:folders,:assays,:experiments,:tasks])}
      format.json  { render :text => @project.to_json }
    end

  end
  
  # 
  # Show new project form
  # 
  def new_root
    return child unless params[:id].blank?
    @project_type = ParameterType.find(params[:project_type_id]||:first)
    @project = Project.new(:project_type_id =>@project_type.id )
    @parent = nil
    @project_list = current_user.project_list
    @teams = current_user.teams
    respond_to do |format|
      format.html { render :action=> :new_root }
      format.xml  { render :xml => @project.to_xml }
      format.json  { render :text => @project.to_json }
    end
  end

  def new
    if params[:id].blank?
      @parent = current_project
    else
      @parent = Project.find(params[:id])
    end
    @project = Project.new(:project_type_id => params[:project_type_id]||:first)
    @project_list =  @parent.project_list
    @project.parent = @parent
    @project.team = @parent.team
    @teams = @parent.teams
    respond_to do |format|
      format.html { render :action=> :new }
      format.xml  { render :xml => @project.to_xml }
      format.json  { render :text => @project.to_json }
    end
  end
  # 
  # Create a new project #Create
  def create
    return new if request.get?
    begin
      Project.transaction do
        @project = current_user.create_project(params['project'])
        @parent = @project.parent
        if @project.save
          flash[:notice] = "Project was successfully created."
          set_project(@project)
          save_settings
          return redirect_to(:action => 'show', :id => @project )
        end
      end
    rescue Exception => ex
      logger.warn flash[:warning] = "Error in creating project #{ex.message}"
    end
    @project_list = current_user.project_list
    @teams = current_user.teams
    respond_to do |format|
      format.html { render :action=> :new_root }
      format.xml  { render :xml => @project.to_xml }
      format.json  { render :text => @project.to_json }
    end
  end
  # 
  # Edit the project
  # 
  def edit
    @teams = @project.teams
    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml {render :xml =>  @project.to_xml}
      format.json  { render :text => @project.to_json }
    end
  end
  #
  # Update model and change to show project
  #
  def update
    Project.transaction do
      if @project.update_attributes(params[:project])
        save_settings
        flash[:notice] = 'Project was successfully updated.'
        respond_to do |format|
          format.html { redirect_to  :action => 'show',:id => @project }
          format.xml  { head :created, :location => projects_url(@project) }
        end
      else
        @teams = @project.teams
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @projects.errors.to_xml }
        end
      end
    end
  end
    
  # ## Destroy a assay
  # 
  def destroy
   begin
    Project.transaction do
      @project.destroy
      set_project(Project.list(:first))
      set_element(nil)
    end
   rescue Exception => ex
     flash[:warning] = "Failed to destroy project #{ex.message}"
   end
    respond_to do |format|
      format.html { redirect_to home_url(:action => 'index') }
      format.xml  { head :ok }
    end
  end  
 
  #
  # Link something from another project
  #
  def link
    @model = eval(params[:object_class])
    @item = @model.find(params[:object_id])
    unless @project.add_link(@item,params)
      flash[:warning]="Not allowed to link #{@item.name} with project"
      render :action => 'show'
    else
      redirect_to project_url(:action => 'show',:id=>@project,:tab=>5)
    end
  rescue Exception => ex
      flash[:warning]="Invalid (#{ex.message}) can't create link #{params[:object_class]}.#{params[:object_id]}"
      render :action => 'show'
  end


  def unlink
    begin
      element  = ProjectElement.load(params[:project_element_id])
      if element.changeable? and right?(:data,:destroy)
        element.destroy
        flash[:info]="Have removed #{element.name} from the project"
      else
        flash[:warning]="Can not remove #{element.path} from the project"
      end
    rescue Exception => ex
      flash[:error] ="Remove failed with error: #{ex.message}"
    end
    redirect_to project_url(:action => 'show',:id=>@project,:tab=>5)
  end
  
  protected

  def save_settings
    ProjectSetting.default_settings.each do |name, options|
      ProjectSetting.set(name,params["setting_#{name}"]) if params["setting_#{name}"]
    end
  end

  def setup_project
    @tab= params[:tab]||0
    if params[:id]
      @project = Project.load(params[:id])
      if @project        
        set_project(@project)
        set_element(@project.home)  
      end
    else 
      @project = current_project  
    end
    return show_access_denied unless @project
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end
end
