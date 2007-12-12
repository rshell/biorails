# == Schema Information
# Schema version: 281
#
# Table name: tasks
#
#  id                  :integer(11)   not null, primary key
#  name                :string(128)   default(), not null
#  description         :text          
#  experiment_id       :integer(11)   not null
#  protocol_version_id :integer(11)   not null
#  status_id           :integer(11)   default(0), not null
#  is_milestone        :boolean(1)    
#  priority_id         :integer(11)   
#  started_at          :datetime      
#  ended_at            :datetime      
#  expected_hours      :float         
#  done_hours          :float         
#  lock_version        :integer(11)   default(0), not null
#  created_at          :datetime      not null
#  updated_at          :datetime      not null
#  study_protocol_id   :integer(11)   
#  project_id          :integer(11)   not null
#  updated_by_user_id  :integer(11)   default(1), not null
#  created_by_user_id  :integer(11)   default(1), not null
#  assigned_to_user_id :integer(11)   default(1)
#  expected_at         :datetime      
#

require "faster_csv"
require 'matrix'

#
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
# This is a Task recording data from running of a process instance.  The task  is 
# the basic unit of work for data capture in a experiment/study/project. All tasks
# have a start , end date and status values.
#
# Most of timeline and calender use tasks a the basic useds.
# 
class Task < ActiveRecord::Base
#
# Moved Priority and Status enumeriation code to /lib modules
#
  include  CurrentPriority
  
  acts_as_scheduled 
#
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

  acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
                              :description=>{:store=>:yes,:boost=>0},
                              }, 
                   :default_field => [:name],           
                   :single_index => true, 
                   :store_class_name => true 
  

##
#Owner project
#  
  belongs_to :project  
  
  attr_accessor :rows

  validates_uniqueness_of :name, :scope =>"experiment_id"
  validates_presence_of   :name
  validates_presence_of   :description
  validates_presence_of :project_id
  validates_presence_of :experiment_id
  validates_presence_of :protocol_version_id
  validates_presence_of :started_at
  validates_presence_of :expected_at  
  validates_presence_of :status_id

  def validate 
    if ended_at and started_at and ended_at < started_at
      errors.add(:started_at,"Should be #{started_at}  less then end date #{ended_at}")
    end
  end
##
# Link to view for summary stats for study
# 
  has_many :stats, :class_name => "TaskStatistics" ,:include=>[:parameter,:role,:type]  
##
#  link to the experiment the task is created in
#   
  belongs_to :experiment
##
# Current process this task in running for data entry
#   
  belongs_to :process, :class_name =>'ProtocolVersion', :foreign_key=>'protocol_version_id'
##
# Protocol this is linked to which describes the process
#
  belongs_to :protocol, :class_name =>'StudyProtocol', :foreign_key=>'study_protocol_id' 
##
# In the Process sets of parameters are grouped into a context of usages
# 
  has_many :contexts, :class_name =>'TaskContext', :dependent => :destroy, :order => 'row_no,task_contexts.id',:include => ['definition'] do
    def matching(object,options={})      
        with_scope :find => options  do
              find(:all, 
                   :order => 'row_no,task_contexts.id',
                   :conditions=>["#{self.proxy_reflection.klass.table_name}.#{object.class.to_s.underscore}_id=?",object.id] )
        end  
    end
  end 
##
# As contexts may be in a tree is a good idea to start at the roots some times
#
  has_many :roots, :class_name =>'TaskContext', :order => 'row_no', :conditions=>'parent_id is null'
##
#  has many project elements associated with it
#  
  has_many :elements, :class_name=>'ProjectElement' ,:as => :reference, :dependent => :destroy

  belongs_to :assigned_to, :class_name=>'User', :foreign_key=>'assigned_to_user_id'  
 
