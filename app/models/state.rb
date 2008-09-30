# == Schema Information
# Schema version: 359
#
# Table name: states
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)     not null
#  description        :string(255)     not null
#  is_default         :boolean(1)
#  position           :integer(4)      default(0), not null
#  level_no           :integer(4)      default(0), not null
#  scope              :string(255)     default("default"), not null
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

#
# The State are used to represent states of a item in a workflow
#
# * A State apply to to a project element
# * Each user defined state is linked to system defined level to band the work
# * level band represent new-»active » completed » published
# * Only certain state changes are allowed
# * The allowed state change are linked to the model linked to the project element
# 
#
class State < ActiveRecord::Base
  FLOWS = ['default','assay','experiment','content','task','project']

  LEVELS = { -1  =>'aborted' ,
              0 => 'new',
              1=>'pending' ,
              2=> 'active' ,
              3 => 'done',
              4 => 'published' }
  DEFAULT_FLOW='default'

  ERROR_LEVEL   = -1
  ACTIVE_LEVEL  = 1
  FROZEN_LEVEL  = 3
  PUBLIC_LEVEL  = 4

  before_destroy :check_not_in_use  
  #
  # List of allowed transfers
  #
  has_many :flows, :foreign_key => "old_state_id",:class_name=>'StateChange', :dependent => :delete_all 
    
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 30
  validates_format_of :name, :with => /^[\w\s\'\-]*$/i
  #
  # If making this the default active item set all other to false
  #
  def before_save
    State.update_all "is_default=#{connection.quoted_false}" if self.is_default?
  end  
  #
  # List of labeled flow name scopes for changes
  #
  def self.labels
    FLOWS
  end
  
  def customized?(flow)
    flows.find(:first,:conditions=>['flow=?',flow])
  end
  
  def next_states(label=DEFAULT_FLOW)
     list = flows.find(:all,:include=>[:to],:conditions=>['flow = ?',label.to_s]).collect{|i|i.to}     
     list = flows.find(:all,:include=>[:to],:conditions=>['flow = ?',DEFAULT_FLOW]).collect{|i|i.to} if list.size==0  
     list     
  end
  #
  # Update all state based on a passed hash structure
  #
  def self.set_flow(states,label=DEFAULT_FLOW)
    StateChange.transaction do
      all = State.find(:all)
      keys = all.collect{|i|i.id}
      for item in all
        enabled = states[item.id] || states[item.id.to_s] || []
        enabled = enabled.collect{|i|i.to_i}
        disabled = keys - enabled
        puts "update #{item.name} => on #{enabled.join(',')} off #{disabled.join(',')}"
        enabled.each{ |i|item.enable(i,label)}
        disabled.each{|i|item.disable(i,label)}
      end
    end
  end
  #
  # Get a hash of allowed state changes 
  #
  def self.get_flow(label=DEFAULT_FLOW)
    items ={}
    for t in  StateChange.find(:all,:conditions=>['flow=?',label.to_s],:order=>'old_state_id,new_state_id')
      items[t.old_state_id] ||=[t.old_state_id]
      items[t.old_state_id] << t.new_state_id      
    end
    return items
  end
  
  #
  # See if a state change is allowed
  #
  def self.allow?(from,to,label=DEFAULT_FLOW)
     from = get(from)   
     to = get(to)
     return true if (from == to)
     from.flows.find(:first,:conditions=>['new_state_id=? and flow=? ',to.id,label])          
  end
  #
  # See if a state change is allowed
  #
  def allow?(other,label=DEFAULT_FLOW)
    return State.allow?(self,other,label)
  end

  #
  # Set a allowed chnage
  #
  def self.enable(from,to,label=DEFAULT_FLOW)
     from = get(from)   
     to = get(to)
     return false unless from and to 
     return true if allow?(from,to,label)     
     from.flows.create(:new_state_id=>to.id,:flow=>label.to_s)
  end
  #
  # Set a allowed chnage
  #
  def enable(other,label=DEFAULT_FLOW)   
    return State.enable(self,other,label)
  end
  #
  # Set state change to disallowed
  #
  def self.disable(from,to,label=DEFAULT_FLOW)
     from = get(from)   
     to = get(to)
     change = State.allow?(from,to,label)    
     return true unless change
     change.destroy if change.is_a?(ActiveRecord::Base)
  end
  #
  # Set state change to disallowed
  #
  def disable(other,label=DEFAULT_FLOW)   
    return State.disable(self,other,label)
  end
  
  def allowed(label=DEFAULT_FLOW)
    self.flows.find(:all,:include=>[:next],:conditions=>['flow=?',label.to_s]).collect{|i|[i.next.name,i.next.id]}
  end
  #
  # Is failed with a negative level
  #
  def failed?
    self.level_no <= ERROR_LEVEL
  end
  #
  # Active 1-3
  #
  def active?
    self.level_no >= ACTIVE_LEVEL and self.level_no <= FROZEN_LEVEL
  end
  #
  # Completed 4+
  #
  def completed?
    self.level_no >= FROZEN_LEVEL
  end

  def published?
    self.level_no >= PUBLIC_LEVEL
  end
  #
  # level is a reserved word with some databases to saved field is level_no
  #
  def level
    self.level_no
  end

  def level=(value)
    self.level_no = value
  end

  #
  # Get hte level text for display
  #
  def level_text
    LEVELS[self.level_no]
  end
  #
  # Order the states
  #
  def <=>(status)
    position <=> status.position
  end
  #
  # Name of the state is used as the string representation
  #
  def to_s; name end
  #
  # Is there a task linked to this status
  #
  def in_use?
    ProjectElement.exists?(["state_id=?", self.id])
  end
  
private
  def check_not_in_use
    raise "Can't delete status" if in_use?
  end
  
  def self.get(item)
     case item 
     when String then State.find_by_name(item)
     when State  then item 
     when ActiveRecord::Base then   item.state
     else
         State.find(item)
     end   
  end

end
