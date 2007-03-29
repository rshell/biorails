# == Schema Information
# Schema version: 123
#
# Table name: tasks
#
#  id                  :integer(11)   not null, primary key
#  name                :string(128)   default(), not null
#  description         :text          
#  experiment_id       :integer(11)   
#  protocol_version_id :integer(11)   
#  status_id           :integer(11)   
#  is_milestone        :boolean(1)    
#  assigned_to         :string(60)    
#  priority_id         :integer(11)   
#  start_date          :datetime      
#  end_date            :datetime      
#  expected_hours      :float         
#  done_hours          :float         
#  lock_version        :integer(11)   default(0), not null
#  created_by          :string(32)    default(), not null
#  created_at          :datetime      not null
#  updated_by          :string(32)    default(), not null
#  updated_at          :datetime      not null
#  study_protocol_id   :integer(11)   
#

require "faster_csv"

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
# This is a Task recording data from running of a process instance
# 
class Task < ActiveRecord::Base
  include CurrentStatus
  include  CurrentPriority
  
  attr_accessor :rows

  validates_uniqueness_of :name, :scope =>"experiment_id"
  validates_presence_of :experiment_id
  validates_presence_of :protocol_version_id
  validates_presence_of :start_date
  validates_presence_of :end_date
##
# Link to view for summary stats for study
# 
  has_many :stats, :class_name => "TaskStatistics" ,:include=>[:parameter,:role,:type]  
##
#  link to the experiment the task is created in
#   
  belongs_to :experiment
##
# Status Values for a task
# 
  belongs_to :status 
##
# Current process
#   
  belongs_to :process, :class_name =>'ProtocolVersion', :foreign_key=>'protocol_version_id'
##
# Protocol this is linked to
#
  belongs_to :protocol, :class_name =>'StudyProtocol', :foreign_key=>'study_protocol_id' 
##
# In the Process sets of parameters are grouped into a context of usages
# 
 has_many :contexts, :class_name =>'TaskContext', :dependent => :destroy, :order => 'row_no',:include => ['definition'] 

 has_many :roots, :class_name =>'TaskContext', :order => 'row_no', :conditions=>'parent_id is null'

##
# Ok links to complete sets of TaskItems associated with the Task.
# Generally for working with data a complete task is loaded into server
# memory for processing. 
 has_many :values, :class_name=>'TaskValue', :order =>'task_context_id,parameter_id',:include => ['context','parameter']

 has_many :files, :class_name=>'TaskFile', :order =>'task_context_id,parameter_id',:include => ['context','parameter']

 has_many :texts, :class_name=>'TaskText', :order =>'task_context_id,parameter_id',:include => ['context','parameter']

 has_many :references, :class_name=>'TaskReference', :order =>'task_context_id,parameter_id',:include => ['context','parameter']


 def completed_at=(value)
  self.end_date = value
 end
 
 def accepted_at=(value)
  self.start_date = value
 end
 
##
# Get summary stats to compare task with all runs in the process.
# This is basically a set of TaskStatistics with added details on
# the linked values at the process level.
# 
 def statistics
   sql = <<SQL
	select 
	  s1.task_id
     ,s1.parameter_id
	 ,s1.parameter_type_id
	 ,s1.parameter_role_id
	 ,s1.data_type_id
	 ,s1.avg_values
	 ,s1.stddev_values
	 ,s1.num_values
	 ,s1.num_unique
	 ,s1.min_values
	 ,s1.max_values
	 ,s2.avg_values avg_process
	 ,s2.stddev_values stddev_process
	 ,s2.num_values num_process
	 ,s2.min_values min_process
	 ,s2.max_values max_process
	from tasks t, task_statistics s1, process_statistics s2
	where t.id = s1.task_id
    and   t.id = ?
	and   t.protocol_version_id = s2.protocol_version_id
	and   s1.parameter_id = s2.parameter_id
SQL
   TaskStatistics.find_by_sql([sql,self.id])
 end

