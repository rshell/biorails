##
#Tree Grid is used for passing information to the user interface
# This forms a contexts x columns grid of valeus for display
# 
# The data grid can be initialized with a process (ProtocolVersion)
# or a task (Task) to populate the Grid of data. 
# 
# grid = TreeGrid(process)
# 

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
require "faster_csv"

class TreeGrid
  attr_accessor :rows
  attr_accessor :task
  attr_accessor :process
##
# Defeult logger got tracing problesm
def logger
  ActionController::Base.logger rescue nil
end
##
# Initialize grid
# 
def initialize
  rows = Array.new
  @counter = 0
  @task = nil
  @process= nil
  @rows = Array.new
end

##
# get the task id if exists otherize identify this as a new task
# 
def id
  if @task
      @task.id
  else
    'new'
  end
end

##
# Internal row number generator to help in layout of raw
# 
def next_counter
  @counter += 1
  return @counter
end
##
#Generate a Tree Grid from a Task 
# 
 def TreeGrid.from_task(task)
   return nil if task.nil?
   task = Task.find(task) if task.class == Fixnum
   task = Task.find_by_name(task) if task.class == String
   grid = TreeGrid.from_process(task.process)
   begin
      grid.task = task
      for item in task.items
        row = grid.rows[item.context.row_no.to_i]
        row.context = item.context
        cell = row.cell(item.parameter)
        unless cell
          cell = GridCell.new(row,item.parameter)
          logger.info "missing cell in row #{row.id} for #{item.id}" 
        end
        cell.item = item
        cell.value = item.value
        cell.changed = false
      end
   rescue Exception => ex
      puts ex.message
      puts ex.backtrace.join("\n")
   end   
   return grid
 end

##
#Generate a Tree Grid from a process going through all contexts
#
 def TreeGrid.from_process(process)
   return nil if process.nil?
   grid = TreeGrid.new
   begin
     grid.process = process
     for context in process.roots
       1.upto(context.default_count) do |n|    
          row = grid.append(context)
          row.label = context.label  + "[" + n.to_s + "]"
       end           
     end
   rescue Exception => ex
      puts ex.message
      puts ex.backtrace.join("\n")
   end   
   return grid
 end

##
# Appeand a context 
#
 def append(context)
   row = GridRow.new(self,context)
   row.id = @rows.size
   @rows << row
   for child in context.children
     1.upto(child.default_count) do |n|    
       child_row = append(child)
       child_row.parent = row
       child_row.label = child.label + "[" + n.to_s + "]"
     end 
   end
   return row
 end

###
# Save complete Grid as a new Task in the system
#  
 def save
   if @task
     logger.debug("Saving grid task  #{task.id}")

     TaskContext.transaction do
       for row in self.rows
          row.save if row.changed
       end
       for row in self.rows
         for cell in row.cells
           cell.save if cell.changed
         end
       end
     end
   else
     logger.error "No Task defined"
   end
  rescue Exception => ex
      logger.error "grid.save #{ex.message}"          
      logger.debug ex.backtrace.join("\n")
 end
 
##
# get a cell from the grid
# 
  def cell(row,col)
     return rows[row].cells[col]
  end

##
#All rows matching a label
#  
  def rows_by_label(label)
     rows.reject{|row|row.label != label}
  end

##
#All rows matching a passed regex for group select
#
  def rows_by_regex(label)
     rows.reject{|row|!(row.label =~ label)}
  end


##
# string value
 def to_s
     if @task 
       "grid #{@task.dom_id} #{@rows.size} rows"
     else
       "grid #{@process.dom_id} #{@rows.size} rows"
     end
  rescue Exception => ex
      logger.error "grid.to_s: #{ex.message}"          
      logger.debug ex.backtrace.join("\n")  
  end      

##
# Export a data grid to cvs report
# 
 def to_csv
    return FasterCSV.generate do |csv|
      if @task
        csv << ['url', @task.experiment.id ,'/experiments/import_file/'+@task.experiment.id.to_s] 
        csv << %w(start id name status experiment protocol study version)
        csv << ['task',@task.id, @task.name,  @task.status, 
                       @task.experiment.name, @task.protocol.name,
                       @task.experiment.study.name,  @task.process.version]
      else 
        csv << ['url', '<experiment>' ,'/experiments/import_file/<id>'] 
        csv << %w(start id name status experiment protocol study version)
        csv << %w(task  id name status experiment protocol study version)                      
      end
      definition = nil
      for row in self.rows
        unless row.definition == definition
          definition = row.definition
          csv << ['context',definition.label,'Row No.'].concat(row.names)
          csv << ['types',definition.label,''].concat(row.styles)           
        end
        csv << ['values', row.label, row.id].concat( row.values)
      end
      csv << ['end']      
    end
  rescue Exception => ex
      logger.error ex.message
      logger.debug ex.backtrace.join("\n")  
      return ex.message
 end
 
