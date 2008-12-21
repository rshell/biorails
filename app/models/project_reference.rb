# == Schema Information
# Schema version: 359
#
# Table name: project_elements
#
#  id                     :integer(4)      not null, primary key
#  parent_id              :integer(4)
#  project_id             :integer(4)      not null
#  type                   :string(32)      default("ProjectElement")
#  position               :integer(4)      default(1)
#  name                   :string(64)      default(""), not null
#  reference_id           :integer(4)
#  reference_type         :string(20)
#  lock_version           :integer(4)      default(0), not null
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  updated_by_user_id     :integer(4)      default(1), not null
#  created_by_user_id     :integer(4)      default(1), not null
#  asset_id               :integer(4)
#  content_id             :integer(4)
#  project_elements_count :integer(4)      default(0), not null
#  left_limit             :integer(4)      default(1), not null
#  right_limit            :integer(4)      default(2), not null
#  state_id               :integer(4)
#  element_type_id        :integer(4)
#  title                  :string(255)
#  access_control_list_id :integer(4)
#

# == Description
# This is a sub type of a project element to reference a reference to
# another object. This is used for cross linkage of projects and 
# regration of objects as part of project.
# 
# There are generally created with the following :-
# 
# * project.add_link(object)
# * project.remove_link(object)
# * project.linked(Class)
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ProjectReference < ProjectElement

  validates_associated :reference
  validates_presence_of   :reference
  validates_presence_of   :reference_id
  validates_presence_of   :reference_type

  def freeze
    update_content(reference.to_html) if reference
  end  
  

  def summary
    if reference
      out = "#{self.reference_type} ["
      out << self.reference.name if reference.respond_to?(:description)
      out << "]"
      out << self.reference.description if reference.respond_to?(:description)
      return out
    end
    return name
  end

  def icon( options={} )
     '/images/model/note.png'
  end  

  
end
