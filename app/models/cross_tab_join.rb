class CrossTabJoin < ActiveRecord::Base
  belongs_to :cross_tab, :class_name=>'CrossTab'  
  belongs_to :from,     :foreign_key=>'from_parameter_id',:class_name=>'Parameter'
  belongs_to :to,       :foreign_key=>'to_parameter_id',:class_name=>'Parameter'
  belongs_to :source,   :foreign_key=>'from_parameter_context_id',:class_name=>'ParameterContext'
  belongs_to :dest,     :foreign_key=>'to_parameter_context_id',:class_name=>'ParameterContext'

  validates_presence_of :cross_tab_id  
  validates_presence_of :from_parameter_context_id  
  validates_presence_of :to_parameter_context_id  

  # operator
  # ref: Linked via reference
  # child: is child of
  
  def to_s
    case join_rule.to_s
    when 'parent'
      return "parent of #{source.label} "
    when 'child'
      return "child of #{source.label} "
    when 'ref'
      return "reference #{source.label} => #{dest.label}"
    else
      return join_rule.to_s
    end
  end
end
