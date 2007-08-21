# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
 RAILS_GEM_VERSION = '1.2.3'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/cachers #{RAILS_ROOT}/app/drops #{RAILS_ROOT}/app/filters )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  config.log_level = :info

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  
  ## 
  # @todo memory store is causing odd problems with have 
  config.action_controller.session_store = :active_record_store

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  # Use Active Record's schema dumper instead of SQL when creating the test database
  # (enables use of different database adapters for development and test environments)
  config.active_record.schema_format = :ruby
  
  
  # Activate observers that should always be running
  config.active_record.observers = :study_observer, :experiment_observer, :catalog_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

PUBLIC_ROOT = "#{RAILS_ROOT}/public"

require 'tzinfo'
require 'csv'

#Mime::Type.register "application/msword", :doc, %w( text/html )
#Mime::Type.register "application/msexcel", :xls
#Mime::Type.register "text/richtext", :rtf
#Mime::Type.register "image/svg+xml", :svg

GLoc.set_config :default_language => :en
GLoc.clear_strings
GLoc.set_kcode
GLoc.load_localized_strings
GLoc.set_config(:raise_string_not_found_errors => false)

  module ActiveRecord
    module ConnectionAdapters

      class OracleAdapter
      
          @@low_sequence = 0
          @@high_sequence = nil
          
          def native_database_types #:nodoc:
            {
              :primary_key => "NUMBER(11) NOT NULL PRIMARY KEY",
              :string      => { :name => "VARCHAR2", :limit => 255 },
              :text        => { :name => "VARCHAR2", :limit => 2048 },
              :integer     => { :name => "NUMBER", :limit => 11 },
              :float       => { :name => "BINARY_DOUBLE" },
              :decimal     => { :name => "DECIMAL" },
              :datetime    => { :name => "DATE" },
              :timestamp   => { :name => "TIMESTAMP" },
              :time        => { :name => "DATE" },
              :date        => { :name => "DATE" },
              :binary      => { :name => "BLOB" },
              :boolean     => { :name => "CHAR", :limit => 1 }
            }
          end
          
        
          def quoted_true
              "Y"
          end
      
          def quoted_false
              "N"
          end
      
          # Returns the next sequence value from a sequence generator. Not generally
          # called directly; used by ActiveRecord to get the next primary key value
          # when inserting a new database record (see #prefetch_primary_key?).
          def next_sequence_value(sequence_name)
            if @@low_sequence == 0 
               @connection.exec("select biorails_app_seq.nextval id from dual") { |r| @@high_sequence = r[0].to_i }
            end
            @@low_sequence = ( @@low_sequence +1 ) % 256
            return  @@high_sequence*256  +  @@low_sequence 
          end

          # Returns the next sequence value from a sequence generator. Not generally
          # called directly; used by ActiveRecord to get the next primary key value
          # when inserting a new database record (see #prefetch_primary_key?).
          def next_sequence(sequence_name)
            id = 0
            if @@high_sequence.nil? 
            @connection.exec("select #{sequence_name}.nextval id from dual") { |r| id = r[0].to_i }
            end
            id
          end
          #
          # Create High/Low value based on a application sequence name. This is a simple round trip saver to the database
          # two stop a dual trip for insert. 
          #
          def next_id_value
            if @@low_sequence == 0 
               @connection.exec("select biorails_app_seq.nextval id from dual") { |r| @@high_sequence = r[0].to_i }
            end
            @@low_sequence = ( @@low_sequence +1 ) % 256
            return  @@high_sequence*256  +  @@low_sequence 
          end
      
          
      end      
    end
  end


# Time.now.to_ordinalized_s :long
# => "February 28th, 2006 21:10"
module ActiveSupport::CoreExtensions::Time::Conversions
  def to_ordinalized_s(format = :default)
    format = ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[format] 
    return to_default_s if format.nil?
    strftime(format.gsub(/%d/, '_%d_')).gsub(/_(\d+)_/) { |s| s.to_i.ordinalize }
  end
end


class Time
  class << self
    # Used for getting multifield attributes like those generated by a 
    # select_datetime into a new Time object. For example if you have 
    # following <tt>params={:meetup=>{:"time(1i)=>..."}}</tt> just do 
    # following:
    #
    # <tt>Time.parse_from_attributes(params[:meetup], :time)</tt>
    def parse_from_attributes(attrs, field, method=:gm)
      attrs = attrs.keys.sort.grep(/^#{field.to_s}\(.+\)$/).map { |k| attrs[k] }
      attrs.any? ? Time.send(method, *attrs) : nil
    end
  end

  def to_delta(delta_type = :day)
    case delta_type
      when :year then self.class.delta(year)
      when :month then self.class.delta(year, month)
      else self.class.delta(year, month, day)
    end
  end
      
  def self.delta(year, month = nil, day = nil)
    from = Time.local(year, month || 1, day || 1)
    
    to = 
      if !day.blank?
        from.advance :days => 1
      elsif !month.blank?
        from.advance :months => 1
      else
        from.advance :years => 1
      end
    return [from.midnight, to.midnight-1]
  end
end

