# == Schema Information
# Schema version: 359
#
# Table name: reports
#
#  id                 :integer(4)      not null, primary key
#  name               :string(128)     default(""), not null
#  description        :string(1024)    default(""), not null
#  base_model         :string(255)
#  custom_sql         :string(255)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  style              :string(255)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  internal           :boolean(1)
#  project_id         :integer(4)
#  action             :string(255)
#  project_element_id :integer(4)
#

# == Description
# This is a simple SQL based report 
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class Report < ActiveRecord::Base
  acts_as_dictionary :name 
#
# Owner project
#
 acts_as_folder_linked  :project, :under =>'reports'

 belongs_to :project

##
# This record has a full audit log created for changes
#
 acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name, :scope =>"project_id",:case_sensitive=>false

  after_save :save_columns

  def save_columns
    columns.each{|i|i.save}
  end

  has_many :columns, 
           :class_name=>'ReportColumn', 
           :order=>'order_num,name', 
           :dependent => :destroy 

  attr_accessor :default_action
  attr_accessor :params
  attr_accessor :decimal_places
  attr_accessor :limit
  attr_accessor :page
  attr_accessor :start

 def initialize(*args)
   super(*args)
 end
 
 def limit
   @limit ||= 15
 end
 
 def start
   @start ||= 0
 end
 
 def page
   @page ||=1
 end
 
 def params
   @params ||= {}
 end

##
# setup defaults for sorts and filter over all the columns
#  
 def refresh(defaults)
   set_filter(defaults[:filter])if  defaults[:filter] 
   add_sort(defaults[:sort]) if defaults[:sort]
 end

#
# List all reporting containing this model name. This will search for by base_model 
# and report_columns join_model to find matches.
# 
 def self.contains_column(column)
    sql ="select r.* from reports r where exists (select 1 from report_columns c where c.report_id = r.id and c.name=?)"
    list = Report.find_by_sql([sql,"#{column}"])
    logger.debug("Reports.containing#{column})==> list of #{list.size}")
    return list
 end
#
# Get the number of elements for each column in the table as a array
# 
  def sizes(row)
     columns.reject{|c|c.join_model.nil?}.collect{|column|column.size(row)}
  end
#
# test if this has a column
#
 def has_column?(name)
    column = columns.detect{|col|col.name == name}
 end
#
#get a named column
#
 def column(name,options={})
    column = has_column?(name)
    column ||= add_column(name)
    column.customize(options) if options.size>0
    return column
 end
#
# Add a column to a report based on a dot separated path name.
# eg. experiment.assay.name this allow for the fun of trees of values
# 
 def add_column(column_name, options={})
    return nil unless column_name
    column = ReportColumn.new(:report=> self,
                              :is_filterible =>  false, 
                              :is_sortable => true,
                              :order_num=> self.columns.size,
                              :is_visible => !(column_name =~ /(lock_version|_by|_at|_id|_count)$/ ) 
     )
    column.name = column_name
    column.label = column_name.split('.').collect{|c|c.capitalize}.join(' ')
    column.is_visible =  !(column_name =~ /(lock_version|_by|_at|_id|_count)$/ ) 
    route = column_name.split(".")
    column.order_num = columns.size+1
    if route.size>1 
       logger.debug "add_column route= #{route[0]}"
       join = self.model.reflections[route[0].to_sym]
       if join
           column.join_model = route[0]
           column.join_name = join.macro.to_s
           if join.macro == :has_many
             column.is_filterible = false
             column.is_sortable = false
           end
       end         
    else
       column.join_model = nil
    end
    self.columns << column
    return column
 end
#
# Number of decimal places to display
#
 def decimal_places
   @decimal_places ||= 3
 end
##
# Create a report from a model 
# 
 def Report.for_model(model,options={})
     report = Report.new(options)
     report.project_id = Project.current.id
     report.name   = Identifier.next_id(Report)
     report.description = "new #{model.to_s} based report"
     report.base_model = model.to_s
     report.model = model
     report.save
     for col in model.content_columns
        report.add_column(col.name)
     end
     return report 
 end
#
# get the current model
# 
 def model
   @model ||= eval(base_model) if base_model
 end
 
 def model=(value)
   @model = value
   self.base_model = value.to_s
 end
#
# Apply the name=value hash of filter values to the query. This applies these the the
# named columns as a set of conbined filters on the returned data.
# As a general rule values are scanned for special characters to set the filter operation
# like %,>,< for operations like,greater then,less then.
# 
# eg. set_filter({:name => 'Fred%',:user =>'rshell'})
# 
 def set_filter(options={})
    options.each do  | key,value |
        column(key.to_s).filter = value unless value.nil? or value.size==0
    end
 end
#
# adds columns to the sort order for the columns in the report.
# Existing sorted columns are keeped as futher classification eg.
#
# add_sort('name') --> name asc
# add_sort('user desc') --> user desc,name asc
#  
 def add_sort(sort_list)
    for item in sort_list.split(",").reverse
      sort_columns.each{|c|c.sort_num += 1}
      c = column( item.split(":")[0])
      c.sort_num = 1
      c.sort_direction = item.split(":")[1]||c.next_direction
    end
 end
 
 def add_ext_filter(params)
    @start  = (params[:start] || 0).to_i
    @limit  = (params[:limit] || 15).to_i 
    @page =  1+ (@start/@limit).to_i
    sort_columns.each{|col|col.sort_num=nil}
    c = columns.detect{|col|col.id.to_s == params[:sort]}
    if c
      c.sort_num = 1
      c.sort_direction = params[:dir] || 'ASC'
    end
    unless params[:fields].blank?
      list = params[:fields].gsub(/[\[\]]/,'').split(",")
      text = params[:query]
      list.each do |item|
         c = columns.detect{|col|col.id.to_s == item.to_s}
         if c
           unless /[%,>,<,=]/ =~ text
              c.filter= "#{text}%"
           else
              c.filter= text
           end
         end
      end
   end
 end
