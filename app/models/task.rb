# == Schema Information
# Schema version: 359
#
# Table name: tasks
#
#  id                  :integer(4)      not null, primary key
#  name                :string(128)     default(""), not null
#  description         :string(1024)    default(""), not null
#  team_id             :integer(4)      default(0), not null
#  project_id          :integer(4)      not null
#  assay_protocol_id   :integer(4)
#  experiment_id       :integer(4)      not null
#  protocol_version_id :integer(4)      not null
#  assigned_to_user_id :integer(4)      default(1)
#  is_milestone        :boolean(1)
#  priority_id         :integer(4)
#  started_at          :datetime
#  expected_at         :datetime
#  ended_at            :datetime
#  expected_hours      :float
#  done_hours          :float
#  lock_version        :integer(4)      default(0), not null
#  created_at          :datetime        not null
#  created_by_user_id  :integer(4)      default(1), not null
#  updated_at          :datetime        not null
#  updated_by_user_id  :integer(4)      default(1), not null
#  parent_id           :integer(4)
#  type                :string(255)     default("Task")
#  project_element_id  :integer(4)
#

# == Description
# 
# This is a Task recording data from running of a process instance.  The task
# is the basic unit of work for data capture in a experiment/assay/project. All
# tasks have a start , end date and status values.
# 
# Most of timeline and calender use tasks a the basic useds.
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class Task < ActiveRecord::Base
  # 
  # Moved Priority and Status enumeriation code to /lib modules
  # 
  has_priorities :priority_id
  # 
  # access control managed via team
  # 
  acts_as_folder_linked :experiment
  # 
  # Owner project
  # 
  belongs_to :project
  belongs_to :team
  # 
  # is something that can be scheduled in a calendar
  # 
  acts_as_scheduled 
  # 
  # This record has a full audit log created for changes
  # 
  acts_as_audited :change_log , {:auditing_enabled =>true}

    
  attr_accessor :rows
  # 
  # Validation rules for the task
  # 
  validates_uniqueness_of :name, :scope =>"experiment_id",:case_sensitive=>false
  validates_presence_of   :name
  validates_presence_of   :description
  validates_presence_of :project_id
  validates_presence_of :experiment_id
  validates_presence_of :protocol_version_id
  validates_presence_of :started_at
  validates_presence_of :expected_at  

  validate  :validate_period
  validate  :validate_references


  # ## Link to view for summary stats for assay
  # 
  has_many :stats, :class_name => "TaskStatistics" ,:include=>[:parameter,:role,:type]  
  # ##
  #  link to the experiment the task is created in
  # 
  belongs_to :experiment
  # ## Current process this task in running for data entry
  # 
  belongs_to :process, :class_name =>'ProtocolVersion', :foreign_key=>'protocol_version_id'

  has_many :queue_items, :class_name =>'QueueItem', :foreign_key=>'task_id'
   
  # ## In the Process sets of parameters are grouped into a context of usages
  # 
  has_many :contexts, :class_name =>'TaskContext', :dependent => :destroy, 
    :order => 'task_contexts.left_limit,task_contexts.parent_id,task_contexts.id' do
    # 
    #  get records matching by row_no, label of ParameterContext
    # 
    def matching(object =nil,options={})      
      with_scope :find => options  do
        case object
        when ParameterContext              
          find(:all, 
            :order => 'task_contexts.label,task_contexts.row_no',
            :conditions=>["#{self.proxy_reflection.klass.table_name}.#{object.class.class_name.underscore}_id=?",object.id] )
        when Fixnum     
          find(:all, 
            :order => 'task_contexts.row_no,task_contexts.id',
            :conditions=>["#{self.proxy_reflection.klass.table_name}.row_no=?",object] )
        else     
          find(:all, 
            :order => 'task_contexts.label,task_contexts.row_no',
            :conditions=>["#{self.proxy_reflection.klass.table_name}.label like ?","#{object}%"] )
        end     
      end  
    end
  end 
  # ## As contexts may be in a tree is a good idea to start at the roots some
  # times
  # 
  has_many :roots, :class_name =>'TaskContext', :order => 'row_no', :conditions=>'parent_id is null'
  # ##
  #  has many project elements associated with it
  # 
  has_many :elements, :class_name=>'ProjectElement' ,:as => :reference, :dependent => :destroy
  # 
  # link to the user who owns the task
  # 
  belongs_to :assigned_to, :class_name=>'User', :foreign_key=>'assigned_to_user_id'  
 
  # ## Ok links to complete sets of TaskItems associated with the Task.
  # Generally for working with data a complete task is loaded into server memory
  # for processing.
  # 
  # 
  has_many :values, :class_name=>'TaskValue',:dependent => :destroy do
    def ordered
      find(:all,:order =>'task_contexts.row_no,parameters.column_no',:include => ['context','parameter'])
    end
    
    def matching(object)      
      find(:all,
        :order =>'task_contexts.row_no,parameters.column_no',
        :include => ['context','parameter'],
        :conditions=>["#{self.proxy_reflection.klass.table_name}.#{object.class.class_name.underscore}_id=?",object.id] )
    end
  end 


  has_many :texts, :class_name=>'TaskText',:dependent => :destroy do

    def ordered
      find(:all,:order =>'task_contexts.row_no,parameters.column_no',:include => ['context','parameter'])
    end

    def matching(object)      
      find(:all,
        :order =>'task_contexts.row_no,parameters.column_no',
        :include => ['context','parameter'],
        :conditions=>["#{self.proxy_reflection.klass.table_name}.#{object.class.class_name.underscore}_id=?",object.id] )
    end
  end 


  has_many :references, :class_name=>'TaskReference',:dependent => :destroy do

    def ordered
      find(:all,:order =>'task_contexts.row_no,parameters.column_no',:include => ['context','parameter'])
    end
    
    def matching(object)      
      find(:all,
        :order =>'task_contexts.row_no,parameters.column_no',
        :include => ['context','parameter'],
        :conditions=>["#{self.proxy_reflection.klass.table_name}.#{object.class.class_name.underscore}_id=?",object.id] )
    end
  end 
  # 
  # make sure project and team are set
  # 
  before_validation :fill_record_details
  # 
  # After create copy all the element from the process folder to the task folder
  # 
  after_create :link_to_process_folder

  # 
  # before update of the task make use the name is in sync of the folder
  # 
  before_update :resync_with_folder_element_name
  before_update :fill_records_ended_at_time
  # 
  # Constructor uses current values for User,project and team in creation of a
  # new Experimtn These can be overiden as parameters (:user_id=> ,:project_id
  # => , team_id => )
  # 
  def initialize(options = {})
    super(options)      
    Identifier.fill_defaults(self)    
    self.expected_hours ||=1
    self.done_hours  ||= 0
    self.started_at  ||= Time.new
    self.expected_at ||= Time.new+1.day
  end 
  
  #
  # get the protocol via 
  #
  def protocol
    self.process.protocol if self.process
  end
  #
  # Set the process to best available from the protocol
  #
  def protocol=(value)
    self.process= value.released ||  value.latest
  end
  # ## Get summary stats to compare task with all runs in the process. This is
  # basically a set of TaskStatistics with added details on the linked values at
  # the process level.
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
  # 
  # short cut to the process name
  # 
  def process_name
    return process.name if process
  end
  # 
  # short cut to the process name
  # 
  def assay_name
    return protocol.assay.name if protocol and protocol.assay
  end
  # 
  # get the assay protocol name or null is null is currently linked in
  # 
  def protocol_name
    return process.protocol.name if process and process.protocol
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
  def flexible?
    return ( self.process and process.flexible? )
  end

  #
  # Path unique name for task
  #
  def path
    "#{self.experiment.name}:#{self.name}"
  end
  
  # 
  # make the task flexible generating a protocol with is only linked to this
  # single task so it can be edited
  # 
  def make_flexible
    return false if self.new_record?
    unless flexible?
      Task.transaction do
        new_process = self.process.copy
        new_process.save
        for context in self.process.contexts 
          new_context = new_process.context(context.label)
          TaskContext.update_all("parameter_context_id=#{new_context.id}","task_id=#{self.id} and parameter_context_id=#{context.id}")
        end
        for parameter in self.process.parameters
          new_parameter = new_process.parameter(parameter.name)
          TaskValue.update_all(    "parameter_id=#{new_parameter.id}", "task_id=#{self.id} and parameter_id=#{parameter.id}")
          TaskReference.update_all("parameter_id=#{new_parameter.id}", "task_id=#{self.id} and parameter_id=#{parameter.id}")
          TaskText.update_all(     "parameter_id=#{new_parameter.id}", "task_id=#{self.id} and parameter_id=#{parameter.id}")
        end
        self.process = new_process
        return self.save
      end
    end
  end

  # 
  # Create a new Context
  #    parameter_context to used as basis
  #    new_label for row (must be unique in task)
  #    parent options parent task_context
  # 
  def add_context(parameter_context = nil, new_label = nil, parent =nil)   
    TaskContext.transaction do
      parameter_context ||= ( parent ? parent.definition.children.first :  self.process.first_context )
      raise("parameter_context_id not in process linked to task") unless parameter_context.protocol_version_id == self.protocol_version_id
      if  parameter_context
        context = TaskContext.new
        if parent
          raise("Failed parameter_context invalid should have parent") if parameter_context.parent_id.blank?
          context.sequence_no = self.contexts.matching("#{parameter_context.label}.#{parent.seq}").size + 1
          context.label ||= new_label || "#{parameter_context.label}.#{parent.seq}.#{context.sequence_no}"
        else
          raise("Failed parameter_context invalid should not have a parent") unless parameter_context.parent_id.blank?
          context.sequence_no = self.contexts.matching(parameter_context).size + 1
          context.label ||= new_label || "#{parameter_context.label}.#{context.sequence_no}"         
        end       
        context.task = self
        context.is_valid = true 
        context.parent = parent if parent
        context.row_no = self.contexts.count
        context.definition = parameter_context
        if parent
          parent.add_child(context)
        end
        self.contexts << context 
        logger.info "created root context #{context.id}  #{context.row_no}  #{context.label}" 
        context.populate
        context.save!
        return context
      end
    end
  end 

  # 
  # Queues this task will take items off
  # 
  def queues
    return [] unless self.process
    self.process.queues 
  end
 
  def queue_parameters
    return [] unless self.process
    self.process.parameters.queued
  end  
  # 
  # Is this task released to queues
  # 
  def queues?
    self.process.queues? if self.process
  end  
  # ## List of all the queue Items associated with the task
  # 
  def possible_queue_items
    sql= <<SQL
