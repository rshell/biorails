# == Schema Information
# Schema version: 359
#
# Table name: identifiers
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  prefix             :string(255)
#  postfix            :string(255)
#  mask               :string(255)
#  current_counter    :integer(4)      default(0)
#  current_step       :integer(4)      default(1)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
#
# This is a simple table based identifier generator to filling in the name field for 
# new records. If is based on lookup on the model/name passed.
# Identifiers are based on three elements prefix,sequence and postfix
#  <prefix><sequence><postfix>
#
#  mask
#  #
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 

class Identifier < ActiveRecord::Base

# difference table name needed for postgres
# set_table_name :data_identifiers

  def project
    Project.current
  end
    
  def team
    Team.current
  end
    
  def user
    User.current
  end
    
  def Identifier.need_to_define(record,name)
      return false unless record.attributes.include?(name.to_s)
      record.send(name).blank?
  rescue
      return false      
  end
##
# Generate a name based on the current record
# 
  def set_name(record)
    if Identifier.need_to_define(record,'name')
       record.name =  next_id
       logger.debug("generate name #{record.name}")
    end 
  end
#
# generate a description
#
  
  def next_id
     self.current_counter = self.current_counter + self.current_step
     if self.mask.blank?
       key =  "#{self.prefix}#{self.current_counter}#{self.postfix}"
     else
       key =  sprintf(self.mask,self.prefix,self.current_counter,self.postfix)
     end
     self.save
     return key
  end
##
# Generate a name for a model class
#   
  def self.next_id(model)
     Identifier.transaction do
       generator = Identifier.find_by_name(model.to_s)
       unless generator
           generator = Identifier.new
           generator.name = model.to_s
           generator.prefix = "#{model}-"
           generator.postfix = ""
           generator.save
       end
       return generator.next_id
     end
  end
  
  #
  # Fill name,description,project and team records of a record
  #
  def self.fill_defaults(record)
     if record.respond_to?(:name_generator)
        generator = record.name_generator
        record.name=nil if generator
     end
     generator ||= Identifier.find_by_name(record.class.to_s)
     if generator
       logger.debug("generate defaults for #{record.class}")
       generator.set_name(record)    
     end
     record.team        ||= Project.current.team  if record.respond_to?("team=")
     record.project     ||= Project.current  if record.respond_to?("project=")
     record.created_by  ||= User.current     if record.respond_to?("created_by=")
     record.updated_by  ||= User.current     if record.respond_to?('updated_by=')
     record.assigned_to ||= User.current     if record.respond_to?('assigned_to=')
     record.started_at  ||= Time.new         if record.respond_to?('started_at=')
     record.expected_at ||= Time.new + 7.day if record.respond_to?('expected_at=')     
  end
##
# Next user specfic reference
#
  def self.next_user_ref
      unless Identifier.find_by_name(User.current.dom_id)
          generator = Identifier.new
           generator.name = User.current.dom_id
           generator.prefix = User.current.id.to_s
           generator.postfix = ""
           generator.mask = "U-%s-%.6d"
           generator.save!
       end
       self.next_id(User.current.dom_id)
  end
end