##
# Ok links to complete sets of TaskItems associated with the Task.
# Generally for working with data a complete task is loaded into server
# memory for processing. 
 has_many :values, :class_name=>'TaskValue', :order =>'task_contexts.row_no,parameters.column_no',:include => ['context','parameter'] do
    def matching(object,options={})      
        with_scope :find => options  do
              find(:all,
                   :order =>'task_contexts.row_no,parameters.column_no',
                   :conditions=>["#{self.proxy_reflection.klass.table_name}.#{object.class.to_s.underscore}_id=?",object.id] )
        end  
    end
  end 


 has_many :texts, :class_name=>'TaskText', :order =>'task_contexts.row_no,parameters.column_no',:include => ['context','parameter'] do
    def matching(object,options={})      
        with_scope :find => options  do
              find(:all,
                   :order =>'task_contexts.row_no,parameters.column_no',
                   :conditions=>["#{self.proxy_reflection.klass.table_name}.#{object.class.to_s.underscore}_id=?",object.id] )
        end  
    end
  end 


 has_many :references, :class_name=>'TaskReference', :order =>'task_contexts.row_no,parameters.column_no',:include => ['context','parameter'] do
    def matching(object,options={})      
        with_scope :find => options  do
              find(:all,
                   :order =>'task_contexts.row_no,parameters.column_no',
                   :conditions=>["#{self.proxy_reflection.klass.table_name}.#{object.class.to_s.underscore}_id=?",object.id] )
        end  
    end
  end 


 
def before_update
    ref = self.folder
    if ref.name !=self.name
      ref.name = self.name
      ref.save!
    end
end

def before_destroy
   self.folder.destroy
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
 
 def process_name
   return process.name if process
 end
#
# get the study protocol name or null is null is currently linked in
#
 def protocol_name
   return protocol.name if protocol
 end
#
# get experiment name or null is null is currently linked in
#
 def experiment_name
   return experiment.name if experiment
 end
#
# test if this the the only task dependent on this protocol definition
#
 def is_modifiable
   return ( !process.nil?  and process.tasks.size<2 )
 end
##
# List of all the queue Items associated with the task
#  
 def queue_items
   sql= <<SQL
select qi.* 
from queue_items qi 
inner join task_references tr on tr.data_type=qi.data_type and tr.data_id = qi.data_id 
inner join parameters p on p.id =tr.parameter_id and p.study_queue_id=qi.study_queue_id
where tr.task_id = ?
SQL
   QueueItem.find_by_sql([sql,self.id])
 end
 #
 # Get the folder for this task
 #
  def folder(item=nil)
    folder = self.experiment.folder(self)
    if item
      return folder.folder(item)
    else
      return folder
    end
  end 

 def milestone?
   self.is_milestone==1
 end
 
 def is_milestone=(value)
   write_attribute(:is_milestone,1) if value
 end
#
#List of reports setup to run against this task
#
 def reports
    unless @reports
         @reports= []
         @reports.concat(Report.contains_column('task.id').each{|report| report.column('task.id').filter = self.id} )
         @reports.concat(Report.contains_column('task_id').each{|report| report.column('task_id').filter = self.id} )
    end
    return @reports
 end 
#
# Clear current date and work done and setup for 1 day from  now
#  
  def reset
     @is_milestone = false
     @started_at = Time.new
     @ended_at = Time.new + 1.day
     @expected_hours = 1
     @done_hours = 0
     refresh
  end 
  
#
# the the column titles as array of strings
#
  def to_titles
    titles =[]
    data = {}  
    titles[0] = self.name
    process.parameters.each do |p|
      data[p.column_no] = p.name
    end  
    return titles.concat(data.keys.sort.collect{|i|data[i]})
  end
