# == Schema Information
# Schema version: 359
#
# Table name: experiments
#
#  id                  :integer(4)      not null, primary key
#  name                :string(128)     default(""), not null
#  description         :string(1024)    default(""), not null
#  category_id         :integer(4)
#  assay_id            :integer(4)
#  protocol_version_id :integer(4)
#  assay_protocol_id   :integer(4)
#  project_id          :integer(4)      not null
#  team_id             :integer(4)      not null
#  started_at          :datetime
#  ended_at            :datetime
#  expected_at         :datetime
#  lock_version        :integer(4)      default(0), not null
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  updated_by_user_id  :integer(4)      default(1), not null
#  created_by_user_id  :integer(4)      default(1), not null
#  process_flow_id     :integer(4)
#  project_element_id  :integer(4)
#

# == Description
#
# An experiment is the execution of an assay definition. 
# There may be one or more experiments run within a study. Each experiment may be
# executed in a set of steps or tasks defined in the assay. In BioRails, it is these tasks
# that return structured data to the database. 
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
class Experiment < ActiveRecord::Base
  # 
  # acts a dictionary indexed by name
  # 
  acts_as_dictionary :name 
  # ## This record has a full audit log created for changes
  # 
  acts_as_audited :change_log

  # 
  # Owner project
  # 
  belongs_to :project
  belongs_to :team
  belongs_to :assay

  acts_as_folder_linked :project, :under =>'experiments'

 
  # ## The experiment is a summary of the tasks
  # 
  acts_as_scheduled  :summary=>:tasks

  has_many_scheduled :tasks,  :class_name=>'Task',:foreign_key =>'experiment_id',:dependent => :destroy
  has_many_scheduled :queue_items,  :class_name=>'QueueItem',:dependent => :nullify,:foreign_key =>'experiment_id'

  belongs_to :project
  #
  ## Stats view of whats happened in the experiment
  #
  has_many :stats, :class_name => "ExperimentStatistics"
  #
  ## Experiments is carried out in the scope of a  assay
  #
  belongs_to :assay
  ## Current default process
  #
  #  @todo replace with a method based on the assay/workflow
  #
  belongs_to :process, :class_name =>'ProtocolVersion', :foreign_key=>'protocol_version_id'

  # 
  # validation rules
  #
  validates_uniqueness_of :name
  
  validates_presence_of   :name,:case_sensitive=>false
  validates_presence_of   :description
  validates_presence_of   :assay_id
  validates_presence_of   :protocol_version_id
  validates_presence_of   :project_id

  validates_associated :assay
  validates_associated :process
  validates_associated :project
  validates_associated :project_element

  validates_presence_of   :started_at
  validates_presence_of   :expected_at

  validates_format_of :name, :with => /^[A-Z,a-z,0-9,_,\.,\-,+,\$,\&, ,:,#,\/]*$/,
    :message => 'name only accept a limited range of characters [A-z,0-9,_,.,$,&,+,-, ,#,@,:]'
  
  def validate
    validate_period
  end
  # 
  # @todo remove with time once refrences gone
  # 
  def default_process
    if has_workflow?
      return process.steps[0].process
    else
      return process 
    end
  end
  
  def has_workflow?
    return process.is_a?(ProcessFlow)    
  end

  # ## Protocol this is linked to
  # 
  # @TODO workflow for 3.0
  # 
  # The experiment can be created based on a process flow. If this is present
  # then the system should create a list of task to match to definited flowe
  # 
  # #belongs_to :process_flow, :class_name =>'ProcessFlow',
  # :foreign_key=>'process_flow_id'
  # 
  # make sure project and team are set
  # 
  before_create :set_default_project_and_team

  def set_default_project_and_team
    self.project ||= Project.current          
    self.team ||= Team.current
  end

  # 
  # After create copy all the element from the process folder to the task folder
  # 
 after_create :after_create_move_template_element
 
  def  after_create_move_template_element
    return if Biorails::Dba.importing?
    after_create_generate_folder
    if !process.multistep?
      logger.info "Folder Content ignored for single step process or importing"
    else
       link_to_process_folder
    end
  end
  # 
  # add links to process folder to pick up defaults
  # 
  def link_to_process_folder
      self.process.folder.elements.each do |element|
        self.folder.copy(element)
      end
  end
  # 
  # Constructor uses current values for User,project and team in creation of a
  # new Experimtn These can be overiden as parameters (:user_id=> ,:project_id
  # => , team_id => )
  # 
  def initialize(options = {})
    super(options)
    Identifier.fill_defaults(self)
  end   
  # ## first task to start in the experiment
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
  # ## last task to end in the experiment
  # 
  def last_task
    if tasks.size>0 
      self.tasks.max{|i,j|i.started_at <=> j.started_at}
    end 
  end 
  #
  # Check allowed to process data
  #
  def start_processing
    return false if self.active? or self.finished?
    new_state = self.folder.state_flow.next_level(self.state)
    self.folder.set_state(new_state,false)
  end
  # ## Get the named experiment from the list attrached to the assay
  # 
  def task(name)
    return self.tasks.find_by_name(name)
  end
  # ## Get summary stats to compare task with all runs in the assay. This shows
  # TaskStatistics with extra linked values at the assay level.
  # 
  def statistics
    sql = <<SQL
	select 
	  s1.experiment_id
	 ,s1.assay_parameter_id
	 ,s1.parameter_type_id
	 ,s1.parameter_role_id
	 ,s1.data_type_id
	 ,s1.avg_values
	 ,s1.stddev_values
	 ,s1.num_values
	 ,s1.num_unique
	 ,s1.min_values
	 ,s1.max_values
	 ,s2.avg_values avg_assay
	 ,s2.stddev_values stddev_assay
	 ,s2.num_values num_assay
	 ,s2.min_values min_assay
	 ,s2.max_values max_assay
	from experiments e, experiment_statistics s1, assay_statistics s2
	where e.id = s1.experiment_id
	and   e.id = ?
	and   e.assay_id = s2.assay_id
	and   s1.assay_parameter_id = s2.id
	and   s1.data_type_id = s2.data_type_id
SQL
    ExperimentStatistics.find_by_sql([sql,self.id])
  end
 
  # ## Period of time for a experiment (default == 1 week)
  # 
  def period
    if tasks.size>0
      return last_task.finished_at - first_task.started_at 
    else
      return 1.week
    end   
  end  
  # 
  # @TODO workflow
  # 
  #  Run should create a set of task to match the passed process flow.
  #  This is set as the experiments current process_flow and the tasks
  #  are appended to the the current task list. This should allow a
  #  experiment to add multiple flows in advanced cases.
  # 
  def run(flow=nil,start=nil)
    Task.transaction do
      flow  ||= self.process
      start ||= [Time.now,self.started_at].max
      unless flow.multistep?
        
        task = add_task(:name => flow.name, :protocol_version_id=>flow.id);
        task.description = flow.description
        task.expected_hours = flow.expected_hours
        task.started_at =  (start )
        task.expected_at = (start + flow.expected_hours.hours  )
        self.tasks << task
        task.save!
      else       
        for step in flow.steps
          if step.process.multistep? and step != self.process
            self.run(step.process,start) 
          else
            task = add_task(:name => step.name,  :protocol_version_id=>step.protocol_version_id);
            task.description = step.description
            task.done_hours = 0
            task.started_at =  (start + step.start_offset_hours.hours )
            task.expected_at = (start + step.end_offset_hours.hours  )
            task.expected_hours = step.expected_hours
            self.tasks << task
            task.save!
          end
        end
      end   
    end
  end
  # ## Copy the experiment and create a new persistent copy
  # 
  def copy(name = nil, start = nil)
    start ||= Time.now
    finish = start + (self.expected_at - self.started_at)
    expt = Experiment.new(  :started_at => start, :expected_at=> finish)
    expt.name = name || Identifier.next_user_ref
    expt.description = self.description
    expt.assay = self.assay
    expt.project = self.project
    expt.process = self.process
    # expt.process_flow self.process_flow

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
 
  # ## create a new task in the experiment
  # 
  def add_task( options = {})
    task = Task.new(options)
    task.experiment = self
    task.process  ||= self.default_process
    task.project  = self.project
    task.started_at  =  [Time.now,self.started_at].max
    task.expected_at = (task.started_at + task.process.expected_hours.hours  )
    task.done_hours  = 0
    task.description ||="A run of #{self.process.description}"
    task.assigned_to_user_id = User.current.id
    logger.info "New Task[#{task.id}] is #{task.name}"
    return task
  end

  # ## Import file into the task
  # 
  # first Task   assay,experiment,task,status note   description Header label
  # [name,] Data   row    [value,]
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
      when 'start'
        @task = nil
         
      when 'task' 
        @task = read_task(row)
        logger.info  "Line[#{@line}] starting task #{@task.name}"
       
      when 'context'  
        @definition = read_context(@task,row) 
           
      when 'values' 
        @context = read_values(@task,@definition,row) 
           
      when 'end'
        logger.info "Saved task #{@task.name}"
          
      else # url etc
        logger.info "Line[#{@line}] Skipped "+row.join(',')
      end
    end
    return @task
  end

  def to_liquid
    ExperimentDrop.new self
  end 

  
  protected

  # ############################################################################
  # Read the task line to work out what we are expecting row[0] row[1]  task.id
  # row[2]  task.name row[3]  task.status row[4]  experiment.name row[5]
  # protocol.name row[6]  assay.name row[7]  protocol.versionMS
  # 
  # ############################################################################
  def read_task(row)
    logger.info "Creating task "+row[2].to_s
    task = nil
    # ## Get the linked task to import
    # 
    if row[1].nil? or row[1].empty?
      task = self.add_task 
      task.name   = row[2] if row[2]     
      task.description = "Data Import from file" 
      task.process =nil
      task.protocol = AssayProcess.find_by_name(row[5]) 
      if task.protocol and row[7]
        task.process = task.protocol.version(row[7])
        logger.info "reset process " + task.name  
      end      
    else
      logger.info " Importing over existing Task["+row[1]+"]"
      task = Task.find(row[1])   
    end  
    #task.status = row[3] if row[3]
    task.experiment ||= self
    task.assigned_to ||= User.current


    # ## Create a modifiable version of the protocol if needed
    # 
    if @dynamic and task.process.tasks.size >1
      task.process = task.make_flexible 
      logger.info "editable process for " + task.name   
    end

    unless task.valid?
      raise "Failed to create task ["+name+"] Errors:"+task.errors.full_messages().to_sentence            
    end
    unless task.name == row[2]
      raise "Failed to import task ["+name+"] passed task name #{row[2]} does not match database [#{task.name}] "                
    end
    if row[4] and self.name != row[4]
      raise "Failed to import task ["+name+"] passed experiment name #{row[4]} does not match database [#{self.name}]"                
    end
    if row[5] and task.protocol_name != row[5] 
      raise "Failed to import task ["+name+"] passed protocol name #{row[5]} does not match database [#{task.protocol_name}] "                
    end
    task.save
    return task      
  end
  
  # ############################################################################
  # Read the task line to work out what we are expecting row[0]  "task" row
  # label row[1]  parameter_context.label row[2]  label row[3..n] parameter.name
  # values
  # ############################################################################
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
    @extras= @extras.compact
     
    for name in @extras
      if task.flexible?
        definition.add_parameter(name)
        logger.info "Added Parameter #{name}"
      else
        logger.info "Extra Parameter #{name} ignored"
      end          
    end     
    return definition
     
  rescue  Exception => ex
    logger.error ex.message
    logger.debug ex.backtrace.join("\n") 
    logger.info "Rejected: #{row.join(',')}"
    task.errors.add_to_base  " Line [" + @line.to_s + "] failed to read context: " + ex.message
  end
  
  # ############################################################################
  # Read the task line to work out what we are expecting row[0]  "value" row
  # label row[1]  task_context.label row[2]  i row_no row[3..n]  task_item.value
  # values
  # ############################################################################

  def read_values(task,definition, row)
    label = row[1].to_s
    row_no = row[2].to_i
    item = nil
    context = task.context(label)
    col=0
    if context and context.valid?
      TaskContext.current = context
      TaskContext.current.lock!
      for parameter in context.parameters
        value = row[col+3]
        logger.info "TaskItem[#{label},#{col}] #{parameter.name} = #{value}"
        ret = context.set_value(parameter,value)
        if ret[:errors]
             task.errors.add_to_base("row #{row_no} not saved #{ret[:error]} on cell [#{label}][#{parameter.name}]=#{value} ")
        end
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
    task.errors.add_to_base(" file line [" + @line.to_s + "] import failed: " + ex.message)
  end

  def to_html_cached?
    (respond_to?(:project_element) and respond_to?(:updated_at)  and project_element and 
       (project_element.content and self.updated_at <= project_element.content.updated_at
       ) and not 
       (self.tasks.exists?(['updated_at > ?',project_element.content.updated_at])  
       )
    )
  end   
end
