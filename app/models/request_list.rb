# == Schema Information
# Schema version: 233
#
# Table name: lists
#
#  id              :integer(11)   not null, primary key
#  name            :string(255)   
#  description     :text          
#  type            :string(255)   
#  expires_at      :datetime      
#  lock_version    :integer(11)   default(0), not null
#  created_by      :string(32)    default(), not null
#  created_at      :datetime      not null
#  updated_by      :string(32)    default(), not null
#  updated_at      :datetime      not null
#  data_element_id :integer(11)   
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class RequestList < List
 has_one :request, :class_name => 'Request', :foreign_key => 'list_id'
 
  def self.create(params)
     request = Request.new(params)
     return nil unless request.save
     list = RequestList.new
     list.name = params[:name]
     list.description = "Request #{params[:name]}"
     if params[:data_element_id]
        list.data_element_id =  params[:data_element_id]
     end            
     list.request = request
     if list.save
       return list
     else
       request.detroy
     end
     return nil
  end
end
