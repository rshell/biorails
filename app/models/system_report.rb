# == Schema Information
# Schema version: 306
#
# Table name: reports
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  description        :string(1024)  default(), not null
#  base_model         :string(255)   
#  custom_sql         :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  style              :string(255)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#  internal           :boolean(1)    
#  project_id         :integer(11)   
#  action             :string(255)   
#

##
# Internal report types
# 
class SystemReport < Report

end
