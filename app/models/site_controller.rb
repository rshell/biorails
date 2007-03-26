# == Schema Information
# Schema version: 123
#
# Table name: site_controllers
#
#  id            :integer(11)   not null, primary key
#  name          :string(255)   default(), not null
#  permission_id :integer(11)   not null
#  builtin       :integer(10)   default(0)
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class SiteController < ActiveRecord::Base
  @@models=nil
  validates_presence_of :name
  validates_uniqueness_of :name
  
  belongs_to :permission
  has_many :actions ,:class_name=>'ControllerAction', :order => 'name'


  def all_actions
    ControllerAction.find(:all).collect{|i|i.name}.uniq  
  end

  def possible_actions     
     SiteController.class_actions(name)
  end

##
# get the list of possible actions for this controller
# 
  def self.class_actions(name)
    action_collection = Array.new
    if name
      controller = eval("#{name}_controller".camelcase)
      methods = controller.public_instance_methods - ApplicationController.public_instance_methods
      for method in methods.sort do
        action_collection << ControllerAction.new(:name => method)
      end
    end
    return action_collection
  end

  def self.classes
    for file in Dir.glob("#{RAILS_ROOT}/app/controllers/*.rb") do
      begin
        load file
      rescue
        logger.info "Couldn't load file '#{file}' (already loaded?)"
      end
    end
    
    classes = Hash.new
    
    ObjectSpace.each_object(Class) do |klass|
      if klass.respond_to? :controller_name
        if klass.superclass.to_s == ApplicationController.to_s
          classes[klass.controller_name] = klass
        end
      end
    end

    return classes
  end

##
# Get a List of all the Models
#   
  def self.models
    unless @models
      for file in Dir.glob("#{RAILS_ROOT}/app/models/*.rb") do
        begin
          load file
        rescue
          logger.info "Couldn't load file '#{file}' (already loaded?)"
        end
      end  
    end
    @models = []

    ObjectSpace.each_object(Class) do |klass|
      if klass.ancestors.any?{|item|item==ActiveRecord::Base} and !klass.abstract_class
        @models << klass unless @models.any?{|item|item.to_s == klass.to_s}
      end
    end

    @models -= [ActiveRecord::Base, CGI::Session::ActiveRecordStore::Session]
    return @models.sort{|a,b| a.to_s <=> b.to_s }
  end
end
