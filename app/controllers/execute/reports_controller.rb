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
  check_permissions << 'index' << 'update' << 'create' << 'destroy' << 'list'

 COLOURS = ['#40e0d0','#ffffb3','#ffe4b5','#e6f5d0','#e6e6fa','#e0ffff','#ffefdb','#dcdcdc',
               '#ffe1ff','#ffe4b5','#ffe4c4','#ffe4e1','#ffffd9','#ffffe0','#ffffe5',
               '#fffff0','#ffec8b','#ffed6f','#ffeda0','#ffefd5','#ffefdb']
  
 GRAPHIZ_STYLES = ['dot','neato','twopi','fdp']
               

##
# List of created reports
# 
#  * params[id] filter down list for a single type of model
#
 def list
   @report = Report.find_by_name("ReportList") 
   unless @report
      @report = report_list_for("ReportList",Report)
      @report.column('custom_sql').is_visible=false 
      @report.save
   end  
   @report.params[:action]='run'
   @report.params[:controller]='reports'
   @report.set_filter(params[:filter])if  params[:filter] 
   @report.add_sort(params[:sort]) if params[:sort]
   @data = @report.run
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
   @allowed_models =  SiteController.models
   @report = Report.new
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
    @report = Report.new(params[:report])
    if @report.save
      @model = eval(@report.base_model)
      @report.model = @model
      flash[:notice] = 'Report was successfully created.'
      redirect_to :action => 'edit', :id => @report
    else
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
    puts "updated report"
    map = params[:columns]
    if map
      for key in map.keys
        puts "map column #{key} report"
        column = @report.column(key)
        column.customize(map[key])
        column.save
      end
    end
    flash[:notice] = 'Report was successfully updated.'
    redirect_to :action => 'edit', :id => @report
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
    @data_pages = Paginator.new self, 1000, 100, params[:page]
    @columns = @report.displayed_columns
    @data = @report.run({:limit  =>  @data_pages.items_per_page,
                          :offset =>  @data_pages.current.offset })
 end 
 
  def destroy
    Report.find(params[:id]).destroy
    redirect_to :action => 'list'
 end
 
 
 ##
 # Alias for show
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

    @data_pages = Paginator.new self, 1000, 100, params[:page]
    @columns = @report.displayed_columns
    @data = @report.run({:limit  =>  @data_pages.items_per_page,
                          :offset =>  @data_pages.current.offset })
    render :partial=> 'shared/report_body', :locals => {:report => @report, :data =>@data } 

 end
##
# This is a simple call to visualize the model the report is based on with all its related models
# as a simple graph.
# 
# params[:id] name of the report
# params[:levels] defaults to 2 how has down the graph to go
# params[:many] defaults to 1 how has to follow has_many relationships down
# params[:style] how to space dot and draw items 
# 
# options for style :-
#  * dot  draws  directed  graphs. 
#  * neato draws undirected graphs using ‘‘spring’’ models (see Kamada and Kawai, Information  Processing  Letters  31:1,  April  1989).
#  * twopi draws graphs using a radial layout (see G. Wills, Symposium on Graph Drawing GD’97, September, 1997). 
#  * circo  draws  graphs using a circular layout (see Six and Tollis, GD ’99 and ALENEX ’99, and Kaufmann and Wiese, GD ’02.) 
#  * fdp draws undirected graphs using a ‘‘spring’’ model. It relies on a force-directed approach in the spirit of Fruchterman and Rein‐gold (cf. Software-Practice & Experience 21(11), 1991, pp. 1129-1164).
# 
#  
  def visualize
    @report = Report.find(params[:id])
    options= {}
    options[:disposition]= params[:disposition]||'inline'
    options[:type] = 'image/png'
    options[:filename] = "model_#{@report.model.to_s.tableize}.png"
    @image_file = create_model_diagram(File.join(RAILS_ROOT, "public/images"),@report.model,params)
    send_file(@image_file.to_s,options)   
  end 
  
  def uml
    @options= {}
    @options[:model]= params[:model]||'Task'
    @options[:levels]= params[:levels]||2
    @options[:many]= params[:many]||1
    @options[:style]= params[:style]||'dot'
  end

###
# Simple diagram any model
# 
# @todo rjs close security hole on eval of command line 
# 
  def diagram
    model = eval(params[:id])
    @image_file = create_model_diagram(File.join(RAILS_ROOT, "public/images"),model,params)
    puts @image_file
    send_file(@image_file.to_s,:disposition => 'inline',   :type => 'image/png')
  end 

  
##
# expand a element of the attribute tree
# 
#  * param[:id] 
#  * param[:link] 
# 
 def expand 
   @report = Report.find(params[:context])
   if params[:id]       
      @model = eval(params[:id])
      @link = params[:link]
      @current = @model
      elements =  @link.split(".")
      for element in elements
        relation = @current.reflections.find{|key,value|key.to_s == element}
        @current = eval(relation[1].class_name)
      end
      @link << "."
      @has_many = false
      render :partial => 'attribute_selector',
             :locals => {:root => @model, :link => @link, :model => @current }
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
   @data = @report.query(:limit=>3)
    
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
   @data = @report.run(:limit=>3)

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
   @data = @report.run(:limit=>3)
   
   return render(:action => 'refresh_report.rjs') if request.xhr?
   render :action=> 'edit', :id=>@report
 end
 
