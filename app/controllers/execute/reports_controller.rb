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
require "faster_csv"
require "csv"
class Execute::ReportsController < ApplicationController

  use_authorization :reports,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user
                      

 COLOURS = ['#40e0d0','#ffffb3','#ffe4b5','#e6f5d0','#e6e6fa','#e0ffff','#ffefdb','#dcdcdc',
               '#ffe1ff','#ffe4b5','#ffe4c4','#ffe4e1','#ffffd9','#ffffe0','#ffffe5',
               '#fffff0','#ffec8b','#ffed6f','#ffeda0','#ffefd5','#ffefdb']
  
 GRAPHIZ_STYLES = ['dot','neato','twopi','fdp']
               
helper :tree

##
# List of created reports
# 
#  * params[id] filter down list for a single type of model
#
 def list
   @project = current_project
   @report = Report.internal_report("ReportList",Report) do | report |
      report.column('project_id').filter_operation = "in" 
      report.column('project_id').filter_text = "( 1 , #{@project.id} )"
      report.column('project_id').is_visible = false
      report.column('name').customize(:order_num=>1)
      report.column('name').is_visible = true
      report.column('name').action = :show
      report.column('style').filter = 'Report'
      report.column('custom_sql').is_visible=false 
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   
   @data_pages = Paginator.new self, @project.reports.size, 20, params[:page]
   @data = @report.run({:limit  =>  @data_pages.items_per_page, :offset =>  @data_pages.current.offset })  
   @hash = {   :report => @report.to_ext,
               :rows  => @data.collect{|i|i.attributes},
               :id => @report.id,
               :total => @data_pages.item_count      ,
               :limit => @data_pages.items_per_page,
               :offset =>  @data_pages.current.offset }
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
    @report = Report.find(params[:id])
    
    @snapshot_name = Identifier.next_id(current_user.login)
    
    @data_pages = Paginator.new self, @report.model.count, 20, params[:page]
    @columns = @report.displayed_columns
    @data = @report.run({:limit  =>  @data_pages.items_per_page,
                          :offset =>  @data_pages.current.offset })
   @hash = {   :report => @report.to_ext,
               :rows  => @data.collect{|i|i.attributes},
               :id => @report.id,
               :total => @data_pages.item_count      ,
               :limit => @data_pages.items_per_page,
               :offset =>  @data_pages.current.offset }
    respond_to do | format |
      format.html { render :action => 'show' }
      format.json { render :json => @hash.to_json }
      format.xml  { render :xml => @hash.to_xml }
      format.js   { render :update do | page |
           page.replace_html report.dom_id("header"),  :partial => 'shared/report_header', :locals => {:report => @report, :data =>@data } 
           page.replace_html report.dom_id("body"),  :partial => 'shared/report_body', :locals => {:report => @report, :data =>@data } 
         end }
    end

 end 
 
 
 def internal
   @project = current_project
   @report = Report.internal_report("ReportList",Report) do | report |
      report.column('project_id').filter = nil
      report.column('project_id').is_visible = false
      report.column('name').customize(:order_num=>1)
      report.column('name').is_visible = true
      report.column('name').action = :show
      report.column('internal').filter = '1'
      report.column('custom_sql').is_visible=false 
      report.set_filter(params[:filter])if params[:filter] 
      report.add_sort(params[:sort]) if params[:sort]
   end
   
   @data_pages = Paginator.new self, @project.reports.size, 20, params[:page]
   @data = @report.run({:limit  =>  @data_pages.items_per_page, :offset =>  @data_pages.current.offset }) 
   respond_to do | format |
      format.html { render :action => 'list' }
      format.json { render :json => @data.to_json }
      format.xml  { render :xml => @data.to_xml }
    end
 end

##
# Open the report builder
# 
 def builder
   render :redirect => 'new', :id => params[:id] 
 end

