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
  FLOWS  = ['default','assay','experiment','content','task','project']

  LEVELS = { -1  =>'ignored' ,
              0 => 'new',
              1=>'pending' ,
              2=> 'active' ,
              3 => 'done',
              4 => 'published' }
  DEFAULT_FLOW ='default'

  ERROR_LEVEL   = -1
  ACTIVE_LEVEL  = 1
  FROZEN_LEVEL  = 3
  PUBLIC_LEVEL  = 4

  before_destroy :check_not_in_use

  has_many :next_states,     :foreign_key=>'new_state_id', :class_name => 'StateChange'
  has_many :previous_states, :foreign_key=>'old_state_id', :class_name => 'StateChange'

  validates_presence_of :name
  validates_uniqueness_of :name,:case_sensitive=>false
  validates_length_of :name, :maximum => 30
  validates_format_of :name, :with => /^[\w\s\'\-]*$/i
  #
  # If making this the default active item set all other to false
  #
  def before_save
    State.update_all "is_default=#{connection.quoted_false}" if self.is_default?
  end  
 
  def self.flows
    StateFlow.find(:all)
  end

  def self.states
    State.find(:all)
  end
  #
  # Is failed with a negative level
  #
  def ignore?
    self.level_no <= ERROR_LEVEL
  end
  #
  # is the level editible
  #
  def editable?
    self.level_no > ERROR_LEVEL and self.level_no < FROZEN_LEVEL
  end
  #
  # Active 1-3
  #
  def active?
    self.level_no >= ACTIVE_LEVEL and self.level_no < FROZEN_LEVEL
  end
  #
  # Completed 4+
  #
  def completed?
    self.level_no >= FROZEN_LEVEL
  end
  #
  # is the item finished
  #
  def finished?
    self.published? or self.ignore?
  end
  #
  # is the item published
  #
  def published?
    self.level_no >= PUBLIC_LEVEL
  end
  #
  # level is a reserved word with some databases to saved field is level_no
  #
  def level
    self.level_no
  end

  def signed?
    self.level_no == PUBLIC_LEVEL
  end

  def level=(value)
    self.level_no = value
  end
  #
  # Get the level text for display
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
  def to_s
    "<span class='state-level#{level_no}'>#{name}</span>"
  end
  #
  # Is there a task linked to this status
  #
  def in_use?
    ProjectElement.exists?(["state_id=?", self.id])
  end
  #
  def self.get(key)
    item = nil
    begin
       case item
       when String then
         item = State.find_by_name(key)
       when State
         return key
       when ActiveRecord::Base
         item = key.state if key.respond_to?(:state)
       else
         item = State.find(key)
       end
      item ||= State.find(:first)
    rescue
      item =nil
    end
    item ||= State.find(:first)
  end
  
private
  def check_not_in_use
    raise "Can't delete status" if in_use?
  end
  

end
