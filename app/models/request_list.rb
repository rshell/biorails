# == Schema Information
# Schema version: 359
#
# Table name: lists
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)     not null
#  description        :string(1024)    default("")
#  type               :string(255)
#  expires_at         :datetime
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  data_element_id    :integer(4)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# Sub type for the list of items associated with a request
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class RequestList < List

end
