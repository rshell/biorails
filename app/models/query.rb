##
# Generic Query Handler to wrap SQL or ActiveModel for simple table generation.
# This is a wrapper around a Model to build at sortable and filtable table 
# of data to display on a a form. A Query is built from a model as follows.
# 
#   query = Query.new(QueueItem)
#   query.join('queue')
#   
#   Other linked (has_one,belongs_to) can be joined in to get extra columns to display
#   in the UI grid
#   
#   The the display columns can be customized for display
#   
#   query.column('label').label ='Reference'
#   query.column('id').show = false
# 
# Standard operations are 
# 
#   * show = true/false show this column
#   * sort =  sort order of the column 0=none 
#   * order = order the column should appear in table (allow the old drag and drop of a column)
#   * direction = asc/desc/nil
#   * sortable  = True /False 
#   * filterable = True /False 
#   * label  = visiable label for column header
#   * filter = value to match
#   * op     = filter operation (=,>,<, like etc)
#   * action = code to generate a action url
#   
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Query

  attr_accessor :dom_id
  attr_accessor :joins
  attr_accessor :model

##
# Defeult logger got tracing problesm
def logger
  ActionController::Base.logger rescue nil
end
  
##
# Default setup for query
#  
 def initialize( model)
  @columns = []
  @joins = {}
  @model = model
  @dom_id = model.table_name
  self.add_model(model)
 end

##
#get a named column
#
 def column(name)
    column = @columns.detect{|col|col.name == name}
    unless column
      column = QueryColumn.new(name, :order=>@columns.size, :class=>@model)
      column.order = column
      column.sortable = false
      column.filterible = false
      @columns << column
    end
    return column
 end

 
##
# Apply the name=value hash of filter values to the query 
# 
 def filter(params={})
    params.each do  | key,value |
        column(key).filter = value if value!="" && value!=nil
    end
 end
 
 
 def sort(sort_list)
    params = sort_list.split(",").reverse
    params.each do | item |
      sort_columns.each{|c|c.sort += 1}
      c = column( item.split(":")[0])
      c.sort = 1
      c.direction = item.split(":")[1]||'asc'
    end
 end

##
# Get the current sort key of the query
# returns a array of columns used to sort the data in order they are applied
#  
def sort_columns
   return @columns.reject{|column|column.sort < 1}.sort{|a,b| a.sort <=> b.sort}
end

##
# Get the filter columns active
def filter_columns
   return @columns.reject{|column|column.filter ==nil}
end

##
# Get a sorted list of all the columns in the query
# 
 def displayed_columns 
    return @columns.reject{|column|column.show==false}.sort{|a,b| a.order <=> b.order}
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")  
      return  @columns 
 end

##
# Get a sorted list of all the columns in the query
# 
 def columns 
    return @columns.sort{|a,b| a.order <=> b.order}
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")  
      return  @columns 
 end

##
# 
 def order
   sort = sort_columns
   return nil if sort == []
   if @joins.size>0
     return sort.collect{|column|"#{column.attribute} #{column.direction}"}.join(",")
   else
      return sort.collect{|column|"#{column.name} #{column.direction}"}.join(",")
   end 
 end


##
# Get the current conditions for the query
#  
 def conditions
   filter = filter_columns
   return nil if filter ==[]
   if @joins.size>0
     return filter.collect{|column|"#{column.attribute} #{column.op} '#{column.filter}'"}.join(" and ") 
   else
     return filter.collect{|column|"#{column.name} #{column.op} '#{column.filter}'"}.join(" and ") 
   end 
 end

 
 
##
#Execute the Query Applying all the filter and sort rules for the columns 
#
 def find( params= {})
   params = params.merge({:conditions => conditions, :order => order, :include => @joins.keys })
   return @model.find(:all, params )   
 end 

