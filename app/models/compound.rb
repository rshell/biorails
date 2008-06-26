# == Schema Information
# Schema version: 281
#
# Table name: compounds
#
#  id                 :integer(11)   not null, primary key
#  name               :string(50)    default(), not null
#  description        :text          
#  formula            :string(50)    
#  mass               :float         
#  smiles             :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_by_user_id :integer(32)   default(1), not null
#  created_at         :datetime      not null
#  updated_by_user_id :integer(32)   default(1), not null
#  updated_at         :datetime      not null
#  registration_date  :datetime      
#  iupacname          :string(255)   default()
#  molecule_id        :integer(11)   
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Compound < ActiveRecord::Base

  attr_accessor :chemistry
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
                   
  has_many   :batches, :dependent => :destroy
  
  validates_uniqueness_of :name
  validates_presence_of :name
 #
  # Convert to jpg with 
  #     filename = id.png
  #     width  = 300
  #     height = 300
  #
  def to_png(filename=nil,width= 300 , height = 300)
       filename ||= "#{id}.png"
       Alces::Chemistry::CDK.to_png(self.chemistry, filename, width, height)
       return filename
    rescue Exception => ex
       logger.error "Failed to depict compound: #{compound.id}"  
       return null
  end

#  end
  
protected

end
