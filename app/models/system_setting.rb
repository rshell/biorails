# == Schema Information
# Schema version: 281
#
# Table name: system_settings
#
#  id                 :integer(11)   not null, primary key
#  name               :string(30)    default(), not null
#  description        :string(255)   default(), not null
#  text               :string(255)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# This class manages system wide settings. Defaults are read from /config directory and can 
# be over ridden via records in the system_settings table. 
# 
# The uses a class.yaml file in the config directory as a source of allowed values
# 
# * SystemSetting['xxx'] 
# * SystemSetting.xxx  
# * SystemSettings.names   
# be over ridden via records in the system_settings table.
#
# To create new seeting a default must be created in the yml setting files
#
class SystemSetting < ActiveRecord::Base
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

  acts_as_settings :filename => "#{RAILS_ROOT}/config/system_settings.yml"

end
