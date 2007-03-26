# == Schema Information
# Schema version: 123
#
# Table name: controller_actions
#
#  id                 :integer(11)   not null, primary key
#  site_controller_id :integer(11)   not null
#  name               :string(255)   default(), not null
#  permission_id      :integer(11)   
#  url_to_use         :string(255)   
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class ControllerAction < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => 'site_controller_id'

  attr_accessor :url, :allowed, :specific_name

  belongs_to :controller, :class_name => 'SiteController', :foreign_key => 'site_controller_id'
  belongs_to :permission

  def effective_permission
    return permission || controller.permission
  end

  def effective_permission_id
    return self.permission_id || self.controller.permission_id
  end

  def fullname
    if self.site_controller_id and self.site_controller_id > 0
      return "#{self.controller.name}: #{self.name}"
    else
      return "#{self.name}"
    end
  end

  def url
    @url ||= "/#{self.controller.name}/#{self.name}"
    return @url
  end


  def self.actions_allowed(permission_ids)
        # Hash for faster & easier lookups
    if permission_ids
      perms = {}
      for id in permission_ids do
        perms[id] = true
      end
    end

    actions = ControllerAction.find(:all)
    for action in actions do
      if action.permission_id
        if perms.has_key?(action.permission_id)
          action.allowed = 1
        else
          action.allowed = 0
        end
      else  # Controller's permission
        if perms.has_key?(action.controller.permission_id)
          action.allowed = 1
        else
          action.allowed = 0
        end
      end
    end
    return actions
  end

  def self.find_for_permission(p_ids)
    if p_ids and p_ids.length > 0
      return find(:all, 
                  :conditions => ['permission_id in (?)', p_ids],
                  :order => 'name')
    else
      return Array.new
    end
  end

end
