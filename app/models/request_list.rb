# == Schema Information
# Schema version: 280
#
# Table name: lists
#
#  id                 :integer(11)   not null, primary key
#  name               :string(255)   
#  description        :text          
#  type               :string(255)   
#  expires_at         :datetime      
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  data_element_id    :integer(11)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class RequestList < List

end
