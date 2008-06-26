# AlcesActAsSetting
module Alces
  module Acts
    module SettingsModel

      def self.included(base)
        return if base.included_modules.include?(Alces::Acts::SettingsModel::ClassMethods)
        base.extend ClassMethods
      end
        
##------------------------------------------------------------------------------------------------------------------------------      
      module ClassMethods
##
# Add settings methods
#      
        def acts_as_settings(options = {})
          write_inheritable_attribute(:acts_as_settings_options, 
              { :filename =>  options[:filename] || "#{RAILS_ROOT}/config/#{self.table_name}.yml",
                :scope => options[:scope]||'none'})
          class_inheritable_reader :acts_as_settings_options
          cattr_accessor :acts_as_settings_defaults
          cattr_accessor :default_settings
          self.default_settings = YAML::load(File.open(acts_as_settings_options[:filename]))
        #
        # generate methods for default list of allowed defaults
        #
          self.default_settings.each do |name, params|
           
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

          validates_uniqueness_of :name
          validates_inclusion_of :name, :in => self.default_settings.keys

          unless self.acts_as_settings_options[:scope] =='none'
          class_eval <<CODE
          #
          # Get a named value
          #  will read current value from database or use default from yaml file 
          #
         
          def self.get(name)
            name = name.to_s
            setting = self.find(:first,
                                  :conditions=>[" name = ? and #{self.acts_as_settings_options[:scope]}=?",
                                                  name,self.#{self.acts_as_settings_options[:scope]}])
            setting ||= self.new(:name => name,
                                   :#{self.acts_as_settings_options[:scope]}=> self.#{self.acts_as_settings_options[:scope]},
                                   :value => self.get_setting_value(name),
                                    :tip => self.get_setting_tip(name))
            setting
          end
CODE
          else  
          class_eval <<CODE
          #
          # Get a named value
          #  will read current value from database or use default from xml 
          #
          def self.get(name)
              name = name.to_s
              setting = self.find(:first,:conditions=>[" name = ?",name])
              setting ||= self.new(:name => name, 
                                  :value => self.get_setting_value(name),
                                   :tip => self.get_setting_tip(name))
             setting
          end
CODE
          end
          class_eval <<CODE
          
            def self.get_setting_value(name)
                 self.default_settings[name]['default'] if self.default_settings.has_key? name
             end

             def self.get_setting_tip(name)
                 self.default_settings[name]['tip'] if self.default_settings.has_key? name
             end
          #
          # Set the name/value pair
          # 
          def self.set(name,value)
            setting = get(name)
            setting.value = (value ? value.to_s : "")         
            setting.save!
            setting 
          end
          #
          # Get a value
          #
          def self.[](name)
             self.get(name).value
          end
          #
          # Set a value
          #
          def self.[]=(name, value)
            self.set(name,value).value
          end
          #
          # List a value of names allowed for settings
          #
          def self.names
            self.default_settings.keys 
          end  
          
CODE
        end
        
      end
    end
  end
end
