#
# This is used to allow central IT departments better controll over the usage of parameter type in the system
# The alias represents a template for the usage of parameter_type as a assay parameter. In the alias the 
# name, description default unit, data format or data element can be specificed. 
#
# At the parameter type level the alias list can be declared as fixed, default or open.
# 
#
class ParameterTypeAlias < ActiveRecord::Base
  acts_as_dictionary :name 
  # 
  # Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :parameter_type_id

  validates_uniqueness_of :name, :scope => [:parameter_type_id]
  validates_format_of :name, :with => /^[A-Z,a-z,0-9,_]*$/, :message => 'name is must be alphanumeric eg. [A-z,0-9,_]'


  # ## This record has a full audit log created for changes
  # 
  acts_as_audited :change_log

  belongs_to :parameter_type,   :class_name =>'ParameterType', :foreign_key=>'parameter_type_id'
  belongs_to :parameter_role,    :class_name =>'ParameterRole', :foreign_key=>'parameter_role_id'
  belongs_to :data_format
  belongs_to :data_element
  
  # 
  # Get the data type to a alias can be easily used in place of a parameter tyep
  # 
  def data_type
    parameter_type.data_type if parameter_type
  end
  # 
  # The the parameter type this alias belongs too
  # 
  def type
    self.parameter_type
  end
  
  def format_name
    return self.data_format.name if self.data_format
    "none"    
  end

  def element_name
    return self.data_element.name if self.data_element
    "none"    
  end

  def role_name
    return self.parameter_role.name if self.parameter_role
    "undefined"
  end
  # 
  # See it the alias has been used as return first usage if exists
  # 
  def used?
    return AssayParameter.find(:first,:conditions=>['parameter_type_id=? and name=?',self.parameter_type_id, self.name])
  end
  # 
  # Find all the usages of the alias
  # 
  def usages
    return AssayParameter.find(:all,:conditions=>['parameter_type_id=? and name=?',self.parameter_type_id, self.name])
  end
  # 
  # Return valid units to associate with this aliasd
  # 
  def units
    self.parameter_type.units
  end
  
  # ## Get a string describing the style of the parameter in term of a data
  # element or data format
  # 
  def style
    return self.type.style if self.type
    "undefined"
  end

  
end
