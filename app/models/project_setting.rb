# == Schema Information
# Schema version: 359
#
# Table name: project_settings
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)
#  name               :string(30)      default(""), not null
#  tip                :string(255)
#  value              :string(255)     default("0"), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# This Provides  access to project specific settings for  the application
# The current user of default  user.find(1) account is used  as the user 
#  * UserSetting[:name] = value
#  * UserSetting.name = value
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ProjectSetting < ActiveRecord::Base
##
# This record has a fullse audit log created for changes 
#   
  acts_as_audited :change_log

  acts_as_settings :filename => "#{RAILS_ROOT}/config/project_settings.yml",
                   :scope => :project_id
  
  #
  # Define the scope of the settings so diffenent set for each user
  #
  def self.project_id
    Project.current.id
  end

  def to_s
    "project_setting[#{project_id}][#{name}]=#{value}"
  end

end
