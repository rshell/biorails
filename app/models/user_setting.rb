# == Schema Information
# Schema version: 306
#
# Table name: user_settings
#
#  id                 :integer(11)   not null, primary key
#  name               :string(30)    default(), not null
#  value              :string(255)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#  user_id            :integer(11)   
#  tip                :string(255)   
#

## 
# This Provides  access to user specific settings for  the application 
# The current user of default  user.find(1) account is used  as the user 
#
# 
# UserSetting[:name] = value
# UserSetting.name = value
# 
class UserSetting < ActiveRecord::Base
##
# This record has a fullse audit log created for changes 
#   
  acts_as_audited :change_log

  acts_as_settings :filename => "#{RAILS_ROOT}/config/user_settings.yml",
                   :scope => :user_id
  
  #
  # Define the scope of the settings so diffenent set for each user
  #
  def self.user_id
    User.current.id
  end
  
end
