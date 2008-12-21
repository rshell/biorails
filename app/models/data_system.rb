# == Schema Information
# Schema version: 359
#
# Table name: data_systems
#
#  id                 :integer(4)      not null, primary key
#  name               :string(50)      default(""), not null
#  description        :string(1024)    default(""), not null
#  data_context_id    :integer(4)      default(1), not null
#  access_control_id  :integer(4)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  adapter            :string(50)      default("mysql"), not null
#  host               :string(50)      default("localhost")
#  username           :string(50)      default("root")
#  password           :string(50)      default("")
#  database           :string(50)      default("")
#  test_object        :string(45)      default(""), not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#


##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class DataSystem < ActiveRecord::Base
##
# This record has a full audit log created for changes 
#   
   acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  acts_as_dictionary :name
  validates_presence_of :name
  validates_uniqueness_of :name,:case_sensitive=>false
  validates_presence_of :description

def validate 
    unless self.can_connect?
      self.errors.add_to_base("Cant connect to target system")
    end
  end

has_many :data_elements, :conditions => "parent_id is null", :dependent => :destroy 
  belongs_to :data_context

#
# path for the data system
#
  def path
      name
  end
#
# List of allowed adapters
#
  def allowed_adapters
    return ['local','sqlite','mysql','postgresql','biorails_oracle','oracle_enhanced']
  end 
  
#
#  reset the connection for a ActiveBase Class
#  
  def reset_connection(clazz)
    unless (self.is_local?)
    clazz.establish_connection(
      :adapter  => adapter,
      :host     => host,
      :username => username,
      :password => password,
      :database => database
      )   
    end    
  end
  
    def is_local?
      (self.adapter.to_s=='local')
    end

# Test whether connection information is valid
#
  def can_connect?
    self.is_local?|| !self.remote_connection.nil?
  end
#
#  Get a connection to remote systems
#    
  def remote_connection
     return DataSystem.connection if self.adapter=='local'
     # Reset DataValue to remote system and test ok! 
     # test_object the item to search for in remote system for validation
     DataValue.table_name = test_object
     reset_connection(DataValue)
     item = DataValue.find(:first)
     DataValue.connection
   rescue
     nil
  end  
#
#  allowed data contexts for the current system
#  
  def allowed_contexts
     return DataContext.find(:all)
  end

end