#
# Get the current sort key of the query
# returns a array of columns used to sort the data in order they are applied
#  
def sort_columns
   return self.columns.reject{|column|column.sort_num.nil?}.sort{|a,b| a.sort_num <=> b.sort_num}
end
#
# Get a list of active filter columns in the report. Based on whether there is a filter_text
# value in column
# 
def filter_columns
   return self.columns.reject{|column|column.filter_operation.nil?}
end
#
# Get a sorted list of all the columns in the query
# 
 def displayed_columns 
    return self.columns.reject{|column|!column.is_visible}.sort{|a,b| a.order_num <=> b.order_num}
 end

def ext_default_filter
   list = self.columns.select{|column| column.is_filterible && column.is_visible && column.filter_text.blank? }
   list.collect{|column|column.id}[0]
end
#
# extjs format filter for grid
#
 def ext_non_filterable
   out = []
   n=0
   columns.collect do |rec| 
     unless rec.is_visible and rec.is_filterible
       out[n] = rec.id
       n +=1
     end
   end
   "["+out.join(",\n")+"]"
 end

 def ext_advanced_filters
   out = []
   columns.collect do |column|
     unless column.is_visible and column.is_filterible
     out << "{ type:'string',dataIndex: #{column.id} }"
     end
   end
   "["+out.join(",\n")+"]"
 end
#
# extjs formated column record
#
 def ext_columns_json
   items = [{:name=>:url}]
   columns.each{|rec| items << {:name => "#{rec.id}"} }
   items.to_json
 end
#
# extjs formated model definition for a grid
#
 def ext_model_json
   out = []
   n=0
   displayed_columns.each do |column| 
     out[n] ={ :header=> column.label,
              :tooltip => "based on #{column.name} ",
              :align=>:left,  
              :sortable=> true, 
              :dataIndex => column.id}.to_json
     n+=1         
   end
   "["+out.join(",\n")+"]"
 end
#
# output a list of model links to include in find method
# 
 def includes
   out = []
   for item in  self.columns
     unless  item.join_model.nil?
        out << item.join_model unless item.join_name=="has_many"
     end
   end
   if out.size>0
     out.uniq
   else 
     nil
   end
 end
#
# order clause for report
# 
 def order
   sort = sort_columns
   if sort == []
      return nil 
   else
      return sort.collect{|column|"#{column.table_attribute} #{column.sort_direction.to_s}"}.join(",")
   end
 end
 
##
# Get the maximum depth of nested tables 
# 
 def max_depth
   return columns.collect{|c|c.name.split(".").size}.max
 end

##
# Get the current conditions for the query
#  
 def conditions
   cond = []
   values =[]
   for column in filter_columns
     case column.filter_operation.to_s
     when 'in'
       cond << "#{column.table_attribute} #{column.filter_text}"
     else
       cond << " #{column.table_attribute} #{column.filter_operation} ? "
       values <<  column.filter_text 
     end
   end
   if cond.size==0
     return nil 
   else
     filter = []
     filter << cond.join(" and ")
     filter.concat(values)
     return filter.flatten 
   end
 end
#
#Execute the Query Applying all the filter and sort rules for the columns 
#
 def run( new_params= {:page=>1})   
   @model = self.model
   if @model
     @options = params.merge(new_params)
     @options = @options.merge({:conditions => conditions, :order => order, :include => includes })
     data = []
     if @model.respond_to?(:with_visible_data_scope)
        @model.with_visible_data_scope do
           data =@model.paginate(:all, @options )
        end
     else
        data =@model.paginate(:all, @options )
     end
     data.total_entries= @model.count({:conditions => conditions, :include => includes})
     return data
   end  
 end 


  def self.find_all_using_model(name)
    find(:all,:conditions=>[
       'base_model=? or exists (select 1 from report_columns 
         where report_columns.report_id=reports.id and report_columns.join_model=?)',name.to_s,name.to_s.downcase])
  end  

 
  def to_ext
    item = {:name => self.name,
            :id=>self.id,
            :description => self.description}
    if self.columns.size>0
       item[:columns] = self.columns.collect{|i|i.to_ext}   
    end
    yield item,self  if block_given? 
    return item
  end

  def to_xml(options = {})
    my_options = options.dup
    my_options[:include] ||= [:columns]
    my_options[:except] = [:project_id,:project_element_id] <<  my_options[:except]
    Alces::XmlSerializer.new(self, my_options  ).to_s
  end

  # ## Get Assay from xml
  #
  def self.from_xml(xml,options = {})
    my_options = options.dup
    my_options[:include] ||= [:columns]
    Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
  end

  def to_script
    puts "report = internal_report('#{name}',#{base_model}) do | report |"
    columns.each do |c|
      puts "report.column('#{c.name}', :label=>'#{c.label}',:is_filterible=>'#{c.is_filterible}',:is_visible=>'#{c.is_visible}',:filter=>'#{c.filter}')"
    end
    puts "end"
  end
 
end

