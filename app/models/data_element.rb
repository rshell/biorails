# == Schema Information
# Schema version: 123
#
# Table name: data_elements
#
#  id                :integer(11)   not null, primary key
#  name              :string(50)    default(), not null
#  description       :text          
#  data_system_id    :integer(11)   not null
#  data_concept_id   :integer(11)   not null
#  access_control_id :integer(11)   
#  lock_version      :integer(11)   default(0), not null
#  created_by        :string(32)    default(sys), not null
#  created_at        :datetime      not null
#  updated_by        :string(32)    default(sys), not null
#  updated_at        :datetime      not null
#  parent_id         :integer(10)   
#  style             :string(10)    default(), not null
#  content           :text          default(), not null
#  estimated_count   :integer(11)   
#  type              :string(255)   
#


##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class DataElement < ActiveRecord::Base
  
#
# Generic rules for a name and description to be present
  validates_uniqueness_of :name, :scope =>"parent_id"
  validates_presence_of :name
  validates_presence_of :description

  belongs_to :system,  :class_name=>'DataSystem',  :foreign_key=>'data_system_id'
  belongs_to :concept, :class_name=>'DataConcept', :foreign_key=>'data_concept_id'


#  belongs_to :access, :class_name => "AccessControl", :foreign_key => "access_control_id"


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
  
  
  has_many :study_parameters, :dependent => :destroy
  has_many :parameters, :dependent => :destroy
  has_many :task_references, :dependent => :destroy
  
  acts_as_tree :order => "name"  
  
 
  def not_used
    return (study_parameters.size==0 and parameters.size==0)
  end 
  
#
# Allowed list of types
# 
  def types
    return ['list','range','model','view','sql','child']
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
        return "/"+name 
     else 
        return parent.path+"/"+name
     end 
  end 

#
# Find all the children of this the concept
#
  def decendents
     [self]+children.inject([]){|decendents,child|decendents+child.decendents}
  end
   
#
# Overide context_columns to remove all the internal system columns.
# 
  def self.content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ || c.name == inheritance_column }        
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
    return self.children.detect{|item|item.name == name}
  end

  def reference(id)description
    return self.children.detect{|item|item.id == id}
  end
  
  def like(name)
    return self.values
  end
  
#
#  List values for this element   
#    
  def choices
     self.values.collect{|row | [ row.name, row.id]} 
  end    

##
# check it there are values for this element
  def values_ok?
    if style != 'child'
      self.values.size>0 
    else
      true
    end 
  rescue
    false
  end 
 
#
# List of allowed concepts
# 
  def allowed_concepts
      if parent 
         allowed = parent.allowed_concepts
      elsif concept 
         allowed = concept.decendents
      elsif system 
         allowed = system.allowed_concepts
      else  
         allowed = [] 
      end
  end

#
#  List of data systems this element can be linked to
#  
  def allowed_systems
     if system
       allowed = [self.system]
     elsif parent
       allowed = parent.allowed_systems
     else
       allowed = DataSystem.find(:all)
     end
  end
  
#
# Add a child data element linked to this one as the parent
#   
  def add_child(name)
    child = DataElement.new
    child.parent = self
    child.system = self.system
    child.concept= self.concept
    child.style = 'child'
    child.name = name
    child.description = name
    self.children << child
    self.estimated_count =self.children.size
    return child
  end

      
  def DataElement.create(params={},content={})  
    case params[:style]
      when 'list'
         params[:content] = content[:list] if content[:list]
         ListElement.new(params)
      when 'range'
         params[:content] = "#{content[:min]}..#{content[:max]}" if content[:min] && content[:max]
         RangeElement.new(params)
      when 'sql'
         params[:content] = content[:sql] if content[:sql]
         SqlElement.new(params)
      when 'model'
         params[:content] = content[:model] if content[:model]
         ModelElement.new(params)
      when 'view'
         params[:content] = content[:view] if content[:view]
         ViewModel.new(params)
      else 
       DataElement.new(params)
    end   
  end  
  
end

###############################################################################################
# List  based in statement
# 
class ListElement < DataElement

##
# convert content to a Array
# 
  def to_array
     return eval("[#{content}]") 
  end
#
#  List values for this element   
#    
  def values
    return to_array.collect {|v|{:name => v,:id => v}}         
  end    

##
# number of items
  def size
    return to_array.size
  end

  def like(name)
    return self.values
  end

###
# Lookup to find value in a list
# 
  def lookup(name)
    return self.values.detect{|item|item[:name] == name}
  end

##
# Get by id  
# 
  def reference(id)
    return self.values[id]
  end
#
#  List values for this element   
#    
  def choices
    to_array.collect {|v|[v, v]}         
  end    

end

###############################################################################################
# SQLType based in statement
# 
class RangeElement < ListElement

##
# convert content to a Array
# 
  def to_range
     return eval("(#{content})")
  end

  def to_array
     return to_range.to_a
  end

end

###############################################################################################
# SQLType based in statement
# 
class SqlElement < DataElement

##
# Get the constents as SQL select statement
  def statement
    return @content
  end

  def to_array
     return self.values.collect{|v|v.name}
  end

##
#  List values for this element   
  def values
   @values = self.system.connection.select_all(content) if !@values
   return @values
  end    

##
# Count the number of records returned with a select count(*) from (select ....)
# 
  def size
    return  self.system.connection.select_all("select count(*) from ("+content+") x")
  end

###
# Lookup to find value in a list
  def lookup(name)
    return  self.system.connection.select_one(content+" where  name='"+name+"'")    
  end

##
# Get by id  
# 
  def reference(id)
    return  self.system.connection.select_one(content+" where  id='"+id+"'")    
  end

  def like(name)
    return data_system.connection.select_one(content+" where  name like'"+name+"%'")    
  end

##
#  List values for this element   
  def choices
     self.values.collect{|v|[v['name'],v['id']]} 
  end    

end

###############################################################################################
# DataElement linked back to defined Model in Rails. This is a simple dynamic link to 
# a model class which used all the standard finder methods etc
# 
class ModelElement < DataElement

  def model
    return eval(self.content)
  end

  def to_array
     return self.values.collect{|v|v.name}
  end

#
#  List values for this element   
#    
  def values
   @values = self.model.find(:all) unless @values
   return @values
  end    

  def size
    return self.model.count
  end
###
# Lookup to find value in a list
# 
  def lookup(name)
    return self.model.find_by_name(name)
  end

##
# Get by id  
# 
  def reference(id)
    return self.model.find(id)
  end

###
# find values like 
#  
  def like(name)
    self.model.find(:all,:limit=>10,:conditions=> ['name like ?',name+"%"] )
  end
#
#  List values for this element   
#    
  def choices
     self.values.collect{|v|[v.name,v.id]} 
  end    

end


###############################################################################################
# This generate a dynamic model class and maps this to the base table or view 
#
class ViewElement < ModelElement

  def model
    model = DataValue.clone()
    model.set_table_name(@content)
    self.system.reset_connection(model)
    return model
  end

end
