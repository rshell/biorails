##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
##
# This is a generic report builder and runner for [http://biorails.org] it provides the ability to 
# generate a ActiveRecord style find query with included linked objects for the bases of the report.
# 
# This query is saved in Report and ReportColumn to create a reusable report defintion which can be
# reused.
# 
class Execute::ReportsController < ApplicationController

  use_authorization :reports,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user
                      

 COLOURS = ['#40e0d0','#ffffb3','#ffe4b5','#e6f5d0','#e6e6fa','#e0ffff','#ffefdb','#dcdcdc',
               '#ffe1ff','#ffe4b5','#ffe4c4','#ffe4e1','#ffffd9','#ffffe0','#ffffe5',
               '#fffff0','#ffec8b','#ffed6f','#ffeda0','#ffefd5','#ffefdb'] unless defined? COLOURS
  
 GRAPHIZ_STYLES = ['dot','neato','twopi','fdp'] unless defined? GRAPHIZ_STYLES
               
  def index
    list
  end
##
# List of created reports
# 
#  * params[id] filter down list for a single type of model
#
 def list
   @project = current_project
   @internal = false
   @system_report = Report.internal_report("ReportList",Report) do | report |
      report.column('project_id').filter_operation = "in" 
      report.column('project_id').filter_text = "in ( 1 , #{@project.id} )"
      report.column('project_id').is_visible = false
      report.column('name').customize(:order_num=>1)
      report.column('name').is_visible = true
      report.column('name').action = :show
      report.column('style').filter = 'Report'
      report.column('custom_sql').is_visible=false 
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   
   @data = @system_report.run(:page => params[:page])
   @hash = {   :report => @system_report.to_ext,
               :rows  => @data.collect{|i|i.attributes},
               :id => @system_report.id,
               :page =>  params[:page]}
   respond_to do | format |
      format.html { render :action => 'list' }
      format.json { render :json => @hash.to_json }
      format.xml  { render :xml => @hash.to_xml }
    end

 end

##
# Show a report based on saved definition. This accepts further filters and sort details 
# 
#  * params[:id] id of the report to show
#  * params[:filter] is used as map parameter to filter {:status => 'low',:label => 'AB%'} 
#  * params[:sort] this is used to change the sort order for the columns e eg "name,label:desc"
# 
 def show
    @report = Report.find(params[:id]) do | report |
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
    end
    @report.column('id').customize(:is_visible => false)
    @internal = @report.internal
    
    @snapshot_name = Identifier.next_id(current_user.login)
    
    @columns = @report.displayed_columns
    @data = @report.run(:page => params[:page])
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext { render :partial => 'show' }
      format.json { render :json => {  :report => @report.to_ext, :rows  => @data.collect{|i|i.attributes},
                                       :id => @report.id,       :page => params[:page]      }.to_json }
      format.xml  { render :xml => {   :rows  => @data.collect{|i|i.attributes},:id => @report.id,:page => params[:page] }.to_xml }
      format.js   { 
         render :update do | page |
           page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report, :data =>@data } 
         end 
         
         }
    end
 end 
 
 
 def internal
   return show_access_denied unless current_user.allows?(:edit,:dba)
   @project = current_project
   @internal = true
   
   @system_report = Report.internal_report("InternalReportList",Report) do | report |
      report.column('project_id').customize(:filter => nil,:is_visible => false)
      report.column('id').customize(:filter => nil,:is_visible => false)
      report.column('name').customize(:order_num=>1, :is_visible => true, :action => :show)
      report.column('internal').customize( :filter => '1',:is_visible => false)
      report.column('custom_sql').is_visible=false 
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   
   @data = @system_report.run(:page => params[:page])
   respond_to do | format |
      format.html { render :action => 'list' }
      format.json { render :json => @data.to_json }
      format.xml  { render :xml => @data.to_xml }
    end
 end

##
# Generate new report for a model
# 
#  * params[:id] optional name of the model to use as basis of report
#  
 def new
   @models = Biorails::UmlModel.models
   @report = Report.new(:name=> Identifier.next_id(Report), :project_id=>current_project.id, :style=>'Report')
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
    @report = Report.new(params[:report])    
    @report.errors.clear
    @report.errors.full_messages().each {|e| logger.info "Report #{e.to_s}"}
    if @report.save
      redirect_to :action => 'edit', :id => @report
    else
      @report.errors.full_messages().uniq.each {|e| logger.info "Report #{e.to_s}"}
      render :action => 'new'
    end
  end
 
##
# Edit a existing report 
 def edit
   @report = Report.find(params[:id])  
   @internal = @report.internal
   @has_many = true
   @data = @report.run(:page => 1)
   respond_to do | format |
      format.html { render :action => 'edit' }
      format.ext { render :partial => 'edit' }
      format.json { render :json => @data.to_json }
      format.xml  { render :xml => @data.to_xml }
    end
 end

##
# update the record with details from form input. This uses
# 
#  * params[:id] for the lookup of the Report
#  * params[:report][] for a map of Report properties to update
#  * params[:columns][][] as 2 level map of column name then properties
#  
 def update
   @report = Report.find(params[:id])
   @internal = @report.internal
   @report.update_attributes(params[:report])
   respond_to do |format|
      format.html { redirect_to :action => 'edit', :id => @report}
      format.xml  { render :xml => @report.to_xml(:include=>[:model,:columns])}
      format.js  { render :update do | page |
           page.main_panel  :partial => 'edit' 
         end
      }
    end      
 end


 def print
    @report = Report.find(params[:id])
    @internal = @report.internal
    @data = @report.run(:page=>1,:per_page=>1000)  
    respond_to do |format|
      format.html { render :action=>'print', :layout => false}
      format.pdf { render_pdf( "#{@report.name}.pdf", :action => 'print', :layout => false) }
    end      
 end 
 
