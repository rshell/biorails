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
class SystemSetting < ActiveRecord::Base
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

  cattr_accessor :defaults
  @@defaults = YAML::load(File.open("#{RAILS_ROOT}/config/system_settings.yml"))

  validates_uniqueness_of :name
  validates_inclusion_of :name, :in => @@defaults.keys
  
  def self.get(name)
    name = name.to_s
    setting = find_by_name(name)
    setting ||= new(:name => name, :text => @@defaults[name]['default']) if @@defaults.has_key? name
    setting
  end
  
  def self.[](name)
    get(name).text
  end
  
  def self.[]=(name, value)
    setting = get(name)
    setting.text = (value ? value.to_s : "")
    setting.save
    setting.text
  end
  
  @@defaults.each do |name, params|
    src = <<-END_SRC
    def self.#{name}
      self[:#{name}]
    end

    def self.#{name}?
      self[:#{name}].to_s == "1"
    end

    def self.#{name}=(value)
      self[:#{name}] = value
    end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end
  
 
end