end


######################################################################################
#Row in the Grid with an array of cells and links have to definitino and parent row 
#
class GridRow
  attr_accessor :id
  attr_accessor :label
  attr_accessor :definition
  attr_accessor :context
  attr_accessor :cells
  attr_accessor :parent
  attr_accessor :grid
  attr_accessor :changed

##
# create a new now in grid with a definition
#   
  def initialize(grid,definition)
     @grid = grid
     @cells = Array.new
     @definition = definition
     @changed = false
     @label = definition.label
     for parameter in definition.parameters.sort{|a,b|a.column_no <=> b.column_no}
       cell = GridCell.new(self,parameter)
       cell.id =@cells.size
       @cells << cell
     end
  end

  def task
    self.grid.task 
  end
  
##
#Get default logger   
  def logger
    ActionController::Base.logger rescue nil
  end
 
  def dom_id(name = 'row')
    return "#{name}_#{id}"
  end
  
 
##
# generate a unique label for the row in terms of the context labels
#
  def path
     if parent == nil 
        return label 
     else 
        return parent.path+":"+label
     end 
  end 

  def parameters
     @parameters ||= cells.collect{ |item|item.parameter}
  end

##
# get a list of titles of the cells
# 
  def names
    parameters.collect{|item|item.name}
  end

##
#  Styles of cell use
#  
  def styles
    parameters.collect{|item|item.style}
  end 
  
##
# get a list of values of the cells
# 
  def values
    cells.collect{|item|item.value}
  end


##
# Return first cell matching the parameter(should be unique in a context!)
#   
  def cell(parameter)
    cells.detect{|cell|cell.parameter==parameter} 
  end

###
# Create a text context record if needed
# will create parents as needed
#   
 def save
    if @context.nil? and @grid.task
      logger.debug("rows[#{id}].save creating context ")
      
      @context = @grid.task.add_context(definition) 
      @context.row_no = id
      if @parent
        @parent.save
        @context.parent = self.parent.context
        @context.sequence_no = @context.parent.children.size 
      else 
        @context.sequence_no = @grid.task.roots.size        
      end
      @context.save 
    end
    
  rescue Exception => ex
      logger.error "failed to save row  #{self.to_s}: #{ex.message}"
      logger.debug ex.backtrace.join("\n")  
 end

###
# Simple one line string definition 
# 
   def to_s
     if @context 
       "row #{@context.dom_id} #{@definition.label}[#{@id}]=#{@label}"
     else
       "row #{@definition.label}[#{id}]=#{@label}"
     end       
   rescue Exception => ex
      logger.error "row.to_s: #{ex.message}"
      logger.debug ex.backtrace.join("\n")  
   end  

end

#############################################################################
# Cell with link to the parameter for datatype 
# 
class GridCell
   attr_accessor :parameter
   attr_accessor :item   
   attr_accessor :value
   attr_accessor :id
   attr_accessor :row
   attr_accessor :changed

##
#Get default logger   
def logger
  ActionController::Base.logger rescue nil
end

###
# initialize based on parameter and back reference to the row   
   def initialize(row, param)
      @parameter = param
      @row = row
      @value = param.default_value      
      @row.changed = @changed = param.default_value and param.default_value.to_s.length>0
   end

##
# Generate a dom_id for the cell in the format 
# name_row_col where the name is passed into the function
# 
  def dom_id(name = "cell")
       "#{name}_#{row.grid.id}_#{row.id}_#{id}"
  end

  def task
    self.row.task 
  end
  
  def name
     self.parameter.name
  end
##
#Update a cell and flag it as changed
#
  def value=(new_value)
     if @value != new_value
       @row.changed = @changed = true
       @value = new_value
     end
  end
  
  def value
    if @item
      @value = @item.to_s
    end      
    @value
  end
##
#save a test item value to database
#
 def save 
    @row.save
    if @item
      @item.value = @value 
    else
      @item = @row.context.add_task_item(self.parameter, @value)
    end  
    return @item.save
  rescue Exception => ex
      logger.error "failed to save cell #{self.to_s}: #{ex.message}"
      return false
 end

##
# Get the Regex mask for data validation of the fields data
#   
  def mask  
    if parameter.mask 
       return parameter.mask if parameter.mask[0]='/'       
       return "/"+parameter.mask+"/"
    end
    return "''"
  end 

###
# Out a simple 1 liner for the cell defnition in the format of 
#  TestItem.dom_id parameter.name [row,col] = value  
# 
   def to_s
     if @item 
       "cell #{@item.dom_id} #{parameter.name}[#{@row.id},#{@id}]=#{@value}"
     else
       "cell #{parameter.name}[#{@row.id},#{@id}]=#{@value}"
     end       
   rescue Exception => ex
      logger.error "cell.to_s: #{ex.message}"
      logger.debug ex.backtrace.join("\n")  
   end  
   
end