##
# Remove a column from the report
#  
 def remove_column
   text = request.raw_post || request.query_string

   @report = Report.find(params[:context])
   column = ReportColumn.find(params[:id])
   @successful=column.destroy
   @data = @report.run(:limit=>3)
   
   return render(:action => 'refresh_report.rjs') if request.xhr?
   render :action=> 'edit', :id=>@report
 end


protected

###
# Output model for node definition for a model for use in graphviz 
# This task the model and generates a record node with all key attributes
# listed
# 
  def dot_model(model,label,color)
    node =""
    if model and !model.abstract_class and model < ActiveRecord::Base  
      logger.info "dot_model(#{model})"
      attrs =""
      begin
        for col in model.content_columns
           col_type = col.type.to_s
           col_type << "(#{col.limit})" if col.limit
           attrs << "#{col.name} : #{col_type}"
           attrs << ", default: \\\"#{col.default}\\\"" if col.default
           attrs << "\\n"
        end
        for relation in model.reflections.values
           col_type = col.type.to_s
           attrs << "#{relation.name} "
           if relation.options[:polymorphic] 
            attrs << "[ #{relation.macro}  *polymorphic* ]" 
           else
             attrs << "[#{relation.macro} #{relation.class_name}]"
           end
           attrs << "\\n"      
        end
      rescue Exception => ex
          logger.info "problem with #{model} #{ex.message}"
         attrs << "!!! Changing !!!"
         attrs << "\\n"
      end
      node << "\t\"#{model.to_s}\""
      node << " [label=\"{#{model.to_s} [#{label}]|#{attrs}}\" "
      node << " ,style=\"filled\",fillcolor=\"#{color}\" shape=\"record\"];\n"
    else
      ""  
    end
    return node
  end
   
##
# Generate a dot and image filea for a model showing all its relationships
# If this works you get a file name back to point to the png for the model
# 
  def create_model_diagram(target_dir,root, options ={})
    return nil unless root && root < ActiveRecord::Base && !root.abstract_class
    max_levels = (options[:levels] || 2).to_i
    max_many = (options[:many] || 1).to_i
    cmd = GRAPHIZ_STYLES.detect{|cmd|cmd==options[:style]} ||GRAPHIZ_STYLES[0]

    logger.info "create_model_diagram model #{root} levels #{max_levels} manys #{max_many} draw with #{cmd}"

    img_file = File.join(target_dir,"model_#{root}_#{max_levels}_#{max_many}_#{cmd}.png")
    dot_file = File.join(target_dir, "model_#{root}_#{max_levels}_#{max_many}_#{cmd}.dot")      
    nodes = {} 
    relations =[]  
    queue = []
    nodes[root]=dot_model(root,"root",COLOURS[0])
    queue << {:model=>root,:level=>1}

    while queue.size>0
       node = queue.pop
       for relation in node[:model].reflections.values.reject {|r|r.options[:polymorphic] ||  (r.macro==:has_many and node[:level]> max_many ) }

         model = eval(relation.class_name)
         relations << "\t\"#{node[:model].to_s}\" -> \"#{model.to_s}\" "
         case relation.macro
         when :has_many
         relations << " [label=\" has many #{relation.name}\",color=\"blue\", arrowtail=\"odiamond\", arrowhead=\"crow\"] \n"        
         when :belongs_to
         relations << " [label=\" reference #{relation.name}\", arrowhead=\"normal\",  arrowtail=\"none\"] \n"        
         when :has_one
         relations << " [label=\" has one #{relation.name}]\", arrowhead=\"diamond\"] \n"        
         else
         relations << " [label=\" #{relation.macro} #{relation.name}\" ] \n"        
         end
         
         unless nodes[model] or node[:level]>=max_levels
           nodes[model] = dot_model(model,"level #{node[:level]}",COLOURS[node[:level]]) 
           queue << {:model=>model,:level=>( node[:level]+1 ) }
        end
      end
    end   

    f = File.open(dot_file, "w")    
    # Define a graph and some global settings
    f.write "digraph G {\n"
    f.write "\toverlap=false;\n \tsplines=true;\n"
    f.write "\tnode [fontname=\"Helvetica\",fontsize=7];\n"
    f.write "\tedge [fontname=\"Helvetica\",fontsize=7];\n"
    f.write "\tranksep=0.1;\n \tnodesep=0.1;\n"
    #f.write "\tedge [decorate=\"true\"];\n"

    # Write header info
    f.write "\t_schema_info [shape=\"plaintext\", label=\"\", fontname=\"Helvetica\",fontsize=8];\n"
    
    assocs = []
    # Draw the tables as boxes
    for node in nodes.values
      f.write node
    end
    # Draw the relations
    for relation in relations
      f.write relation
    end    
    # Close the graph
    f.write "}\n"
    f.close

    # neato or dot
    if system "#{cmd} -Tpng -o\"#{img_file}\" \"#{dot_file}\""
      puts "Generated #{img_file}"
      return img_file
    else
      puts "Failed to execute the '#{cmd}' command! Need grapviz (www.graphviz.org) installed and on path "
      logger.error "Failed to execute the '#{cmd}' command! Is grapviz (www.graphviz.org) installed? "
      return nil
    end
  rescue Exception => ex
      logger.error "cant generate grapviz: #{ex.message}"
      return nil    
  end

end
