##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Study::StudiesController < ApplicationController
  use_authorization :study,
                    :actions => [:list,:show,:new,:create,:edit,:update,:desrroy],
                    :rights => :current_project
                      
  def index
    redirect_to study_url(:action => 'list')
  end
  
##
# Display a List of Available Studies for this user
# 
# 
  def list
   @report = Report.find_by_name("StudyList") 
   unless @report
      @report = report_list_for("StudyList",Study)
      @report.column('custom_sql').is_visible=false 
      @report.save
   end  
   @report.params[:controller]='studies'
   @report.params[:action]='show'
   @report.set_filter(params[:filter])if params[:filter] 
   @report.add_sort(params[:sort]) if params[:sort]

   @data_pages = Paginator.new self, 1000, 100, params[:page]
   @data = @report.run({:limit  =>  @data_pages.items_per_page,
                        :offset =>  @data_pages.current.offset })

  end

##
# Show a overview of the current study
# 
  def show
    @study = current( Study, params[:id] )
    @project_folder = current_project.folder(@study)  
    puts   @project_folder.to_yaml
    if !@study
      redirect_to study_url(:action => 'list')
    end
  end 
##
# List of experiments for the study.
#
  def experiments
    show
  end
##
# Show the summary stats for the study
#
  def metrics
    show
  end
##
# Show the services queues for the study
#
  def queues
    show
  end
##
# Show the folder linked to this study
# 
  def folder
    show
    @project_folder = current_project.folder(@study)
  end
##
# Configuration of a Study. This manages the setup of parameter list and 
# list of users associated with a study
#   
  def parameters
    show       
  end
##
# Standard entry point for data entry mode for studies. This will display a list of   
# 
  def protocols
    show       
  end


  def calender
    show       
    @calender = Schedule.calendar(Task,params)
    @calender.find_by_user(@user.id)
    render :layout => false if request.xhr?
  end


  def timeline
    show     
    
    @calender = Schedule.gnatt(Task,params)
    @calender.find_by_user(@user.id)
    render :layout => false if request.xhr?
  end


##
# Output a timeline 
  def changes
    if params[:id]
      @logs = current( Study, params[:id] ).logs
    else  
      @logs = StudyLog.find(:all,:limit=>100, :order=>'id desc')
    end
  end 

##
# add reports
#   
  def reports
   @report = Report.new      
   @report.model = Report
   @report.name = "Study Reports List"
   @report.description = "All Study Reports in the system"
   @report.column('custom_sql').is_visible=false
   column = @report.column('base_model')
   column.filter_operation = 'in'
   column.filter_text = "('Study','StudyProtocol','StudyParameter','StudyQueue')"
   column.is_filterible = false
   @report.default_action = false
   @report.set_filter(params[:filter])if  params[:filter] 
   @report.add_sort(params[:sort]) if params[:sort]
  end
#
# Generate a New Study and put up dialog for creation of study
# 
  def new
    @study = Study.new(:name=> Identifier.next_id(Study))
  end
  
##
# response to new with details to created a study
#   
  def create
    @study = Study.new(params[:study])
    if @study.save
      @project_folder = current_project.folder(@study)    
      flash[:notice] = 'Study was successfully created.'
      redirect_to :action => 'show', :id => @study.id
    else
      render :action => 'new'        
    end
  end

##
#Edit the current study 
#
  def edit
    @study = current( Study, params[:id] )
  end

##
#manage the response to edit
#
  def update
    @study = current( Study, params[:id] )
    @successful = @study.update_attributes(params[:study])
    if @study.update_attributes(params[:study])
      flash[:notice] = 'Study  was successfully updated.'
      redirect_to :action => 'show', :id => @study.id
    else
      render :action => 'edit'
    end
  end

##
#Export a protocool as a XML file
#  
 def export
    if params[:id]
      @study = current( Study, params[:id] )
      xml = Builder::XmlMarkup.new(:ident=>2)
      xml.instruct!
      @study.to_xml(xml)
      send_data(xml.target!(),:type => 'text/xml; charset=iso-8859-1; header=present', :filename => @study.name+'.xml')     
    end  
 end

##
# Destroy a study
#
  def destroy
    begin
      @successful = Study.find(params[:id]).destroy
      session[:study] = nil
      session[:experiment] = nil
      session[:task] = nil
      @study = nil
    rescue
       flash[:error] = $!.to_s
       @successful  = false
    end
    redirect_to :action => 'list'
  end
  

  def cancel
    @successful = true
    redirect_to :action => 'list'
  end
  
  
  
end
