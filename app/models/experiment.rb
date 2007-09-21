# == Schema Information
# Schema version: 280
#
# Table name: experiments
#
#  id                  :integer(11)   not null, primary key
#  name                :string(128)   default(), not null
#  description         :text          
#  category_id         :integer(11)   
#  status_id           :integer(11)   default(0), not null
#  study_id            :integer(11)   not null
#  protocol_version_id :integer(11)   
#  lock_version        :integer(11)   default(0), not null
#  created_at          :datetime      not null
#  updated_at          :datetime      not null
#  study_protocol_id   :integer(11)   not null
#  project_id          :integer(11)   not null
#  updated_by_user_id  :integer(11)   default(1), not null
#  created_by_user_id  :integer(11)   default(1), not null
#  started_at          :datetime      
#  ended_at            :datetime      
#  expected_at         :datetime      
#

require "faster_csv"

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Experiment < ActiveRecord::Base
  included Named

  validates_uniqueness_of :name
  validates_presence_of   :name
  validates_presence_of   :description
  validates_presence_of   :study_id
  validates_presence_of   :project_id
  validates_presence_of   :study_protocol_id
#  validates_presence_of   :started_at
#  validates_presence_of   :expected_at  

##
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

##
# The experiment is a summary of the tasks
#
  acts_as_scheduled  :summary=>:tasks

  has_many_scheduled :tasks,  :class_name=>'Task',:foreign_key =>'experiment_id',:dependent => :destroy
  has_many_scheduled :queue_items,  :class_name=>'QueueItem',:foreign_key =>'experiment_id'

##
# Stats view of whats happened in the experiment 
#   
  has_many :stats, :class_name => "ExperimentStatistics"
##
# Logs on the Study Timeline 
#   
  has_many :logs, :class_name => "ExperimentLog", 
          :as => :auditable, :dependent => :destroy
##
# Experiments is carried out in the scope of a  study
#
  belongs_to :study
##
# Current default process
#   
  belongs_to :process, :class_name =>'ProtocolVersion', :foreign_key=>'protocol_version_id'
##
# Protocol this is linked to
#
  belongs_to :protocol, :class_name =>'StudyProtocol', :foreign_key=>'study_protocol_id' 

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
#
# Get the folder for this protocol
#
  def folder(item=nil)
    folder = self.project.folder(self)
    if item
      return folder.folder(item)
    else
      return folder
    end
  end


  def rename(new_name)
    folder = self.folder
    folder.name = new_name
    self.name = new_name     
  end
##
# first task to start in the experiment
#   
 def first_task    
    if self.tasks.size>1 
       self.tasks.min{|i,j|i.started_at <=> j.started_at}
    else   
       return self.tasks.first
    end    
 rescue
   logger.warn("problem finding first item?")
   return self.created_at       
 end
##
# last task to end in the experiment
# 
 def last_task
    if tasks.size>0 
        self.tasks.max{|i,j|i.started_at <=> j.started_at}
    end 
 end 
##
# start of first task 
#
 def started_at
    if tasks.size > 0 
       return first_task.started_at
   else
       return created_at  
    end
 end
##
# end of last task
#
 def ended_at
   if tasks.size >0 
       return last_task.ended_at
   else
       return nil  
   end  
 end
##
# Get the named experiment from the list attrached to the study
# 
  def task(name)
    return self.tasks.detect{|i|i.name == name}
  end
##
# Get summary stats to compare task with all runs in the study.
# This shows TaskStatistics with extra linked values at the 
# study level.
# 
 def statistics
   sql = <<SQL
	select 
	  s1.experiment_id
	 ,s1.study_parameter_id
	 ,s1.parameter_type_id
	 ,s1.parameter_role_id
	 ,s1.data_type_id
	 ,s1.avg_values
	 ,s1.stddev_values
	 ,s1.num_values
	 ,s1.num_unique
	 ,s1.min_values
	 ,s1.max_values
	 ,s2.avg_values avg_study
	 ,s2.stddev_values stddev_study
	 ,s2.num_values num_study
	 ,s2.min_values min_study
	 ,s2.max_values max_study
	from experiments e, experiment_statistics s1, study_statistics s2
	where e.id = s1.experiment_id
	and   e.id = ?
	and   e.study_id = s2.study_id
	and   s1.study_parameter_id = s2.id
	and   s1.data_type_id = s2.data_type_id
SQL
   ExperimentStatistics.find_by_sql([sql,self.id])
 end
 
##
# Period of time for a experiment (default == 1 week)
# 
 def period
     if tasks.size>0
       return last_task.finished_at - first_task.started_at 
     else
       return 1.week
     end   
 end  

##
# Copy the experiment and create a new persistent copy
# 
 def copy(name = nil, start = nil)
   start ||= Time.now
   expt = Experiment.new(:started_at => start, :expected_at=>(start + self.period ))
   expt.name = name || Identifier.next_user_ref
   expt.description = self.description
   expt.study = self.study
   expt.project = self.project
   expt.process = self.process
   expt.protocol= self.protocol    
   expt.save!  
   delta_time = expt.started_at - self.started_at
   logger.info "Experiment #{expt.started_at} #{expt.finished_at}"
   
   for old_task in self.tasks
      task = old_task.copy(delta_time)
      task.experiment = expt
      task.name = expt.name+":"+expt.tasks.size.to_s
      expt.tasks << task
   end
   return expt
 end

##
# create a new task
#  
 def new_task
   task = Task.new
   task.name = Identifier.next_id(Task)
   task.process = self.process
   task.protocol= self.protocol 
   task.project = self.project
   task.assigned_to_user_id = User.current.id
   task.expected_hours =1
   task.done_hours = 0
   task.started_at = Time.new
   task.expected_at = Time.new+1.day
   task.description = " Task in experiment #{self.name} "      
   tasks << task
   task.save
   logger.info "New Task #{task.id}"
   return task
 end
 
 