#
# get all rows for a known context
#
  def to_rows(context=nil)
    row_defaults =[]
    data = {}  
    process.parameters.each do |p|
      row_defaults[p.column_no] = p.default_value 
    end
    for item in self.items
        if (context.nil? or context.id == item.context.id or context.id == item.context.parent_id)  
          if item.context.parent_id and data[item.context.parent.row_no.to_i] and ! data[item.context.row_no.to_i]
              data[item.context.row_no.to_i] ||= data[item.context.parent.row_no.to_i].clone 
          end
          data[item.context.row_no.to_i] ||= row_defaults.clone            
          data[item.context.row_no.to_i][0] = item.context.label
          data[item.context.row_no.to_i][item.parameter.column_no] = item.value
          
        end        
    end
    return data 
  end
#
# Convert task to a simple matrix for easy analysis use
#
  def to_matrix(context=nil)
    data = self.to_rows(context)
    return Matrix.rows(data.keys.sort.collect{|i|data[i]})    
  end  
#
# refresh cached items array
# 
 def refresh
   @items = nil
   @grid = nil
   items
   rows
   return @items
 end
#
# combined array of all TaskItems and cache in memory
# 
 def items
    return @items if @items
    @items = Array.new
    @items.concat(values)
    @items.concat(texts)
    @items.concat(references)
    @items = @items.sort{|a,b|a.context.row_no <=> b.context.row_no}
 end  
#
#copy a existing task
# 
 def copy(delta_time=0)
   task = self.class.new
   task.name = self.name
   task.description = self.description
   task.process = self.process
   task.protocol= self.protocol 
   task.project = self.project
   task.priority_id = self.priority_id
   task.assigned_to_user_id = self.assigned_to_user_id
   task.done_hours = 0
   task.expected_hours = self.expected_hours
   if task.is_finished
     task.expected_hours =  self.period / (24*60*60)
   end
   task.started_at =  (self.started_at.to_time + delta_time)
   task.expected_at = (self.finished_at.to_time + delta_time)
   logger.info "[#{delta_time}] #{self.started_at} #{self.finished_at} => #{task.started_at} #{task.finished_at}"
   return task
 end
#
#  This created as hashed data structure of [task_context][parameter_id]
#
 def grid
    @grid ||=TreeGrid.from_task(self)
 end
#
# Fraction of work done  
# 
 def done
   begin
      self.done_hours/self.expected_hours
   rescue 
     0
   end
 end

#
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
 
#
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
#
# Get a Row (TaskContext) my position in int 
# 
 def row(row_no)
  return self.rows[row_no]
 end 
#
# Get a Cell position 
# 
 def cell(row_no,column_no)
   return self.row(row_no).column(column_no)
 end
#
# Run a named analyse method to the data in this taks
#
 def analysis(name=nil)
    processor = Analysis.find_by_name(name)
    processor.init(self)
    processor.run
    processor.done
 end
#
# Export a data grid to cvs report
# 
 def to_csv
    return self.grid.to_csv
 end
#
# Update all queue_items with where current task status value if they are acvtive
# 
# 1) Only update active items
# 2) Only update items which are not associated with a task or with this task
# 3) Dont update when queue item is in failed status
# 
 def update_queued_items
   for item in self.queue_items
      if item.is_active and (item.task_id.nil? or item.task_id==self.id)
         item.task_id = self.id
         item.experiment_id = self.experiment_id
         if self.is_active or self.is_finished
             item.status_id = self.status_id 
         elsif  self.is_status(FAILED_STATES)
             item.status_id = WAITING 
         end
         item.save
      end
   end
 end
 #
 # For presentation in reports
 #
 def to_html
    matrix = self.to_matrix
    out = " <b> Task #{self.name}</b><br/>"
    out << "<table class='report'>"
    out << "<tr><th>row</th>"
    for title in self.to_titles
       out << "<th>#{title} </th>"
    end
    out << "</tr>"    
    0.upto(matrix.row_size-1) do |row|
       out << "<tr><th>#{row}</th>"
       0.upto(matrix.column_size-1) do |col| 
          out << "<td>#{matrix[row,col]}</td>"
       end
       out << "</tr>"
    end
    out << "</table>"
    out << "<br/>"
    out     
  end

end