##
# Generate new report for a model
# 
#  * params[:id] optional name of the model to use as basis of report
#  
 def new
   @models = Biorails::UmlModel.models
   @report = Report.new(:name=> Identifier.next_id(Report), :project_id=>current_project.id, :style=>'Report')
   if params[:id]    
      @report.base_model = params[:id] if @allow_models.any?{|model|model[1]==params[:id]}         
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
    @model = eval(@report.base_model)
    @report.model = @model
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
   @has_many = true
   @data = @report.run(:limit=>10)
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
   @report.update_attributes(params[:report])
    map = params[:columns]
    if map
      for key in map.keys
        column = @report.column(key)
        column.customize(map[key])
        column.save
      end
    end
    respond_to do |format|
      format.html { render :action=>'edit'}
      format.xml  { render :xml => @report.to_xml(:include=>[:model,:columns])}
      format.js  { render :update do | page |
           page.replace_html 'report-definition',  :partial => 'report_definition' 
         end
      }
    end      
 end


 def print
    @report = Report.find(params[:id])
    @data = @report.run  
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
    @project_folder  =ProjectFolder.find(params[:folder_id])
    params[:name] = Identifier.next_id(current_user.login) if params[:name].empty?
    @data = @report.run    
    @html = render_to_string(:action=>'print', :layout => false)
    @project_element = @project_folder.add_content(params[:name], params[:title],@html)
    @project_element.reference = @report
    if @project_element.save
        redirect_to folder_url( :action =>'show',:id=>@project_folder )
    else
        render :inline => @html
    end
 end

 
  def visualize
    @report = Report.find(params[:id])
  end
   
  def destroy
    Report.find(params[:id]).destroy
    redirect_to :action => 'list'
 end
 ##
 # Alias for show
 # 
 def run
   show
   render :action =>'show'
 end
##
# for for Ajax refresh after a change to the filter or sort parameters
#  
 def refresh
    @report = Report.find(params[:id])
    @report.set_filter(params[:filter])if params[:filter] 
    @report.add_sort(params[:sort]) if params[:sort]

    @data_pages = Paginator.new self, 1000, 20, params[:page]
    @columns = @report.displayed_columns
    @data = @report.run({:limit  =>  @data_pages.items_per_page,
                          :offset =>  @data_pages.current.offset })

   @hash = {   :rows  => @data.collect{|i|i.attributes},
               :id => @report.id,
               :total => @data_pages.item_count      ,
               :limit => @data_pages.items_per_page,
               :offset =>  @data_pages.current.offset }
               
    respond_to do | format |
      format.html { render :action => 'show' }
      format.json { render :json => @hash.to_json }
      format.xml  { render :xml => @hash.to_xml }
      format.js   { render :update do | page |
           page.replace_html @report.dom_id("header"),  :partial => 'shared/report_header', :locals => {:report => @report, :data =>@data } 
           page.replace_html @report.dom_id("body"),  :partial => 'shared/report_body', :locals => {:report => @report, :data =>@data } 
         end }
    end

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
      for row in @report.run
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
# Refresh the columns in the report 
#
#  * params[:id] id of the report to show
#  * params[:filter] is used as map parameter to filter {:status => 'low',:label => 'AB%'} 
#  * params[:sort] this is used to change the sort order for the columns e eg "name,label:desc"
# 
 def refresh_columns
   @report = Report.find(params[:context])
   @report.set_filter(params[:filter])if params[:filter] 
   @report.add_sort(params[:sort]) if params[:sort]
   
   @successful=true
   return render(:action => 'refresh_report.rjs') if request.xhr?
   render :action=> 'edit', :id=>@report
 end

##
# customize details for a column
# 
 def update_column   
   @report = Report.find(params[:context])
   column = ReportColumn.find(params[:id])
   column.customize(params[:column])   
   @successful=column.save

   return render(:action => 'refresh_report.rjs') if request.xhr?
   render :action=> 'edit', :id=>@report
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
   return render(:action => 'refresh_report.rjs') if request.xhr?
   render :action=> 'edit', :id=>@report
 end 
##
# add a column to the report
# 
 def add_column
   @report = Report.find(params[:id])
   text = params[:column]
   text ||= request.raw_post || request.query_string
   logger.debug "add_column #{text}"
   column = @report.column(text.split("~")[1])
   @successful=column.save

   return render(:action => 'refresh_report.rjs') if request.xhr?
   render :action=> 'edit', :id=>@report
 end
#
# Display the column layout
#
 def layout
   @report = Report.find(params[:id])  
   @items =  @report.columns.collect do |column| 
    {
      :id => column.id,
      :name => column.name,
      :label => column.label,
      :filter => column.filter,
      :is_filterable => column.is_filterible,
      :is_visible => column.is_visible, 
      :is_sortable => column.is_sortable,
      :sort_num => column.sort_num || 0,
      :sort_dir =>  column.sort_direction
    }  
   end     
   @data = {:report_id => @report.id,  :total => @items.size,:items => @items }
  
    respond_to do | format |
      format.html {  render :text => @data.to_json}
      format.json { render :json => @data.to_json }
      format.xml  { render :xml => @data.to_xml }
    end
 end
 
##
# Remove a column from the report
#  
 def remove_column
   text = request.raw_post || request.query_string

   @report = Report.find(params[:context])
   column = ReportColumn.find(params[:id])
   @successful=column.destroy

   return render(:action => 'refresh_report.rjs') if request.xhr?
   render :action=> 'edit', :id=>@report
 end

end
