# == Schema Information
# Schema version: 359
#
# Table name: state_changes
#
#  id                 :integer(4)      not null, primary key
#  old_state_id       :integer(4)      not null
#  new_state_id       :integer(4)      not null
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  flow               :string(30)      default("default")
#

class StateChange < ActiveRecord::Base
#
# This represents a from=>to state change
#
  belongs_to :from, :foreign_key => "old_state_id",:class_name=>'State'
  belongs_to :to,   :foreign_key => "new_state_id",:class_name=>'State'
#
# Changes are grouped together into a state flow
#
  belongs_to :state_flow,:foreign_key => "state_flow_id",:class_name=>'StateFlow'
   
  def name
    self.to.name
  end
  
  def to_s
    "#{self.flow}: #{self.from.name}=>#{self.to.name}"
  end
  
end
