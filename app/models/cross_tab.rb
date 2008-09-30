# == Schema Information
# Schema version: 359
#
# Table name: cross_tabs
#
#  id                 :integer(4)      not null, primary key
#  project_id         :integer(4)      not null
#  name               :string(64)      not null
#  description        :string(255)     not null
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime
#  created_by_user_id :integer(4)      default(1), not null
#  updated_at         :datetime
#  updated_by_user_id :integer(4)      default(1), not null
#  project_element_id :integer(4)
#

# == Description
# Master object of ruleset for generation of a Cross Tab sytle report.This manages the rules for 
# taskContext v.s. Parameters table of results. The cross tab is built of a collection of 
# columns based on parameters and filters. 
#  
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 

class CrossTab < ActiveRecord::Base
  attr_accessor :team_id  # historic field now removed, kept here so old fixtures can be reloaded as needed

  cattr_reader :per_page
  @@per_page = 20
  # The cross tab is development as part of project it will be based primary on
  # assays linked into the project
  # 
  belongs_to :project
  #
  # Owner project
  #  
   acts_as_folder_linked  :project, :under =>'cross_tabs'
  #
  # Filters
  #
  attr_accessor :use_live
  #
  # Mask based filter for tasks to select
  #
  attr_accessor :task_mask
  #
  # Start of selected data range
  #
  attr_accessor :date_from
  #
  # End of selected data range
  #
  attr_accessor :date_to
  #
  # Estimate number of rows
  #
  attr_accessor :esitmated_rows
  #
  # Estimate of number of tasks selected
  #
  attr_accessor :esitmated_tasks
  
  # 
  # The CrossTab has a number of columns each based on a assay parameter
  # 
  # create new columns.add(parameter) method to automatically create 
  # columns for parameters with renaming if needed
  # 
  has_many :columns ,:class_name=>'CrossTabColumn',
    :include => [:parameter_type=>[],:assay_parameter=>[], :parameter=>[:context=>[:process]]],
    :order =>'protocol_versions.name,parameter_contexts.label,parameters.name'    
  
  # 
  # There is a set of filters applied to a cross tab
  # 
  has_many :filters, :class_name=>'CrossTabFilter', :dependent => :delete_all do
    #
    # Select filtering using the passed scope object
    #
    def using(scope)
      case scope
      when ParameterContext
         find(:all,:include=>[:column=>[:parameter]],:conditions=>['parameters.parameter_context_id=?',scope.id])
      when Parameter
         find(:all,:include=>[:column=>[:parameter]],:conditions=>['parameters.id=?',scope.id])
      when :global   
         find(:all,:conditions=>'cross_tab_column_id is null')
      else
         find(:all)
      end
    end
    #
    # Add a filter to the current set
    #
    def add(column,operator,value)    
      new_item = build( :filter_op =>operator,
                        :filter_text => value,
                        :cross_tab_column_id => (column ? column.id : nil))  
      new_item.save
      return new_item
    end
  end    

  # 
  # There is a set of filters applied to a cross tab
  # 
  has_many :joins, :class_name=>'CrossTabJoin', :dependent => :delete_all do
    #
    # Find a specific link
    #
    def link(from,to)
      find(:first,:conditions=>{:from_parameter_context_id=>from.id,:to_parameter_context_id=>to.id})
    end
    #
    # Find/Create a reference join rule
    #
    def as_reference(from,to)
      item = find(:first,:conditions=>{:from_parameter_id=>from.id,:to_parameter_id=>to.id})
      item ||= create(:join_rule=>'ref',
                          :from_parameter_id=>from.id,
                          :to_parameter_id=>to.id,
                          :from_parameter_context_id=>from.parameter_context_id,
                          :to_parameter_context_id=>to.parameter_context_id)
      return item
    end 
    #
    # Find/Create a parent join rule
    #
    def as_parent(from,to)
      item = find(:first,:conditions=>{:from_parameter_context_id=>from.id,:to_parameter_context_id=>to.id})
      item ||= create(:join_rule=>'parent',:from_parameter_context_id=>from.id,:to_parameter_context_id=>to.id)
      return item
    end  
    
    #
    # Find/Create a child join rule
    #
    def as_child(to,from)             
      item =  find(:first,:conditions=>{:from_parameter_context_id=>from.id,:to_parameter_context_id=>to.id})
      item ||= create(:join_rule=>'child',:from_parameter_context_id=>from.id,:to_parameter_context_id=>to.id)
      return item
    end
  end    
    
  acts_as_dictionary :name
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description  
  #
  # Initialize the object and make sure its owned
  #
  def initialize(options={})
    super(options)
    Identifier.fill_defaults(self)    
    self.use_live = true
    self.project_id = options[:project_id] ||Project.current.id          
    self.team_id = options[:team_id] ||Team.current.id   
  end
  # 
  # make sure project and team are set
  # 
  def before_create 
    self.project_id ||= Project.current.id          
    self.team_id ||= Team.current.id
  end
  #
  # get the base context type for the cross tab
  #
  def base_context    
    @context ||= self.columns[0].parameter_context if self.columns[0]
  end
  #
  # List all contexts used as part of the query
  #
  def contexts
    @contexts ||= self.columns.collect{|c|c.parameter.context}.uniq
  end
  #
  # Guess the type of link betweeh to parameter contexts for ui
  #
  def guess_link_type(slave,master=nil)
    master ||= base_context    
    link =  :none
    return link unless slave and master
    if master.id == slave.id
       link =  :root 
    elsif master.protocol_version_id == slave.protocol_version_id
       link = self.joins.as_child(master,slave) if slave.ancestors.any?{|a|a.id==master.id}
       link = self.joins.as_parent(master,slave) if master.ancestors.any?{|a|a.id==slave.id}
       link ||= :pier
    else  
      # reference
      from = master.parameters.find(:first, :conditions=>["parameters.data_element_id in (select distinct data_element_id from parameters p2 where p2.parameter_context_id=?)",slave.id])       
      unless from.nil?    
         to = slave.parameters.find(:first,  :conditions=>["parameters.data_element_id in (select distinct data_element_id from parameters p2 where p2.parameter_context_id=?)",master.id])       
         link = self.joins.as_reference(from,to)
      end 
    end    
    return link
  rescue
    return nil    
  end  

  #
  # Add a single column 
  #
  def add(parameter)        
      @contexts=nil
      new_item = self.columns.build(:name =>parameter.name,
        :parameter_id=>parameter.id,
        :parameter_type_id=>parameter.parameter_type_id,
        :assay_parameter_id=>parameter.assay_parameter.id)
      sequence_num =0
      while self.columns.find(:first, 
        :conditions => ["cross_tab_columns.cross_tab_id=? and cross_tab_columns.name=?", new_item.cross_tab_id, new_item.name])
        sequence_num +=1
        new_item.name = "#{parameter.name}_#{sequence_num}"              
      end
      new_item.save
      guess_link_type(parameter.context)      
      return new_item
    end
  # 
  # Add columns related to the passed item @para, item is a Parameter,
  # AssayParameter, ProtocolVersion, ParameterContext
  # 
  def add_columns(item)
    ret = true
    logger.warn("add #{item.class} #{item.to_s}")
    case item
    when Parameter
      column = self.add(item)
      unless column.save
         logger.warn column.errors.full_messages().join('\n')
         errors.add_to_base("add parameter #{item.name} ")
         ret =false
      end          
          
    when ProtocolVersion,ProcessInstance,ParameterContext
      item.parameters.each do |parameter|
        column =  self.add(parameter)
        unless column.save
           logger.warn column.errors.full_messages().join('\n')
           errors.add("add parameter #{item.name}  ")
           ret = false
        end          
      end
    else
      errors.add("cant add #{item.class} as not a support type ")
      ret = false    
    end
    return ret
  end
  #
  # Add a filter rule set
  #  
  def filter(params)
    self.filters.clear
    if params[:cross_tab]
      self.date_from = params[:cross_tab][:date_from]
      self.date_to   = params[:cross_tab][:date_to]
    end
    rules = params[:filters]
    if rules
        rules.each do |key,rule|
          column = columns.find(key)      
          operator = rule["operator"]
          value = rule["value"]
          if operator and value and operator.size>0
            self.filters.add(column, operator, value)
          end
        end
    end
    return columns
  end 
  # 
  # Context a node to objects
  # 
  # This is used for convertopn of dom_id to the correct object
  # 
  def self.convert_node(node)
    ModelExtras.from_dom_id(node)
  end
  #
  # Convert to SQL date
  #
  def to_sql_date(value)
    case value
    when String
      "to_date('#{value}','YYYY-MM-DD')"
    when Date
      value =value.strftime("%Y-%m-%d")
      "to_date('#{value}','YYYY-MM-DD')"
    end      
  end
  #
  # Conditions as a exists filter
  #
  def conditions
    return "1=0" unless columns.size>0
    ids = contexts.collect{|c|"'#{c.id}'"}.join(',')
    cond = "task_contexts.parameter_context_id in (#{ids})"
    if date_from.is_a?(Date)
      cond << "and tasks.updated_at >= #{to_sql_date(date_from)} "
    end
    if date_to.is_a?(Date)
      cond << "and tasks.updated_at <= #{to_sql_date(date_to)} "
    end
    if task_mask
      cond << "and tasks.name like '#{task_mask}%' "
    end
    cond_contexts =[]
    for context in self.contexts  
       item = " task_contexts.parameter_context_id = '#{context.id}' "
       self.filters.using(context).each do |filter|
             item << " and " + filter.exists_rule
       end
       cond_contexts << item
    end
    cond << "and ( (#{cond_contexts.join(') or (')})  )"
    logger.debug "conditions filters: #{cond}"
    return cond
  end
  # 
  # Estimated counts in terms of rows
  # 
  def estimated_rows(cache=true)
    return @estimated_tasks if (@estimated_tasks and cache)
    @estimated_rows = TaskContext.count(:include=>[:task],:conditions=>self.conditions)    
  end
  
  # 
  # Estimated counts in terms of tasks
  # 
  def estimated_tasks(cache=true)
    return @estimated_tasks if (@estimated_tasks and cache)
    @estimated_tasks = Task.count(:include=>[:contexts],:conditions=>self.conditions)    
  end

  #
  # Generate a results assay for the current cross tab. This paginated for performance 
  # reasons. With a default of 25 rows per page. This will include empty rows if
  # the task contexts are registered
  # 
  #
  def results(page=1,count = 25)
    WillPaginate::Collection.create(page, count, self.estimated_rows) do |pager|
      table =[]
      for row in self.task_contexts(page,count) 
        hash = {}
        hash[-2] = row.task.name
        hash[-1] =  row.label
        hash[0] = row.id
        for cell in row.items.values
          hash[cell.parameter_id] = cell.to_s
        end
        table << hash
      end
      pager.replace table
    end
  end
  # 
  # List of rows linked to this report
  # 
  def task_contexts(page=1,count = 25)
      
    TaskContext.paginate(:all,:order=>'tasks.name,task_contexts.left_limit,task_contexts.id asc',
      :include=>[:task,:values,:texts,:references],
      :conditions=>self.conditions,  
      :total_entries=>self.estimated_rows, :per_page=>count, :page=>page)    
  end
  #
  # Test if live?
  #
  def live?
    self.use_live 
  end
  # 
  # Get items linked to a node context to generate a tree roles -> types ->
  # ProtocolVersions -> ParameterContext types -> ProtocolVersions ->
  # ParameterContext assays -> ProtocolVersions -> ParameterContext protocols
  # -> ProtocolVersions -> ParameterContext AssayParamters-> ProtocolVersions ->
  # ParameterContext
  # 
  # used in generation of trees for reports
  # 
  def linked_items(object,scope=nil)  
    object = object.to_s if object.is_a?(Symbol)
    if live?
      linked_items_live(object,scope) 
    else
       linked_items_defined(object,scope) 
    end
  end

  protected

  def linked_items_defined(object,scope=nil)  
    case object
    when 'root'
      items = [{:id=>'roles',:text=>'roles'},{:id=>'types',:text=>'types'}, {:id=>'assays',:text=>'assays'},
        {:id=>'protocols',:text=>'protocols'}, {:id=>'parameters',:text=>'parameters'} ]
    when 'roles' then   items = ParameterRole.find(:all)
    when 'types' then   items = ParameterType.find(:all)
    when 'assays' then items = self.project.assays
    when 'protocols'
      items = AssayProtocol.find(:all, :include =>[:assay=>:project],:conditions=>['assays.project_id=?',project_id])    
    
    when 'processes','process'
      items = ProtocolVersion.find(:all,:include =>[:protocol=>[:assay]],:conditions=>['assays.project_id=?',project_id])
    
    when 'parameters'
      items = AssayParameter.find(:all,:include =>[:assay],:conditions=>['assays.project_id=?',project_id])
    
    when Project 
      items = Assay.find(:all,:conditions=>['assays.project_id=?',object.id])
      
    when Assay
      items = AssayProtocol.find(:all,:include=>[:assay=>:project], :conditions=>{:assay_id=> object.id})
      
    when AssayProtocol
      items = ProtocolVersion.find(:all,:conditions=>{:assay_protocol_id=> object.id})
       
    when AssayParameter
      items = ProtocolVersion.find(:all,
        :conditions=>[' exists ( select 1 from parameters where parameters.assay_parameter_id=? and parameters.protocol_version_id= protocol_versions.id )', 
          object.id] )
    
    when ProtocolVersion,ProcessInstance
      case scope
      when ParameterType  
        items = ParameterContext.find(:all,:conditions=>
            ['parameter_contexts.protocol_version_id= ? and exists (select 1 from parameters where parameters.parameter_context_id=parameter_contexts.id and parameters.parameter_type_id=?)',
            object.id, scope.id])
         
      when AssayParameter  
        items = ParameterContext.find(:all,:conditions=>
            ['parameter_contexts.protocol_version_id= ? and exists (select 1 from parameters where parameters.parameter_context_id=parameter_contexts.id and parameters.assay_parameter_id=?)',
            object.id,scope.id])
      else
        items = ParameterContext.find(:all,:conditions=>{:protocol_version_id=> object.id})
      end
    
    when ParameterType
      items = ProtocolVersion.find(:all,
        :conditions=>[' exists ( select 1 from parameters where parameters.parameter_type_id=? and parameters.protocol_version_id= protocol_versions.id )',
          object.id] )
    
    when ParameterRole
      items = ParameterType.find(:all,
        :conditions=>[' exists (select 1 from parameters where parameters.parameter_role_id=? and parameters.parameter_type_id=parameter_types.id)',
          object.id]) 
    
    when ParameterContext
      items = Parameter.find(:all,:include =>[:process=>[:protocol=>:assay]],
        :conditions=>['parameter_context_id=?',object.id])
    else
      logger.warn "Unhandled object #{object} in scope #{scope}"
      items = []
    end 
    logger.info "Level for #{object} in scope #{scope} has #{items.size} items"
    return items
  end
  # 
  # SQL quueries to get tree details limited to used parameters
  # 
  def linked_items_live(object,scope=nil)  
    case object
    when 'root'
      items = [{:id=>'roles',:text=>'roles'},{:id=>'types',:text=>'types'}, {:id=>'assays',:text=>'assays'},
        {:id=>'protocols',:text=>'protocols'}, {:id=>'parameters',:text=>'parameters'} ]
             
    when 'roles'   then   items = ParameterRole.find_all_used
    when 'types'   then   items = ParameterType.find_all_used
    when 'assays' then   items = self.project.assays
    when 'protocols'
      cond = <<SQL
       exists (select 1 from tasks,protocol_versions 
       where protocol_versions.id=tasks.protocol_version_id 
         and protocol_versions.assay_protocol_id=assay_protocols.id)
       and assays.project_id =?
