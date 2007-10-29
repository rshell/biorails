# == Schema Information
# Schema version: 280
#
# Table name: data_elements
#
#  id                 :integer(11)   not null, primary key
#  name               :string(50)    default(), not null
#  description        :text          
#  data_system_id     :integer(11)   not null
#  data_concept_id    :integer(11)   not null
#  access_control_id  :integer(11)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  parent_id          :integer(10)   
#  style              :string(10)    default(), not null
#  content            :text          default(), not null
#  estimated_count    :integer(11)   
#  type               :string(255)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#


##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class DataElement < ActiveRecord::Base
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
  validates_format_of :name, :with => /^[A-Z,a-z,0-9,-,_]*$/, :message => 'name is must be alphanumeric eg. [A-z,0-9,-_]'

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
  
  has_many :study_parameters, :dependent => :destroy
  has_many :parameters, :dependent => :destroy
  has_many :task_references, :dependent => :destroy
  
  acts_as_tree :order => "name"  
##
# Test if the element is used
#   
  def not_used
    return (study_parameters.size==0 and parameters.size==0 )
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

  def summary
    "#{path} (#{system.name})  [#{concept.path}] "
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
    item = self.children.detect{|item|item.name.to_s == name.to_s}
    item ||= self.children.detect{|item|item.id.to_s == name.to_s}
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
    return self.children.detect{|item|item.id.to_s == id.to_s}
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
      when 'view'
         element =ViewModel.create(params)
      else 
       element =DataElement.create(params)
    end   
  end  

  def error_messages
    messages = []
    if errors.on :children
      messages << children.collect{|item|" [#{item.name}] #{ item.valid? ? 'ok' : item.errors.full_messages.to_sentence } " }
     errors.each do |item|  
        unless item[0].to_s =='children'
          messages <<  "#{item[0]} #{item[1]}" 
        end
     end
     messages.join("<br/>") 
    else
      errors.full_messages.to_sentence
    end
  end
    
end

###############################################################################################
# List  based in statement
# 
class ListElement < DataElement
  after_save :populate 

protected
  def populate
     estimated_count = 0
     FasterCSV.parse(content) do |row|
       row.each do |item|
           add_child(item)
       end
     end
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
   self.system.reset_connection(DataValue)
   @values = DataValue.find_by_sql(sql_select) if !@values
   self.estimated_count = @values.size   
   return @values;  
  end    
  
  def sql_select
    sql = self.content
    sql = sql.gsub(/:user_id/,User.current.id.to_s)
    sql = sql.gsub(/:user_name/,User.current.login)
    sql = sql.gsub(/:project_id/,Project.current.id.to_s)
    sql = sql.gsub(/:project_name/,Project.current.name)
    return sql
#    if ProjectFolder.current
#      sql = sql.gsub(/:folder_id/,ProjectFolder.current.id.to_s)
#      sql = sql.gsub(/:folder_name/,ProjectFolder.current.name)
#    end 
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
#
# @todo rjs not sure on portability and preformance of this
# 
# oracle: SELECT * FROM (SELECT ROWNUM as ROW_NUM, x.* FROM (content) where x.name like 'xxx' order by x.name ) WHERE row_num BETWEEN 20 AND 40; 
# mysql/postgres: SELECT * FROM (Content) where name like 'xxx'  limit=20 start=0
  def like(name, limit=25, offset=0 )
	if (self.system.connection.class == "ActiveRecord::ConnectionAdapters::OracleAdapter")
	  self.system.connection.select_all(
		"select * from (select ROWNUM row_num,x.* FROM (content) where  x.name like "+
	    "'#{name}%' order by x.name) where row_num between #{offset} and #{(offset+limit)}" )    
    else
	  self.system.connection.select_all(
		"select * from (#{content}) where  name like'#{name}%' order by name offset #{offset} limit #{limit}")
    end
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
   estimated_count = @values.size
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
  def like(name,limit=25,offset=0)
    if name
	   self.model.find(:all, :conditions=>['name like ?',name+'%'], :order=>'name', :limit=>limit, :offset=>offset)
    else
       self.model.find(:all,:limit=>100,:order=>'name', :limit=>limit, :offset=>offset)
    end
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
