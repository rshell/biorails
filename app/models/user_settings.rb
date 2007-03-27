class UserSettings < ActiveRecord::Base

  cattr_accessor :defaults
  @@defaults = YAML::load(File.open("#{RAILS_ROOT}/config/user_settings.yml"))

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
