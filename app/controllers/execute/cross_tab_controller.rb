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
class Execute::CrossTabController < ApplicationController

  use_authorization :reports,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user
                  
  before_filter :find_cross_tab , :only => [ :show, :edit, :update, :destroy,:print,:export,:snapshot, :tree, :add, :remove,:filter]

  before_filter :find_cross_tabs , :only => [ :grid,:list,:index]
  
  #
  # Get the current page of cross_tabs tables
  # 
  # GET /cross_tabs
  # GET /cross_tabs.xml
  # GET /cross_tabs.csv
  # GET /cross_tabs.json
  #
  def list
    respond_to do |format|
      format.html { render :action => 'list'}
      format.xml  { render :xml => @cross_tabs.to_xml }
      format.csv  { render :text => @cross_tabs.to_csv }
      format.json { render :json =>  cross_tabs_to_json(@cross_tabs, CrossTab.count, params[:page]), :layout=>false }  
    end
  end
  #
  # Alias to list
  #
  def index 
    return list
  end
  #
  # Show the current cross_tab value
  #
  # GET /cross_tabs/1
  # GET /cross_tabs/1.xml
  def show
    @cross_tab_columns = @cross_tab.filter(params)
    @cross_tab_results = @cross_tab.results(params[:page]||1)
    @context = @cross_tab_columns[0].parameter.context if  @cross_tab_columns[0]
    respond_to do |format|
      format.html { render :action =>'show'}
      format.ext  { render :partial => 'table' }
      format.xml  { render :xml => @cross_tab.to_xml }
      format.json { render :text => @cross_tab.to_json }
      format.js   { render :update do | page |
           page.main_panel  :partial => 'show' 
         end 
         }
    end
  end

  def print
    @cross_tab_columns = @cross_tab.columns
    @cross_tab_results = @cross_tab.results(params[:page]||1,1000)
    respond_to do |format|
      format.html { render :action=>'print', :layout => 'simple'}
      format.csv { render :text=>@cross_tab_results.to_csv}
      format.xml { render :text=>@cross_tab_results.to_xml}
      format.pdf { render_pdf( "#{@cross_tab.name}.pdf", :action => 'print', :layout => 'simple') }
    end      
 end 
 
 #
#  export Report of Concepts as CVS
#  
def export
    @cross_tab_columns = @cross_tab.columns
    @cross_tab_results = @cross_tab.results(params[:page]||1,1000)
    output = StringIO.new
    CSV::Writer.generate(output, ',') do |csv|
      csv << ["","assay"] + @cross_tab_columns.collect{|col|col.assay.name}
      csv << ["","process"] + @cross_tab_columns.collect{|col|col.process.name}
      csv << ["","parameter"] + @cross_tab_columns.collect{|col|col.name}
      csv << ["task","row"] + @cross_tab_columns.collect{|col|col.parameter.display_unit}
      for item in @cross_tab_results 
          row =[]
          row << item[-2]
          row << item[-1]
          for col in @cross_tab_columns
              row << "#{item[col.parameter_id]}"
          end
          csv << row
      end          
    end
    output.rewind
    send_data(output.read,:type => 'text/csv; charset=iso-8859-1; header=present',:filename => "crosstab_#{@cross_tab.name}.csv")
  end  
 
