# == Schema Information
# Schema version: 123
#
# Table name: roles
#
#  id              :integer(11)   not null, primary key
#  name            :string(255)   default(), not null
#  parent_id       :integer(11)   
#  description     :string(1024)  default(), not null
#  default_page_id :integer(11)   
#  cache           :text          
#  created_at      :timestamp     
#  updated_at      :timestamp     
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

require "credentials"
require "menu"

class Role < ActiveRecord::Base
  serialize :cache
  validates_presence_of :name
  validates_uniqueness_of :name

 
##
# Get the action rights for a user in this role
# 
  def credentials
     self.cache[:credentials] ||= rebuild_credentials
  end

  def rebuild_credentials
    self.cache[:credentials] = Credentials.new(self.id)
  end
###
# Get the menus structure for a user with this role
#   
  def menu
   self.cache[:menu] ||= rebuild_menu
  end 

  def rebuild_menu
     self.cache[:menu] = Menu.new(self)     
  end

##
# Build the cache of all the menus and rights for roles
# 
  def Role.rebuild_cache	   
	 for role in Role.find(:all)  
        role.rebuild
 	 end     
  end

  def rebuild
     self.cache = nil ; 
     self.save # we have to do this to clear it
     self.cache = Hash.new
     self.rebuild_credentials
     self.rebuild_menu
     self.save
  end

  def get_parents
    parents = Array.new
    seen = Hash.new

    current = self.id
    
    while current
      role = Role.find(current)
      if role 
        if not seen.has_key?(role.id)
          parents << role
          seen[role.id] = true
          current = role.parent_id
        else
          current = nil
        end
      else
        current = nil
      end
    end

    return parents
  end

end
