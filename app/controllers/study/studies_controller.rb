##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Study::StudiesController < ApplicationController
  
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
    if !@study
      redirect_to study_url(:action => 'list')
    end
  end 
  
##
# Configuration of a Study. This manages the setup of parameter list and 
# list of users associated with a study
#   
  def parameters
    @study = current( Study, params[:id] )
    if !@study
      redirect_to :controller =>'studies',:action => 'list'
    else       
      redirect_to :controller =>'study_parameters',:action => 'list', :id => @study.id
    end 
  end
  
##
# Standard entry point for data entry mode for studies. This will display a list of   
# 
  def protocols
    @study = current( Study, params[:id] )
    if !@study
      redirect_to :controller =>'studies',:action => 'list'
    else       
      redirect_to :controller =>'study_protocols',:action => 'list', :id => @study.id
    end
  end

##
# Output a timeline 
  def timeline
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
    @study = Study.new
  end
  
##
# response to new with details to created a study
#   
  def create
    @study = Study.new(params[:study])
    if @study.save
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
