# == Report Controller (Project)
#
# This is a generic report builder and runner for [http://biorails.org] it provides the ability to
# generate a ActiveRecord style find query with included linked objects for the bases of the report.
#
# This query is saved in Report and ReportColumn to create a reusable report defintion which can be
# reused. Generally one instance of a object appears on one row of results. The reports generator
# usage relationships in the Active Record Models (has_many and belongs_to) to allow the selection og
# fields from user models.
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
#
class Execute::ReportsController <  Admin::ReportsController

  PROJECT_REPORT_MODELS = [
    Experiment,Task,TaskContext,TaskResult,TaskValue,TaskText,TaskReference,
    Project,ProjectElement,ProjectAsset,
    Request,RequestService,QueueItem,QueueResult,
    AssayStatistics,ProcessStatistics,ExperimentStatistics,TaskStatistics,
    Assay,AssayParameter,AssayProtocol,AssayProcess,AssayWorkflow,
    ProcessInstance,ProcessFlow,ProcessStep,Parameter]

  use_authorization :reports,
    :build => [:new,:create,:edit,:update,:destroy],
    :use => [:list,:show]

  before_filter :setup_list,
    :only => [ :new,:list,:index,:create]

  before_filter :setup_record,
    :only => [ :show, :edit, :copy, :update,:destroy,:export,
               :print,:grid,:snapshot,:visualize,:columns]

  ##
  # Generate new report for a model
  #
  #  * params[:id] optional name of the model to use as basis of report
  #
  def new
    @models = PROJECT_REPORT_MODELS
    @report = ProjectReport.new(:name=> Identifier.next_id(Report), :project_id=>current_project.id, :style=>'Report')
    @report.model = TaskResult
    respond_to do |format|
      format.html { render :action=>'new'}
      format.xml  { render :xml => @report.to_xml(:include=>[:model,:columns])}
    end
  end

  ##
  #Create a new report and if this work jump to report editor to add custom columns
  #
  # * params[:report] for the map of properties of the Report object to create
  #
  def create
    @models = Biorails::UmlModel.models
    @report = ProjectReport.new(params[:report])
    if @report.save
      set_project @report.project if @report.project
      redirect_to :action => 'edit', :id => @report
    else
      @report.errors.full_messages().uniq.each {|e| logger.info "Report #{e.to_s}"}
      render :action => 'new'
    end
  end

protected


  def setup_list
    set_project(Project.find( params[:id] )) if  params[:id]
    @report = Biorails::ReportLibrary.report_list do | report |
      report.column('project_id').customize(:filter => current_project.id, :is_visible => false)
    end
    set_element(Project.current.folder(ProjectReport.root_folder_under))
  rescue Exception => ex
    logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
    return show_access_denied
  end

  def setup_record
    @report = Report.find(params[:id])
    if @report and @report.project and @report.project_element
         set_element(@report.project_element)
         set_project(@report.project)
    end
    return true
  rescue Exception => ex
      logger.warn flash[:warning]= "Exception in #{self.class}: #{ex.message}"
      return show_access_denied
  end

end
