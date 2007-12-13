##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Organize::StudiesController < ApplicationController

  use_authorization :studies,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_project
                      
  def index
    list
  end
  
##
# Display a List of Available Studies for this user
# 
# 
  def list
   @project = current_project
   @report = Report.internal_report("StudyList",Study) do | report |
      report.column('project_id').filter = @project.id
      report.column('project_id').is_visible = false
      report.column('name').customize(:order_num=>1)
      report.column('name').is_visible = true
      report.column('name').action = :show
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   @data_pages = Paginator.new self, @project.studies.size, 20, params[:page]
   @data = @report.run({:limit  =>  @data_pages.items_per_page,
                        :offset =>  @data_pages.current.offset })
    respond_to do | format |
      format.html { render :action => 'list' }
      format.json { render :json => @data.to_json }
      format.xml  { render :xml => @data.to_xml }
    end
  end
##
# Show a overview of the current study
# 
  def show
    set_study_content
    respond_to do | format |
      format.html { render :action => 'show' }
      format.json { render :json => @study.to_json }
      format.xml  { render :xml => @study.to_xml }
    end
  end 
##
# List of experiments for the study.
#
  def experiments
    set_study_content
  end
##
# Show the summary stats for the study
#
  def metrics
    set_study_content
  end
##
# Show the services queues for the study
#
  def queues
    set_study_content
  end
##
# Configuration of a Study. This manages the setup of parameter list and 
# list of users associated with a study
#   
  def parameters
    set_study_content
  end
##
# Standard entry point for data entry mode for studies. This will display a list of   
# 
  def protocols
    set_study_content
    redirect_to protocol_url(:action => 'list',:id=>@study)
  end
##
# Calendar of stuff in the study
#
  def calendar
    set_study_content
    @calender = Schedule.calendar(Task,params)
    @calender.find_by_user(@user.id)
    respond_to do | format |
      format.html { render :action => 'calendar' }
      format.json { render :json => {:study=> @study, :items=>@calendar.items}.to_json }
      format.xml  { render :xml =>  {:study=> @study ,:items=>@calendar.items}.to_xml }
      format.js   { render :update do | page |
           page.replace_html 'center',  :partial => 'calendar' 
           page.replace_html 'right',  :partial => 'calendar_right' 
         end }
    end
  end
##
# Output a timeline 
#
  def changes
    if params[:id]
      set_study_content
      @logs = current( Study, params[:id] ).logs
    else  
      @logs = StudyLog.find(:all,:limit=>100, :order=>'id desc')
    end
  end 

##
# add reports
#   
  def reports
   set_study_content
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
    @study.started_at =Time.new
    @study.expected_at = Time.new + 3.months
  end
  
##
# response to new with details to created a study
#   
  def create
    @project = current_project
    @study = Study.new(params[:study])
    @project.studies << @study
    @study.project = current_project
    if @study.save
      @project_folder = @study.folder    
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
    set_study_content
  end

##
#manage the response to edit
#
  def update
    set_study_content
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
      set_study_content
      xml = @study.to_xml()
      send_data(xml,:type => 'text/xml; charset=iso-8859-1; header=present', :filename => @study.name+'.xml')     
    end  
 end

##
#Import a a study xml file
#
 def import 
#    set_study_content
    render :action => 'import'   
 end

STUDY_MODELS = [:study,:study_parameter,:study_queue,:study_protocol, :protocol_version,:parameter_context,:parameter]

##
#Import a a study xml file
#
 def import_file 
   Study.transaction do
      options = {:override=>{:project_id=>current_project.id,:name=>params[:name] },
                 :include=>[],:ignore=>[], :create  =>STUDY_MODELS }
           
      options[:include] << :parameters
      options[:include] << :queues if params[:study_queue] 
      options[:include] << :protocols if params[:study_protocol]
      @study = Study.from_xml(params[:file]||params['File'],options)  
      @study.project = current_project
      unless @study.save 
        flash[:error] = "Import Failed "
        return render( :action => 'import'  ) 
      end 
    end
    session.data[:current_params]=nil    
    flash[:info]= "Import Study #{@study.name}" 
    redirect_to( study_url(:action => 'show', :id => @study))

 rescue Exception => ex
    session.data[:current_params]=nil    
    logger.error "current error: #{ex.message}"
    flash[:error] = "Import Failed #{ex.message}"
    return render( :action => 'import'  ) 
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
    redirect_to :action => 'show'
  end
  
##
# cancel redirect to list
#
  def cancel
    @successful = true
    redirect_to :action => 'list'
  end

protected

  def set_study_content
    @study = current_user.study(params[:id] )
    if @study
      logger.info "set_study_content(#{@study.name})"
      @folder = @study.folder
    end
  end
    
  
  
end
