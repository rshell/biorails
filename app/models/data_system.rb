# == Schema Information
# Schema version: 239
#
# Table name: data_systems
#
#  id                 :integer(11)   not null, primary key
#  name               :string(50)    default(), not null
#  description        :text          
#  data_context_id    :integer(11)   default(1), not null
#  access_control_id  :integer(11)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  adapter            :string(50)    default(mysql), not null
#  host               :string(50)    default(localhost)
#  username           :string(50)    default(root)
#  password           :string(50)    default()
#  database           :string(50)    default()
#  test_object        :string(45)    default(), not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#


##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class DataSystem < ActiveRecord::Base
  included Named
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
   acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
                              :description=>{:store=>:yes,:boost=>0},
                               }, 
                   :default_field => [:name],           
                   :single_index => true, 
                   :store_class_name => true 
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name
  has_many :data_elements, :conditions => "parent_id is null", :dependent => :destroy 
  belongs_to :data_context

#
# path for the data system
#
  def path
     if data_context then 
        data_context.path+':'+name
     else 
        name
     end 
  end
  
  def elements
    self.data_elements
  end 

#
# List of allowed adapters
#
  def allowed_adapters
    return ['local','sqlite','mysql','oracle']
  end 
  
#
#  reset the connection for a ActiveBase Class
#  
  def reset_connection(clazz)
    clazz.establish_connection(
      :adapter  => adapter,
      :host     => host,
      :username => username,
      :password => password,
      :database => database
    )    
  end
#
#  Get a connection to remote systems
#    
  def connection
     return DataSystem.connection if adapter=='local'
     # Reset DataValue to remote system and test ok! 
     # test_object the item to search for in remote system for validation
     DataValue.table_name = test_object
     reset_connection(DataValue)
     item = DataValue.find(:first)
     DataValue.connection
   rescue
     DataSystem.connection
  end  
#
#  allowed data contexts for the current system
#  
  def allowed_contexts
     return DataContext.find(:all)
  end
  
#
# allowed concepts for the current data system
#  
  def allowed_concepts
     if data_context
       return DataConcept.find(:all,:conditions=>['data_context_id=?',data_context.id],:order=>'name,parent_id')
     else
       return DataConcept.find(:all,:order=>'name,parent_id')
     end  
  end 

end