select qi.* 
from queue_items qi 
inner join task_references tr on tr.data_type=qi.data_type and tr.data_id = qi.data_id 
inner join parameters p on p.id =tr.parameter_id and p.assay_queue_id=qi.assay_queue_id
where tr.task_id = ?
SQL
    QueueItem.find_by_sql([sql,self.id])
  end
  # 
  # Update all queue_items with where current task status value if they are
  # acvtive
  # 
  # 1) Only update active items
  # 2) Only update items which are not associate with a task or with this task
  # 3) Dont update when queue item is in failed
  # status
  # 
  def update_queued_items(queue_items_to_update=nil)
    return unless queues?
    queue_items_to_update ||= self.queue_items
    for item in queue_items_to_update
      if !item.finished? and (item.task_id.nil? or item.task_id==self.id)
        item.task_id = self.id
        item.experiment_id   = self.experiment_id
        item.status_id       = self.status_id
        item.folder.state_id = self.state_id
        item.folder.save!
        item.save!
      end
    end
  end
  # 
  # Simple function to assign queue items to task automatically
  # 
  # 
  def assign_queued_items
    return unless queues?
    added_items = []
    TaskReference.transaction do
      for parameter in  self.queue_parameters
        for row in self.rows       
          if parameter.context == row.definition
            item = row.item(parameter,nil)
            if item.value.blank?
              todo = parameter.queue.next_available_item
              if todo and todo.active? and todo.task.nil?
                item.value = todo.value
                item.save
                todo.task = self
                todo.experiment = self.experiment
                todo.save
              end
            end  
          end  
        end  
      end
    end
    return added_items
  end  
  # 
  # Test it this is maked as a milestone in the experiment
  # 
  def milestone?
    self.is_milestone==1
  end
  # 
  # set as a milestone
  # 
  def is_milestone=(value)
    write_attribute(:is_milestone,1) if value
  end
  # 
  # the the column titles as array of strings
  # 
  def to_titles
    return [self.name].concat(self.process.names)
  end
  # 
  # get all rows for a known context
  # 
  def to_hash(definition)
    row_defaults ={}
    data = {}  
    self.populate
    # ## Setup default values for cells
    process.parameters.each do |p|
      row_defaults[p.dom_id] = p.default_value 
    end
    # ## Setup default rows
    selected_rows = self.contexts.select{|i|i.parameter_context_id == definition.id} 
    selected_rows.each do | context|
      data[context.label] ||= row_defaults.clone            
      data[context.label][:id] = context.id
      data[context.label][:context_id] = context.id
      data[context.label][:row_no] = context.row_no
      data[context.label][:row_label] = context.label
      data[context.label][:row_group] = context.row_group
    end
    for item in self.items
      if (definition.id == item.context.parameter_context_id)  
        if data[item.context.label]
          data[item.context.label][item.parameter.dom_id] = item.to_s        
        end
      end        
    end
    return { :task_id => self.id,
      :folder_id => self.project_element_id,
      :flexible =>  self.flexible?,             
      :values =>   data.values,
      :parent_id => definition.parent_id,
      :expected => definition.default_count,
      :level_no => definition.level_no,
      :label => definition.label,
      :path => definition.path
    }          
  end
  # ## populated the task creating all the expected context rows
  #
  def populate
    @rows = rows_indexed_by(:row_no)
    return @rows
  end

  # ## populated the task creating all the expected context rows
  #
  def recalculate
    cleanup_references
    contexts.each do |context|
      context.recalculate
    end
    @rows = nil
  end

  def validate_mandatory
    list = verify_mandatory
    list.size==0
  end
  #
  # SQL to list all contexts missing a mandatory field
  #
  def verify_mandatory
    list = TaskContext.find_by_sql( <<-SQL
select * from task_contexts c where task_id=#{self.id}
and exists (select 1 from parameters p
            where p.parameter_context_id = c.parameter_context_id
	    and mandatory='Y')
and (exists (select 1 from task_references r where r.task_context_id = c.id)
     or exists (select 1 from task_texts t   where t.task_context_id = c.id)
     or exists (select 1 from task_values v  where v.task_context_id = c.id) )
and (exists (
    select 1 from parameters p1
    where p1.parameter_context_id = c.parameter_context_id
    and p1.data_type_id=5  and mandatory='Y'
    and not exists (select 1 from task_references r2
	            where r2.parameter_id   = p1.id
		    and   r2.task_context_id= c.id ))
and exists (
    select 1 from parameters p2
    where p2.parameter_context_id = c.parameter_context_id
    and p2.data_type_id in (1,3,4,6,7)  and p2.mandatory='Y'
    and not exists (select 1 from task_texts t2
	            where t2.parameter_id   = p2.id
		    and   t2.task_context_id= c.id ))
and exists (
    select 1 from parameters p3
    where p3.parameter_context_id = c.parameter_context_id
    and p3.data_type_id=2  and p3.mandatory='Y'
    and not exists (select 1 from task_values v2
	            where v2.parameter_id   = p3.id
		    and   v2.task_context_id= c.id )))
SQL
    )
    list.each do |item|
      self.errors.add(:contexts,"row #{item.label} missing mandatory fields")
    end
  end

  def validate_references
    list = verify_references
    list.size == 0
  end

  def cleanup_references
    list = verify_references
    list.collect{|i| i.destroy}
  end

  def verify_references
    invalid_list=[]
    references.each do |item|
      TaskContext.current = item.context
      ref = item.object
      TaskContext.current = nil
      unless ref and ref.id and ref.name
        logger.info("removed reference #{item.id} #{item.data_name}")
        self.errors.add(:references , "#{item.label}= #{item.data_name} not valid in context row #{item.context.label}")
        invalid_list << item
      end   
    end
    invalid_list
  end

  
  def to_html_cached?
    (respond_to?(:project_element) and respond_to?(:updated_at)  and project_element and 
        (project_element.content and self.updated_at <= project_element.content.updated_at
      ) and not
      (self.values.exists?(['updated_at > ?',project_element.content.updated_at]) or
          self.texts.exists?(['updated_at > ?',project_element.content.updated_at])  or
          self.references.exists?(['updated_at > ?',project_element.content.updated_at])
      )
    )
  end  
  # 
  # Build a in memory two way hash(rows/cols) of all the values in the task
  # 
  def rows
    @rows ||= rows_indexed_by(:row_no)
    return @rows.keys.sort.collect{|key|@rows[key]}
  end
  #
  # Get rows matching the passed item
  # String => label
  # Fixnum => parameter_context_id
  # ParameterContext => definition
  #
  def rows_for(item)
    case item
    when ParameterContext  
      self.contexts.find_all_by_parameter_context_id(item.id)
    when String
      self.contexts.find_all_by_label(item)
    when Fixnum
      self.contexts.find_all_by_parameter_context_id(item)
    else
      []
    end      
  end
  
  def grid
    @grid ||= self.grid_indexed_by(:label, :name) 
  end
  # 
  # Generate grid based hash[context.label][parameter.name] for use in
  # processing of data entry
  # 
  def to_grid
    @grid = {}  
    self.populate
    return grid
  end
 
  # 
  # Get a Row (TaskContext) my position in int
  # 
  def row(row_label)  
    return grid[row_label]
  end 
  # 
  # Get a Cell position
  # 
  def cell(row_label,parameter_name)
    return grid[row_label][parameter_name] if grid[row_label]
  end

  # 
  # Convert task to a simple matrix for easy analysis use column=0 row labels
  # other columns are column_no from process
  # 
  def to_matrix
    row_defaults =[]
    data = [] 
    self.populate
    self.process.parameters.each do |p|
      row_defaults[p.column_no] = p.default_value 
    end
    self.contexts.each do | context|
      data[context.row_no] ||= row_defaults.clone            
      data[context.row_no][0] = context.label
    end
    for item in self.items
      data[item.row_no] ||= row_defaults.clone            
      data[item.row_no][0] = item.context.label
      data[item.row_no][item.column_no] = item.value
    end
    return data.compact
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
    @items.concat(values.ordered)
    @items.concat(texts.ordered)
    @items.concat(references.ordered)
    # #@items = @items.sort{|a,b|a.context.row_no <=> b.context.row_no}
  end   
  # 
  # Get rows with local caching of rows
  # 
  def context(label)
    task_context = self.contexts.find(:first,:conditions=>['task_contexts.label=?',label])
    parent_context = self
    #
    # Build tree of contexts
    #
    unless task_context
      list = label.split(".")
      parameter_context = self.process.context(list.delete_at(0))
      if parameter_context.parent
        list.pop
        parent_label = "#{parameter_context.parent.name}.#{list.join('.')}"
        parent_context = self.context(parent_label)
        #
        # Recheck to context created in population of parent
        #
        task_context = self.contexts.find(:first,:conditions=>['task_contexts.label=?',label])
      elsif list.size>=3
        self.errors.add(:context,"label #{label} should have a parent parameter context")
      end
    end
    #
    # If not found create now tree populated
    #
    unless task_context
      task_context = parent_context.add_context(parameter_context)
      task_context.label = label
      task_context.save!
    end
    @rows[label] ||= task_context if @rows
    return task_context
  end
  # 
  # get item creating if needed
  # 
  def item(label,name)
    context = self.context(label)
    context.item(name) unless context.nil?  
  end

  # 
  # #copy a existing task
  # 
  def copy(delta_time=0)
    task = self.class.new
    task.name = self.name
    task.description = self.description
    task.process = self.process
    task.project = self.project
    task.priority_id = self.priority_id
    task.assigned_to_user_id = self.assigned_to_user_id
    task.done_hours = 0
    task.expected_hours = self.expected_hours
    if task.finished?
      task.expected_hours =  self.period / (24*60*60)
    end
    task.started_at =  (self.started_at.to_time + delta_time)
    task.expected_at = (self.finished_at.to_time + delta_time)
    logger.info "[#{delta_time}] #{self.started_at} #{self.finished_at} => #{task.started_at} #{task.finished_at}"
    return task
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
  # Check allowed to process data
  # 
  def start_processing
    return false if self.active? or self.finished?
    new_state = self.folder.state_flow.next_level(self.state)
    self.experiment.start_processing
    self.folder.set_state(new_state,true)
  end  

  # 
  # Run a named analyse method to the data in this taks
  # 
  def analysis(id = nil)
    id ||= self.process.analysis_method_id
    return nil unless id
    processor = AnalysisMethod.find(id)
    processor.run(self)
    processor
  end
  # 
  # Export a data grid to cvs report
  # 
  def to_csv
    self.populate
    return FasterCSV.generate do |csv|
      if self.id
        csv << ['url', self.experiment.id ,'/experiments/import_file/'+self.experiment.id.to_s] 
        csv << %w(start id name status experiment protocol assay version)
        csv << ['task',self.id, self.name,  self.status, 
          self.experiment.name, self.process.protocol.name,
          self.experiment.assay.name,  self.process.version]
      else 
        csv << ['url', '<experiment>' ,'/experiments/import_file/'+self.experiment.id.to_s] 
        csv << %w(start id name status experiment protocol assay version)
        csv << %w(task  id name status experiment protocol assay version)                      
      end
      definition = nil
      for row in self.rows
        unless row.definition == definition
          definition = row.definition
          csv << ['context',"#{definition.label}",'Row No.'].concat(definition.names)
          csv << ['types',"#{definition.label}",''].concat(definition.styles)           
        end
        list =  ['values', "#{row.label}", row.row_no]
        for parameter in row.definition.parameters
          item = self.cell(row.label,parameter.name)
          if item
            list << item.to_s
          else
            list << parameter.default_value
          end
        end
        csv << list        
      end
      csv << ['end']      
    end
  end
  # 
  # Custom data access object for user template engine liquid
  # 
  def to_liquid
    TaskDrop.new self
  end 

  # populate hash sturcture of rows indexed my label;
  # 
  def rows_indexed_by( index = :label)
    list = []
    for c in self.process.roots 
      1.upto(c.default_count) do |n|
        new_label = "#{c.label}.#{n}"
        row = self.context( new_label)
        list << row
        list << row.populate
      end      
    end
    hash ={}
    list.flatten.each{|i|hash[i.send(index)] = i}
    self.contexts.collect{|i|hash[i.send(index)] = i}
    return hash  
  end
  # 
  # populate hash structure of values indexed my row lable and parameter name
  # 
  def grid_indexed_by(row_index =:label,column_index=:name)
    row_defaults ={}
    data = {}  
    process.parameters.each do |parameter|
      row_defaults[parameter.send(column_index)] = parameter.default_value 
    end
    # ## Setup default rows
    contexts.each do | context|
      data[context.send(row_index)] ||= row_defaults.clone            
    end

    for item in self.items
      data[item.context.send(row_index)] ||= {}      
      data[item.context.send(row_index)][item.parameter.send(column_index)] = item        
    end
    return data
  end
  
  protected
      
  def resync_with_folder_element_name  
    ref = self.folder
    if ref.name !=self.name
      ref.name = self.name
      ref.save!
    end
  end

  def fill_records_ended_at_time
    # Set the Ended date id the task is finshed and delete the entry if not
    if self.finished?
      self.ended_at = Time.now
    end  
  end
  
  def fill_record_details  
    self.project ||= Project.current          
    self.team ||= Team.current
    self.assigned_to  ||= User.current
    if self.process
      self.description = self.process.description  if self.description.blank?
    end
    if self.experiment and self.process
      self.started_at  ||=  [Time.now,experiment.started_at].max
      self.expected_at ||= self.started_at + self.process.expected_hours.hours
    end
    self.done_hours ||= 0

  end
    
  # 
  # add links to process folder to pick up defaults
  # 
  def link_to_process_folder
    unless Biorails::Dba.importing?
      self.process.folder.elements.each do |element|
        self.folder.copy(element)
      end
    end
  end 
end
