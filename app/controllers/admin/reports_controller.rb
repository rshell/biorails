# == Report Controller (Internal)
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
class Admin::ReportsController < ApplicationController

  use_authorization :system,
    :build => [:new,:create,:edit,:update,:destroy,:import,:export,:export_def,:import_file],
    :use => [:list,:show]

  before_filter :setup_list,
    :only => [ :new,:list,:index,:create]

  before_filter :setup_record,
    :only => [ :show, :edit, :copy, :update,:destroy,:export,:export_def,
    :print,:grid,:snapshot,:visualize,:columns]

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
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report,:show=>'show', :edit=>'edit' } }
      format.json { render :json => @report.grid.to_json}
      format.xml  { render :xml => @report.data.to_xml }
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
    @report.column('id').customize(:is_visible => false)
    @snapshot_name = Identifier.next_id(current_user.login)
    respond_to do | format |
      format.html { render :action => 'show' }
      format.ext  { render :partial => 'shared/report', :locals => {:report => @report } }
      format.json { render :json =>  @report.grid.to_json }
      format.xml  { render :xml => {   :rows  =>  @report.run.collect{|i|i.attributes},
          :id => @report.id,:page => params[:page] }.to_xml }
      format.js   {
        render :update do | page |
          page.replace_html @report.dom_id("show"),  :partial => 'shared/report', :locals => {:report => @report }
        end

      }
    end
  end
  ###
  # Save a Run of a report to as ProjectContent for reporting
  #
  def snapshot
    @project_folder = current_project.folder("reports").folder(@report.name)
    name = params[:name]
    name ||= Identifier.next_id(current_user.login)

    title = params[:title]
    title ||= @report.name

    @columns = @report.displayed_columns
    @data = @report.run(:page => params[:page]||1)
    @html = render_to_string(:action=>'print', :layout => false)
    @project_element = @project_folder.add_content(name, @html)
    @project_element.reference = @report
    if @project_element.save
      redirect_to folder_url( :action =>'show',:id=>@project_folder )
    else
      redirect_to system_report_url( :action =>'show',:id=>@report )
    end
  end

  def grid
    @report.add_ext_filter(params)
    render :inline => "<%= data_json(@report) %>"
  end
  ##
  # Generate new report for a model
  #
  #  * params[:id] optional name of the model to use as basis of report
  #
  def new
    @models = Biorails::UmlModel.models
    @report = SystemReport.new(:name=> Identifier.next_id(SystemReport))
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
    @report = SystemReport.new(params[:report])
    if @report.save
      redirect_to :action => 'edit', :id => @report
    else
      @models = Biorails::UmlModel.models
      render :action => 'new'
    end
  end
  ##
  #Export a protocool as a XML file
  #
  def export_def
    xml = @report.to_xml()
    send_data(xml,:type => 'text/xml; charset=iso-8859-1; header=present', :filename => @report.name+'.xml')
  end
  #
  # import form
  #
  def import
  end
  ##
  #Import a a assay xml file
  #
  def import_file
    @tab=1
    SystemReport.transaction do
      options = {:override=>{:project_id=>current_project.id,:name=>params[:name] },
        :include=>[],:ignore=>[], :create  =>[:report,:report_column]}

      options[:include] << :columns
      @report = SystemReport.from_xml(params[:file]||params['File'],options)
      unless @report.save
        flash[:error] = "Import Failed "
        return render( :action => 'import'  )
      end
    end
    session.data[:current_params]=nil
    flash[:info]= "Import Report #{@report.name}"
    redirect_to( system_report_url(:action => 'show', :id => @report))

  rescue Exception => ex
    session.data[:current_params]=nil
    logger.error "current error: #{ex.message}"
    flash[:error] = "Import Failed #{ex.message}"
    redirect_to system_report_url(:action => 'import')
  end
  ##
  # Edit a existing report
  #
  def edit
    @has_many = true
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
  #
  # Print a report
  #
  def print
    @report.add_ext_filter(params)
    @report = Report.find(params[:id])
    @data = @report.run(:page=>1,:per_page=>1000)
    respond_to do |format|
      format.html { render :action=>'print', :layout => false}
      format.pdf { render_pdf( "#{@report.name}.pdf", :action => 'print', :layout => false) }
    end
  end
  #
  # create a UML diagram for the report
  #
  def visualize
    respond_to do | format |
      format.html { render :action => 'visualize' }
      format.ext { render :partial => 'visualize' }
    end
  end
  #
  # Delete a defined report from the system
  #
  def destroy
    @report.destroy
    redirect_to :action => 'list'
  end
  ##
  # expand a element of the attribute tree
  #
  #  * param[:id]
  #  * param[:link]
  #
  def columns
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
    @report.add_ext_filter(params)
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
    @column2 = ReportColumn.find(params[:to])
    @report = @column.report
    @column.order_num = @column2.order_num
    @column2.order_num +=1
    logger.info "move_column #{@column.name} from #{@column.order_num} after #{@column2.name} #{@column2.order_num}"
    @successful=@column.save   and @column2.save
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

  protected
  #
  # List of reports
  #
  def setup_list
    @report = Biorails::SystemReportLibrary.system_report_list("System Reports")
    @internal = true
  rescue Exception => ex
    logger.error "problem in #{self.class}: #{ex.message}"
    return show_access_denied
  end
  #
  # Before filter for a single report id
  #
  def setup_record
    @internal = true
    @report = SystemReport.find(params[:id])
  rescue Exception => ex
    logger.error "problem in #{self.class}: #{ex.message}"
    return show_access_denied
  end
  
end
