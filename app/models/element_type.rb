# == Schema Information
# Schema version: 359
#
# Table name: element_types
#
#  id                 :integer(4)      not null, primary key
#  name               :string(30)      default(""), not null
#  description        :string(255)     default("_show"), not null
#  class_name         :string(255)     default("0"), not null
#  publish_to_team_id :integer(4)      default(1), not null
#  created_at         :datetime        not null
#  created_by_user_id :integer(4)      default(1), not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#

# == Description
#
# This represents a registrated type of element to be saved in project elements
# by default this is content,asset folders and references
#
# == Copyright
#
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ElementType < ActiveRecord::Base

  HTML      =1
  FILE      =2
  REFERENCE =3
  FOLDER    =4
  
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :class_name

  has_many :elements, :class_name=>'ProjectElement',:foreign_key=>'element_type_id'

  def path
    return self.name
  end
  #
  # List of suitable dashboard directories
  # Heeds basic show 
  #
  def self.element_classes
    list =[ProjectContent,ProjectReference,ProjectFolder,ProjectAsset]
    return list    
  end
  
  def model
    @model ||= eval(self.class_name) 
  end
  
  def self.lookup(style)
    case style
    when ElementType
      element_type = style
    when String
      element_type = ElementType.find_by_name(style.to_s)
    when Symbol
      element_type = ElementType.find_by_name(style.to_s)
    else
      element_type = ElementType.find(style)
    end
  end
  
  def view_root
    @view_root  ||= self.model.view_root 
  end
  
  def model=(value)
    if value.is_a?(ProjectElement)
      self.class_name = @model.class.to_s
      @model = value
    else
      raise "Invalid model class #{value.class}"
    end
  end  
  #
  # Create a new element
  #
  def new_element(parent=nil,options={})
    defaults = {:element_type_id=>self.id}
    if parent
       defaults = {
           :name => Identifier.next_user_ref,      
           :parent_id=>parent.id,
           :access_control_list_id => parent.access_control_list_id,
           :team_id => parent.team_id,
           :project_id => parent.project_id,
           :state_id => parent.state_id,
           :element_type_id=>self.id}
    end
    item = self.model.new(  defaults.merge(options) )     
  end
  
end