###
# Save a Run of a report to as ProjectContent for reporting
# 
 def snapshot    
    @report = Report.find(params[:id])
    @internal = @report.internal
    @project_folder  =ProjectFolder.find(params[:folder_id])
    name = params[:name]
    name ||= Identifier.next_id(current_user.login) 

    title = params[:title]
    title ||= @report.name

    @columns = @report.displayed_columns
    @data = @report.run(:page => params[:page]||1)
    @html = render_to_string(:action=>'print', :layout => false)
    @project_element = @project_folder.add_content(name, title,@html)
    @project_element.reference = @report
    if @project_element.save
        redirect_to folder_url( :action =>'show',:id=>@project_folder )
    else
        redirect_to report_url( :action =>'show',:id=>@report )
    end
 end

#
# create a UML diagram for the report
#
  def visualize
    @report = Report.find(params[:id])
    @internal = @report.internal
    respond_to do | format |
      format.html { render :action => 'visualize' }
      format.ext { render :partial => 'visualize' }
    end    
  end
#
# Delete a defined report from the system
#
  def destroy
    Report.find(params[:id]).destroy
    redirect_to :action => 'list'
 end
 ##
 # Alias for show
 # 
 def run
   show
 end 
##
# expand a element of the attribute tree
# 
#  * param[:id] 
#  * param[:link] 
#
  def columns
    @report = Report.find(params[:id])
    @model = @report.model
    @path = "" 
    if params[:node] && params[:node]!="."
      @path = params[:node] + "."   
      @path .split(".").each do |item|
         @model = eval(@model.reflections[item.to_sym].class_name)              
      end       
    end
    respond_to do | format |
      format.html { render :partial => 'tree'}
      format.json { render :partial => 'tree'}
    end
  end

 
#
#  export Report of Concepts as CVS
#  
def export
    @report = Report.find(params[:id])
    @columns = @report.displayed_columns
    output = StringIO.new
    CSV::Writer.generate(output, ',') do |csv|
      csv << @columns.collect{|col|col.label}
      for row in @report.run(:page => 1,:per_page=>1000)
        values = @columns.collect{ |column| [column.value(row)].flatten }
        max = values.collect{ |item| item.size}.max
        for item  in (0..max-1)
          csv << values.collect{ |value| value[item] }
        end 
      end
    end
    output.rewind
    send_data(output.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => "report_#{@report.name}.csv")
  end  

##
# customize details for a column
# 
 def update_column   
   @column = ReportColumn.find(params[:id])
   @report = @column.report
   @successful= @column.customize({params[:field] => params[:value]} )   
    respond_to do | format |
      format.html { render( :inline => 'ok')}
      format.json { render( :partial => @column.to_json)}
      format.xml { render( :partial => @column.to_xml)}
    end
 end

##
# add a column to the report
# 
 def move_column
   @column = ReportColumn.find(params[:id])
   @report = @column.report
   no = @column.order_num + params[:no].to_i
   logger.debug "move_column #{@column.name} from #{@column.order_num} to #{no}"
   other = @report.columns.detect{|i|i.order_num.to_s==no.to_s}
   if other 
     other.order_num = @column.order_num
     other.save
   end
   @column.order_num =no
   @successful=@column.save     
   @report.reload
   respond_to do | format |
      format.html { render :action => 'edit' }
      format.json { render :json => @report.to_json }
      format.xml  { render :xml => @report.to_xml }
      format.js { render :update do | page |
          page.main_panel(:partial => 'edit') if @successful
          page.message_panel(:partial => 'shared/messages', :locals => { :objects => [:column,:report] })
        end 
      }
  end
 end 
##
# add a column to the report
# 
 def add_column
   @report = Report.find(params[:id])
   text = params[:column]
   text ||= request.raw_post || request.query_string
   logger.debug "add_column #{text}"
   @column = @report.column(text.split("~")[1])
   @successful=@column.save
   respond_to do | format |
      format.html { render :action => 'edit' }
      format.json { render :json => @report.to_json }
      format.xml  { render :xml => @report.to_xml }
      format.js { render :update do | page |
          page.main_panel(:partial => 'edit') if @successful
          page.message_panel(:partial => 'shared/messages', :locals => { :objects => [:column,:report] })
        end 
      }
    end
 end
##
# Remove a column from the report
#  
 def remove_column
   @column = ReportColumn.find(params[:id])
   @report = @column.report
   @successful=@column.destroy
   @report.reload
   respond_to do | format |
      format.html { render :action => 'edit' }
      format.json { render :json => @report.to_json }
      format.xml  { render :xml => @report.to_xml }
      format.js { render :update do | page |
          page.main_panel(:partial => 'edit') if @successful
          page.message_panel(:partial => 'shared/messages', :locals => { :objects => [:column,:report] })
        end 
      }
    end
 end
#
#
# Display the column layout
#
 def layout
   @report = Report.find(params[:id])  
   @data = {:report_id => @report.id,  
            :total => @report.columns.size,
            :items => @report.columns.collect{ |column| column.to_ext } }
  
    respond_to do | format |
      format.html {  render :text => @data.to_json}
      format.json { render :json => @data.to_json }
      format.xml  { render :xml => @data.to_xml }
    end
 end
 


end
