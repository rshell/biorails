# == Schema Information
# Schema version: 359
#
# Table name: protocol_versions
#
#  id                 :integer(4)      not null, primary key
#  assay_protocol_id  :integer(4)
#  name               :string(77)
#  version            :integer(4)      not null
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime
#  updated_at         :datetime
#  how_to             :text
#  report_id          :integer(4)
#  analysis_method_id :integer(4)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  type               :string(255)     default("ProcessInstance")
#  expected_hours     :float           default(24.0), not null
#  status             :string(255)     default("new")
#  project_element_id :integer(4)
#  description        :string(255)
#

# == Description
#
# This is a implementation of a multiple simple procerss flow. Its is basically
# a delta time offset ordered list of stesp to perform
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ProcessFlow < ProtocolVersion
  @@log=Logger.new(STDOUT)
  
  attr_accessor :show_hours
  attr_accessor :show_days
  attr_accessor :show_weeks
  attr_accessor :scaler
#
# Is built of a series of steps order offset times
#  
  has_many :steps, 
           :class_name => 'ProcessStep',
           :dependent => :destroy, 
           :foreign_key=>'process_flow_id',
           :order =>'id'   
 #
 # dummy get parameters
 #
 def parameters
   []
 end
 #
 # dummy get contexts
 #
 def contexts
   []
 end
#
# List of usages of the workflow 
#
 def usages
   self.experiments || []
 end   
 
 def scaler
   return @scaler if @scaler
   if expected_days>7
     @scaler=24
   else
     @scaler=1
   end
 end
 
  def multistep?
    true
  end    

 def first_step_begins_hour
   self.steps.minimum(:start_offset_hours)||0
 end 

 def last_step_ends_hour
   self.steps.maximum(:end_offset_hours)||1
 end 
 
 def period
    @period ||= [self.last_step_ends_hour,self.expected_hours].max
 end  
 
 def expected_weeks
    [1,(self.period/168).ceil].max
 end  

 def expected_days
      [1,(self.period/24).ceil].max
 end  

##
# Test if this instance is used in any tasks
 def used?
    return self.experiments.size >0
 end 
#
# Has the workflow been used so by fixing the design
#
 def flexible?
   return (!used? and !released?)
 end

  def copy #make a copy of this process flow so that it can be linked into another process flow
    ProcessFlow.transaction do
      item = self.protocol.new_version
      self.steps.each do | step|
        new_step = item.add(step.process)
        new_step.name = step.name
        new_step.start_offset_hours = step.start_offset_hours
        new_step.end_offset_hours = step.end_offset_hours
        new_step.save
      end
      return item
    end
  end 
#
# Update flow to latest version of all process instances for step
#
  def modernize
    steps.each do |step|
      step.process = step.process.protocol.released
      step.save
    end
  end
  
  def add(process)
     step = ProcessStep.new
     step.process = process
     step.flow = self
     #step.step_no = self.next_step_no
     step.name = "S#{self.next_step_no}.#{process.protocol.name}"
     step.start_offset_hours = self.last_step_ends_hour
     step.end_offset_hours = step.start_offset_hours+process.expected_hours
     @period = nil
     self.steps << step
     step.resync_end_times
     unless step.save
       logger.error "Failed to add process #{process} "
       logger.warn step.errors.full_messages.to_sentence
     end  
     return step     
  end
   
   def summary
     "Workflow [#{self.path(:assay)}] #{self.steps.size} steps"
   end

  # 
  # Find the next version number to use
  #   
   def next_step_no
     return 1 if self.new_record?
     self.steps.size+1
     #ProcessStep.maximum(:step_no,:conditions=>["protocol_version_id = ?",self.id]) || 1
  end

  # 
  # Get linked items for a tree
  # 
  def linked_items(object)  
    items = []
    case object
    when 'root'
      items = Team.find(:all)
    when Project
      items = object.linked_assays
    when Team
      items = Assay.list(:all, :include=>[:project],:conditions=>['projects.team_id=?',object.id])
    when Assay     
      items = ProtocolVersion.find(:all,
              :include=>[:protocol],
              :conditions=>['protocol_versions.status=? and assay_protocols.assay_id=?','released',object.id])
      
    when AssayProtocol
      items = AssayProtocol.find(:all,:conditions=> <<SQL
assay_protocols.assay_id = #{object.id}
and exists (select 1 from protocol_versions 
                where assay_protocols.id=protocol_versions.assay_protocol_id 
                  and protocol_versions.status='released')  
SQL
)
    else
      logger.warn "Unhandled object #{object} "
      items = []
    end 
    logger.info "Level for #{object} in  has #{items.size} items"
    return items
  end
  
  def to_liquid
    ProcessFlowDrop.new self
  end

   def to_xml(options = {})
     Alces::XmlSerializer.new(self, options.merge( {:include=> [:steps]} )  ).to_s
   end

end