###
# Save a Run of a report to as ProjectContent for reporting
# 
 def snapshot    
    @cross_tab_columns = @cross_tab.columns
    @cross_tab_results = @cross_tab.results(params[:page]||1)
    @project_folder  =ProjectFolder.find(params[:folder_id])

    params[:name] = Identifier.next_id(current_user.login) if params[:name].empty?
    @html = render_to_string(:action=>'print', :layout => false)
    @project_element = @project_folder.add_content(params[:name], params[:title],@html)
    @project_element.reference = @report
    if @project_element.save
        redirect_to folder_url( :action =>'show',:id=>@project_folder )
    else
        render :inline => @html
    end
 end

  #
  # Show a new record form to be filled in
  # params[:id] primary key of the record
  #
  # GET /cross_tabs/new
  #
  def new
    @cross_tab = CrossTab.new
    respond_to do |format|
      format.html # new.rhtml
      format.xml  { render :xml => @cross_tab.to_xml }
      format.json  { render :text => @cross_tab.to_json }
     end  
   end
  #
  # Show a edit form of the current record
  # params[:id] primary key of the record
  #
  # GET /cross_tabs/1;edit
  #
  def edit
    @cross_tab_columns = @cross_tab.columns
    @cross_tab_results = @cross_tab.results(params[:page]||1)
    respond_to do |format|
      format.html # edit.rhtml
      format.xml  { render :xml => @cross_tab.to_xml }
      format.json  { render :text => @cross_tab.to_json }
    end
  end

  #
  # Create a cross_tab bassed on passed data
  # params[:cross_tab][<columns>] contain the data
  # 
  # POST /cross_tabs
  # POST /cross_tabs.xml
  def create
    @cross_tab = CrossTab.new(params[:cross_tab])

    respond_to do |format|
      if @cross_tab.save
        flash[:notice] = 'CrossTab was successfully created.'
        format.html { redirect_to cross_tab_url(:action=>:show,:id=>@cross_tab) }
        format.xml  { head :created, :location => cross_tab_url(@cross_tab) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cross_tab.errors.to_xml }
      end
    end
  end

  # PUT /cross_tabs/1
  # PUT /cross_tabs/1.xml
  def update
    @tab=3
    @cross_tab_columns = @cross_tab.filter(params)
    @cross_tab_results = @cross_tab.results(params[:page]||1)
    @successful =  @cross_tab.update_attributes(params[:cross_tab])
    respond_to do |format|
        format.html { 
              return redirect_to(:action => "edit",:id=>@cross_tab) if @successful 
              render(:action => "edit",:id=>@cross_tab)
            }
        format.xml  { render :xml => @cross_tab.errors.to_xml }
        format.js  { render :update do | page |  
            page.status_panel   :partial => 'status'
            page.main_panel     :partial => 'edit'
          end
         }
      end
  end

  # DELETE /cross_tabs/1
  # DELETE /cross_tabs/1.xml
  def destroy
    @cross_tab.destroy

    respond_to do |format|
      format.html { redirect_to cross_tab_url() }
      format.xml  { head :ok }
    end  
  end

#
# Create a Tree data model
#
  def tree
    object = CrossTab.convert_node(params[:node])
    scope = CrossTab.convert_node(params[:scope])

    @items = @cross_tab.linked_items(object,scope)    
    return render( :text => @items.collect{|i|{
                                :id=>i.dom_id,
                                :iconCls=>"icon-#{i.class.to_s.underscore}",
                                :scope => params[:node],
                                :leaf => i.is_a?(Parameter),
                                :text=>i.path(scope)}}.to_json )
  end
  #
  # Add a item to the report 
  # This allow a protocol,context of single parameter to be 
  # addded as columns to the report definition
  #
  def add
    object = from_dom_id(params[:node])
    unless @cross_tab.add_columns(object)
      logger.warn "======================================================================="
      logger.warn flash[:warning]="Failed to add Columns:- <ol><li>#{@cross_tab.errors.full_messages.join('</li><li>')}</li><ol>"
      find_cross_tab
    end
    show
  end
  #
  # Remove a column from the table
  #
  def remove
    object = @cross_tab.columns.find(params[:column])
    object.destroy if object
    respond_to do |format|
      format.html { redirect_to cross_tab_url(:action=>'show',:id=>@cross_tab) }
      format.xml  { head :created, :location => cross_tab_url(:action=>'show',:id=>@cross_tab) }
      format.js  { render :update do | page |  
          page.actions_panel  :partial => 'actions'
          page.help_panel     :partial => 'help'
          page.status_panel   :partial => 'status'
          page.main_panel     :partial => 'show'
        end
     }
    end
  end
  
protected 
 
  def find_cross_tab
    @cross_tab = CrossTab.find(params[:id])   
  end
  
#
# Get the current page of objects
# 
  def find_cross_tabs
    start = (params[:start] || 1).to_i      
    size = (params[:limit] || 25).to_i 
    sort_col = (params[:sort] || 'id')
    sort_dir = (params[:dir] || 'ASC')
    page = ((start/size).to_i)+1   
    @cross_tabs = CrossTab.find_all_by_project_id(Project.current.id,
           :limit=> size,
           :offset=> start, 
           :order=> sort_col+' '+sort_dir)
  end

end
