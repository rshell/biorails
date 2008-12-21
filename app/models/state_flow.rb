class StateFlow < ActiveRecord::Base
  acts_as_dictionary :name
##
# This record has a full audit log created for changes
#
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present

  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name,:case_sensitive=>false


  has_many :project_types
  has_many :state_changes, :order=>'old_state_id,new_state_id'

  def states
    State.find(:all)
  end
#
# Test Whether this is in used in the database
#  
  def used?
    return (project_types.size > 0)
  end
  #
  # See if a state change is allowed
  #
  def allow?(from,to)
     return false unless from and to
     from = State.get(from)
     to = State.get(to)
     return true if (from == to)
     state_changes.find(:first,:conditions=>['new_state_id=? and old_state_id=? ',to.id,from.id])
  end
  #
  # Apply check to self and all children
  #
  def allowed_state_change?(root,to)
     return false unless root and to
     return true if root == to
     to = State.get(to)
     unless allow?(root.state,to)
        logger.debug "root #{root.path} cant change from  #{root.state} to #{to}"
        return false
     end
     if to.check_children?
       root.all_children.each do |item|
         unless item.state.ignore? or allow?(item.state,to)
           logger.debug "Child #{item.path} failed state check #{item.state} to #{to}"
           root.errors.add(:state,"Child #{item.path} cant change state from #{item.state} to #{to}")
           return false
         end
       end
     end
     return true
  end
  #
  # Set a allowed chnage
  #
  def enable(from,to)
     return false unless from and to
     from = State.get(from)
     to = State.get(to)
     return true if allow?(from,to)
     state_changes.create(:new_state_id=>to.id,:old_state_id=>from.id,:state_flow_id=>self.id,:flow=>name)
  end

  #
  # Set state change to disallowed
  #
  def disable(from,to)
     return false unless from and to
     from = State.get(from)
     to = State.get(to)
     change = allow?(from,to)
     return true unless change
     change.destroy if change.is_a?(ActiveRecord::Base)
  end

  #
  # Update all state based on a passed hash structure
  #
  def set_flow(states)
    StateChange.transaction do
      all = State.find(:all)
      keys = all.collect{|i|i.id}
      for item in all
        enabled = states[item.id] || states[item.id.to_s] || []
        enabled = enabled.collect{|i|i.to_i}
        disabled = keys - enabled

        enabled.each{ |i|enable(item,i)}
        disabled.each{|i|disable(item,i)}
      end
    end
  end
  #
  # Get a hash of allowed state changes
  #
  def get_flow
    items ={}
    for t in  state_changes
      items[t.old_state_id] ||=[t.old_state_id]
      items[t.old_state_id] << t.new_state_id
    end
    return items
  end

  def next_states(state_id)
    list = self.state_changes.find(:all,:include=>[:to],:conditions=>{:old_state_id=>state_id})
    list = list.collect{|i|i.to}.compact
    list << State.get(state_id)
  end

  #
  # Find the next state of a set level
  #
  def next_level(state_id)
     from = State.get(state_id)
     State.find(:first, :include=>[:next_states],
       :order =>'states.level_no asc,new_state_id asc',
       :conditions=>['state_flow_id=? and old_state_id=? and new_state_id>old_state_id and states.level_no>?',self.id,from.id,from.level_no])
  end
  #
  # Find the previous state of a set level
  #
  def previous_level(state_id)
     from = State.get(state_id)
     return unless from
     State.find(:first, :include=>[:previous_states],
       :order =>'states.level_no desc,new_state_id desc',
       :conditions=>['state_flow_id=? and old_state_id=? and new_state_id<old_state_id and states.level_no< ? ',self.id, from.id, from.level_no])
  end
  #
  # Find the previous states to current
  #
  def previous_states(state_id)
    self.state_changes.find(:all,:include=>[:from],:conditions=>{:new_state_id=>state_id}).collect{|i|i.from}.compact
  end
  #
  # Get or create a default workflow
  #
  def self.default
    state = StateFlow.find(:first,:order=>:id)
    state ||= StateFlow.create(:name=>'default',:description=>'default')
  end

end