##
#List of reports setup to run against this task
#
 def reports
    unless @reports
         @reports= []
         @reports.concat(Report.contains_column('task.id').each{|report|
         report.column('task.id').filter = self.id})
         @reports.concat(Report.contains_column('task_id').each{|report|
         report.column('task_id').filter = self.id } )
    end
    return @reports
 end
 

 
##
# Clear current date and work done and setup for 1 day from  now
#  
  def reset
     @is_milestone = false
     @start_date = Date.new
     @end_date = Date.new + 1.day
     @expected_hours = 1
     @done_hours = 0
     refresh
  end 
##
# refresh cached items array
# 
 def refresh
   @items = nil
   @grid = nil
   items
   rows
   return @items
 end
##
# combined array of all TaskItems and cache in memory
# 
 def items
    return @items if @items
    @items = Array.new
    @items.concat(values)
    @items.concat(files)
    @items.concat(texts)
    @items.concat(references)
 end
##
#copy a existing task
# 
 def copy
   task = self.clone
   task.id = nil
   task.start_date = Time.new
   task.end_date = task.start_date + self.period
   task.done_hours = 0
   task.initial
   return task
 end
 
##
#  This created as hashed data structure of [task_context][parameter_id]
#
 def grid
    @grid ||=TreeGrid.from_task(self)
 end
##
#get the default period of time for a task
#
 def period 
   if end_date > start_date 
      end_date - start_date 
   else
      1.day
   end
 end

##
# Fraction of work done  
# 
 def done
   begin
      self.done_hours/self.expected_hours
   rescue 
     0
   end
 end
 
##
# Create a new Context
# 
 def add_context(parameter_context)
   context = TaskContext.new
   context.row_no = contexts.size
   context.definition = parameter_context
   context.is_valid = true
   context.task = self
   context.sequence_no = contexts.reject{|item| item.definition!=parameter_context}.size+1   
   context.label = "#{parameter_context.label}[#{self.contexts.size}]"
   self.contexts << context  
   logger.info "created context #{context.id}" 
   return context
 end
 
###
# Build a in memory two way hash(rows/cols) of all the values in the task 
# 
 def rows
   unless @rows
     @rows = {} 
     contexts.each{ |row|  @rows[row.row_no] = row } 
     for item in self.items 
        row = @rows[item.context.row_no] ||= item.context
        #puts "context #{row.id}  #{row.label} row #{row.row_no} #{item.column_no}  task item #{item.id}"
        row.add_column(item)
     end
   end
   return @rows
 end
##
# Get a Row (TaskContext) my position in int 
# 
 def row(row_no)
  return self.rows[row_no]
 end 
##
# Get a Cell position 
# 
 def cell(row_no,column_no)
   return self.row(row_no).column(column_no)
 end


##
# Export a data grid to cvs report
# 
 def to_csv
    return FasterCSV.generate do |csv|
      csv << %w(start id name status experiment protocol study version)
      csv << ['task',id, name, status, experiment.name, protocol.name,  experiment.study.name,  process.version]
      definition = nil
      for row_no in rows.keys.sort
        context = row(row_no)
        unless context.definition == definition
          definition = context.definition
          csv << ''
          csv << ['context',definition.label,'Row No.'].concat(context.names)
          csv <<  ['types',definition.label,''].concat(context.styles)           
        end
        csv << ['values', context.label, context.row_no].concat( context.values)
      end
      csv << ['end',description]      
    end
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")
      return ex.message
 end

##
# Update all queue_items with where current task status value if they are acvtive
# 
# 
 def update_queued_items
   sql= <<SQL
select qi.* 
from queue_items qi 
inner join task_references tr on tr.data_type=qi.data_type and tr.data_id = qi.data_id 
inner join parameters p on p.id =tr.parameter_id and p.study_queue_id=qi.study_queue_id
where tr.task_id = ?
SQL
   for item in QueueItem.find_by_sql([sql,self.id])
      if item.is_active
         item.task = self
         item.experiment = self.experiment
         item.current_state_id = self.current_state_id if self.is_status(ACCEPTED,WAITING,PROCESSING,VALIDATION,COMPLETED)
      end
   end
 end

end
