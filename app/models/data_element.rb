# == Schema Information
# Schema version: 359
#
# Table name: data_elements
#
#  id                 :integer(4)      not null, primary key
#  name               :string(50)      default(""), not null
#  description        :string(1024)    default(""), not null
#  data_system_id     :integer(4)      not null
#  data_concept_id    :integer(4)      not null
#  access_control_id  :integer(4)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  parent_id          :integer(4)
#  style              :string(10)      default(""), not null
#  content            :string(4000)    default("")
#  estimated_count    :integer(4)
#  type               :string(255)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# A DataElement is the implementation of a DataConcept. A Concept can be realised or implemented in 
#  multiple ways. Currentlly the following in three  ways are supported in the core project
#
#    * List - an internal list of strings, suitable for short dictionaries
#    * SQL - Structured Query Language run against one of the data sources.
#    * Model - A fully implemented model in BioRails usually available as a specific form, for example an Assay form. 
#
# Other may be added via a new Model in a plugin which sub types a DataElement.
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class DataElement < ActiveRecord::Base

  BLANK ="[None]"
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>"parent_id"
  validates_presence_of :name
  validates_presence_of :style
  validates_presence_of :data_system_id
  validates_presence_of :data_concept_id
  validates_presence_of :description
  validates_format_of :name, :with => /^[A-Z,a-z,0-9,_]*$/, :message => 'name is must be alphanumeric eg. [A-z,0-9,_]'

  belongs_to :system,  :class_name=>'DataSystem',  :foreign_key=>'data_system_id'
  belongs_to :concept, :class_name=>'DataConcept', :foreign_key=>'data_concept_id'
##
# @todo rethink this as a bit of a hack
# These are the holders for the various types of data
# 
  attr_accessor :sql
  attr_accessor :view
  attr_accessor :model
  attr_accessor :list
  attr_accessor :min
  attr_accessor :max
  
  has_many :assay_parameters, :dependent => :destroy
  has_many :parameters, :dependent => :destroy
  has_many :task_references, :dependent => :destroy
  
  acts_as_tree :order => "name"  
  
##
# Test if the element is used
#   
  def not_used
    return (assay_parameters.size==0 and parameters.size==0 )
  end 
#
# Allowed list of types
# 
  def allowed_styles
    return ['list','model','sql']
  end   
##
# convert content to a Array
# 
  def to_array
     return  self.children.collect{|v|v.name}
  end
#
# path to name
#
  def path
     if parent == nil 
        return name 
     else 
        return parent.path+"/"+name
     end 
  end 

  def data_concept_name
    self.concept.name if self.concept
  end

  def data_system_name
    self.system.name if self.system
  end
  
  def summary
    "#{path} (#{data_system_name})  [#{data_concept_name}] "
  end
#
# Find all the children of this the concept
#
  def decendents
     [self]+children.inject([]){|decendents,child|decendents+child.decendents}
  end
#
#  List values for this element   
#    
  def values
    @values = children.collect unless @values
    return @values
  end    

###
# @todo this will be a killer with value data sets
# 
# Lookup to find value in a list
# 
  def lookup(name)
    item = self.children.detect{|i|i.name.to_s == name.to_s}
    item ||= self.children.detect{|i|i.name.downcase.to_s == name.to_s.downcase}
    item ||= self.children.detect{|i|i.name.downcase.to_s == name.to_s.upcase}
    logger.info "lookup for #{self.id}  with #{name} ==> #{item}"
    return item
  end
  
  def format(value)
    item = reference(value) if value.to_i >0 
    item ||= lookup(value)
    return item.name if item
    nil
  end
##
# convert a id to a DataValue
# 
  def reference(id)
    return self.children.find(id)
  end
  
  def like(name, limit=25, offset=0)
    if name
  	   self.children.find(:all, :conditions=>['name like ?',name+'%'],:order=>'name',:limit=>limit,:offset=>offset)
    else
       self.children.find(:all,  :order=>'name', :limit=>limit, :offset=>offset)
    end
  end
#
#  List values for this element   
#    
  def choices(display_field=:name,id_field=:id)
     self.values.collect{|v|[v.send(display_field),v.send(id_field)]} 
  end    

#
#  List of data systems this element can be linked to
#  
  def allowed_systems
    DataSystem.find(:all)
  end
  
#
# Add a child data element linked to this one as the parent
#   
  def add_child(name,description = nil)
    child = DataElement.new
    child.parent = self
    child.system = self.system
    child.concept= self.concept
    child.style = 'child'
    child.name = name.strip
    child.description = description || name 
    self.children << child
    self.estimated_count =self.children.size
    child.save
    return child
  end

  def to_xml(options = {})
      my_options = options.dup
      my_options[:include] ||= [:system]
      Alces::XmlSerializer.new(self, my_options  ).to_s
  end

##
# Get DataElement from xml
# 
  def self.from_xml(xml,options = {})
      my_options = options.dup
      my_options[:include] ||= [:system]
      Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
  end
      
 def DataElement.create_from_params(params={})  
    case params[:style]
      when 'list'
         element = ListElement.create(params)
                
      when 'sql'
         element =SqlElement.create(params)
      when 'model'
         element =ModelElement.create(params)
      else 
       element =DataElement.create(params)
    end   
  end  
  
end