SQL
      items = AssayProtocol.find(:all, :include =>[:assay=>:project], :conditions=>[cond,project_id] )    
    
    when 'processes','process'
      items = ProtocolVersion.find(:all,:include =>[:protocol=>:assay],
        :conditions=>['assays.project_id=? and exists (select  1 from tasks where tasks.protocol_version_id=protocol_versions.id)',project_id])
 
    when 'parameters'
      cond = <<SQL
       exists (select 1 from tasks,protocol_versions,parameters 
       where protocol_versions.id=tasks.protocol_version_id 
         and protocol_versions.id=parameters.protocol_version_id
         and parameters.assay_parameter_id=assay_parameters.id)
         and assays.project_id =?
SQL
      items = AssayParameter.find(:all,:include =>[:assay],:conditions=>[cond,project_id])
    
    when Project          then items = object.assays
    when Assay            then items = (live? ? object.protocols.live : object.protocols)
    when AssayProtocol    then items = object.versions.using(scope,live?)
    when AssayParameter   then  items = object.processes.using(scope,live?)     
    when ProtocolVersion,ProcessInstance then items =  object.contexts.using(scope,live?)    
    when ParameterType    then items = object.processes.using(scope,live?)
    when ParameterRole    then  items =  object.types
    when ParameterContext then items = object.parameters
    else
      logger.warn "Unhandled object #{object} in scope #{scope}"
      items = []
    end 
    logger.info "Level for #{object} in scope #{scope} has #{items.size} items"
    return items.uniq
  end

end
