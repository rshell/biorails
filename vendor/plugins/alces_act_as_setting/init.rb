#
# Add acts_as_settings to active record
#
require 'alces_act_as_setting'
ActiveRecord::Base.send(:include,     Alces::Acts::SettingsModel)
