# == Schema Information
# Schema version: 359
#
# Table name: reports
#
#  id                 :integer(4)      not null, primary key
#  name               :string(128)     default(""), not null
#  description        :string(1024)    default(""), not null
#  base_model         :string(255)
#  custom_sql         :string(255)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  style              :string(255)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  internal           :boolean(1)
#  project_id         :integer(4)
#  action             :string(255)
#  project_element_id :integer(4)
#

# == Description
# Internal report types
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class SystemReport < Report

end