##
# Import file into the task
# 
# first  
# Task   study,experiment,task,status
# note   description
# Header label  [name,]
# Data   row    [value,]
# 
  def import_task(data)
    @line =0
    @lookup = Hash.new 
    @lines =[]
    logger.info "Got #{data.class} to import \n #{data}"
    case data 
    when File, Tempfile
       @lines = FasterCSV.read(data.path)
    when StringIO
       @lines =FasterCSV.parse(data) 
    when String
       @lines =FasterCSV.parse(data) 
    else 
       @lines =[]
    end    

    for row in @lines
       logger.debug row.to_s
       @line +=1
       logger.info row.join(",")
       case row[0]
       when 'start':   @task = nil
       when 'task' 
          @task = read_task(row)
          logger.info  "Line[#{@line}] starting task #{@task.name}"
       
       when 'context'  
           @definition = read_context(@task,row) 
       when 'values' 
           @context = read_values(@task,@definition,row) 
       when 'end'
          @task.save
          @task.grid.save 
          logger.info "Saved task #{@task.name}"
          
       else # url etc
          logger.info "Line[#{@line}] Skipped "+row.join(',')
       end
    end
    return @task
  end

protected

############################################################################
# Read the task line to work out what we are expecting
# row[0]
# row[1]  task.id
# row[2]  task.name
# row[3]  task.status
# row[4]  experiment.name
# row[5]  protocol.name
# row[6]  study.name
# row[7]  protocol.versionMS
# 
############################################################################
  def read_task(row)
      logger.info "Creating task "+row[2].to_s
      task = nil
##
# Get the linked task to import
#
      if row[1].nil? or row[1].empty?
         task = self.new_task 
         task.name   = row[2] if row[2]
         #task.status = row[3] if row[3]
         task.description = "Data Import from file" 
      else
         logger.info " Importing over existing Task["+row[1]+"]"
         task = Task.find(row[1])   
      end  
##
#  Correct the process version to needed
#  
      if row[5] and task.contexts.size == 0               
         task.protocol = study.protocol(row[5])                
         task.process = task.protocol.version(row[7]) if row[7]   
         task.process = task.protocol.process  unless task.process
         logger.info "reset process " + task.name   
      end 
##
# Create a modifiable version of the protocol if needed
# 
      if @dynamic and task.process.tasks.size >1
         task.process = task.protocol.editable              
         logger.info "editable process" + task.name   
      end

      unless task.valid?
         raise "Failed to create task ["+name+"] Errors:"+task.errors.full_messages().to_sentence            
      end
      unless task.name == row[2]
         raise "Failed to import task ["+name+"] task name does not match database "                
      end
      unless self.name == row[4]
         raise "Failed to import task ["+name+"] experiment name does not match database "                
      end
      unless self.study.name == row[6]
         raise "Failed to import task ["+name+"] study name does not match database "                
      end
      task.grid.save
      return task      
 end
  
############################################################################
# Read the task line to work out what we are expecting
# row[0]  "task" row label
# row[1]  parameter_context.label
# row[2]  label
# row[3..n]  parameter.name values
############################################################################
  def read_context(task,row)
     @lookup={}
     @extras=[]
     @missing=[]

     definition = task.process.contexts.detect{|i|i.label = row[1]}
     unless definition
        raise "Context definition [" + row[1] + "] on row ["+row.join(",") +"] not found "       
     end
     items = row[3...1000000]
     for parameter in definition.parameters
        col = items.index(parameter.name)
        if col
           @lookup[col] = parameter
        else
           @missing << parameter
        end
     end
     @extras= items - @lookup.values.collect{|i|i.name}
     
     for name in @extras
          logger.info  "Extra Parameter #{name}"         
     end     
     return definition
     
  rescue  Exception => ex
     logger.error ex.message
     logger.debug ex.backtrace.join("\n") 
     logger.info "Rejected: #{row.join(',')}"
     self.errors.add_base  " Line [" + @line.to_s + "] failed to read context: " + ex.message
   end
  
############################################################################
# Read the task line to work out what we are expecting
# row[0]  "value" row label
# row[1]  task_context.label
# row[2]  i row_no
# row[3..n]  task_item.value values
############################################################################

  def read_values(task,definition,row)
     i = row[2].to_i
     item = nil
     context = task.grid.rows[i]
     col=0
     if context
       for parameter in context.parameters
          value = row[col+3]
          logger.info "TaskItem[#{i},#{col}] #{parameter.name} = #{value}"
          cell = context.cell(parameter)
          cell.value = value
          col +=1
       end
     else
        logger.info "TaskItem[#{i}] Failed to find row in grid"
     end
     return context
  rescue  Exception => ex
     logger.error ex.message
     logger.debug ex.backtrace.join("\n") 
     logger.info  "Rejected: #{row.join(',')}"
     self.errors.add_base " file line [" + @line.to_s + "] import failed: " + ex.message
  end

 #
 # For presentation in reports
 #
 def to_html
    out = " <b> Experment: #{self.name}</b><br/>"
    out << "<table class='report'>"
    out << "<tr><th>task</th>"
    out << "<th>description</th>"
    out << "<th>status</th>"
    out << "</tr>"
    for task in self.tasks
       out << "<tr>"
       out << "<td> #{task.name} </td>"
       out << "<td> #{task.description} </td>"
       out << "<td> #{task.status} </td>"
       out << "</tr>"
    end
    out << "</table>"
    out << "<br/>"
    out     
  end


end