##
# Included a linked record in the query
# 
 def join(prefix, params={})
  unless @joins[prefix]
    model = params[:class] || eval(prefix.to_s.camelize)
    @joins[prefix] = model
    params[:prefix] = prefix.to_s
    params[:class] =model
    add_model(model,params)
  end 
 end

protected

##
# Base model for the the query. This builds the list of columns
# 
 def add_model(model,params={})
  params[:prefix] = model.table_name unless params[:prefix] 
  for col in  model.columns
    if model == @model
       name = col.name
       params[:label] = col.name
    else
       name = "#{params[:prefix]}.#{col.name}"
       params[:label] = "#{params[:prefix]}_#{col.name}"
    end      
    params[:attribute] = "#{model.table_name}.#{col.name}"
    params[:class] = model
    params[:order] = @columns.size        
    @columns << QueryColumn.new(name, params )
  end
 end
 
 
end

##
# Column def with extra properties for filter and sort
# 
class QueryColumn
  attr_accessor :definition
  attr_accessor :prefix
  attr_accessor :attribute
  attr_accessor :name
  attr_accessor :label
  attr_accessor :filter
  attr_accessor :order
  attr_accessor :sort
  attr_accessor :direction
  attr_accessor :show
  attr_accessor :action
  attr_accessor :op
  attr_accessor :data_element
  attr_accessor :sortable
  attr_accessor :filterible
  

##
# Defeult logger got tracing problem

  def logger
    ActionController::Base.logger rescue nil
  end

##
#Initialize
#  
  def initialize(name, params={} )
    @prefix = nil
    @name = name
    @label = name
    @show =  !(@name =~ /(lock_version|_by|_at|_id|_count)$/ ) 
    @order = 0
    @sort =  0
    @sortable = true
    @filterible = true
    @filter =  nil
    @op = "="
    @direction = "" 
    @action = nil
    self.customize(params)
  end

  def customize(params={})
    @prefix = params[:prefix] if params[:prefix]
    @attribute = params[:attribute] if params[:attribute]
    @label = params[:label] if params[:label]
    @order = params[:order]  if params[:order]
    @sort = params[:sort] if params[:sort]
    @filter =  params[:filter]  if params[:filter]
    @show = params[:show]  unless params[:show].nil?
    @op = params[:op]  if params[:op]
    @direction = params[:direction]  unless params[:direction].nil?
    @action = params[:action] unless params[:action].nil? 
    @sortable =  params[:sortable] unless  params[:sortable].nil? 
    @filterable =  params[:filterible] unless params[:filterible].nil? 
  end
   
  def sort_direction
     case @direction
     when 'asc' then 'desc'
     when 'desc' then 'asc'
     else 'asc'
     end
  end
  
  
  def action(&code)
    @action = code
  end
##
# The the value for display for the row/column. As this may be on another object
# follow the the dot separated path in the name (eg object.object.method) to the end.
# In the case of has_many relation a array of values is returned
# 
  def value(row)
    elements = column.name.split(".").reverse
    @value << values(row,elements)
    if @action 
      @action.call(row).to_s
    else
      @value.to_s
    end    
  rescue Exception => ex
      logger.debug ex.message,@name,@action
      logger.error ex.message
      logger.error ex.backtrace.join("\n")  
      return " "  
  end

  
##
# go down the tree of related objects to find the list of matchingb values. In case of 
# a has_many relationship this may lead down a whole tree.
#   
  def values(object,elements) 
    out = []
    while elements.size>0 and !object.nil? do
      object = object.send(elements.pop)        
      if object.class == Array
        for item in object
           out << table_data_elements(item, elements.clone)
        end 
        return out
      end 
     end  
     return object
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
  end
  


  def filter= (value)
    case value 
    when /^>/
       @op=">"
       @filter = value[1..10000] 
    when /^</
       self.op="<"
       @filter = value[1..10000] 
    when /%/
       @op="like"
       @filter=value
    else
       @op="="
       @filter=value
    end   
  end
  
  def filter_field
    case op
    when '=','like'
      value
    else
      op + value
    end
  end

end

