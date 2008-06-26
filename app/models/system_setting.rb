# == Schema Information
# Schema version: 306
#
# Table name: system_settings
#
#  id                 :integer(11)   not null, primary key
#  name               :string(30)    default(), not null
#  value              :string(255)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#  tip                :string(255)   
#

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
#
# To create new seeting a default must be created in the yml setting files
#
class SystemSetting < ActiveRecord::Base
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
  acts_as_settings :filename => SYSTEM_SETTINGS || "#{RAILS_ROOT}/config/system_settings.yml"
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_presence_of   :value

  
  def self.all
    self.names.sort.collect{|name|self.get(name)}
  end
  
  def displayed_value
    (self.value.empty? ? "?" : self.value.to_s)
  end
  
end
