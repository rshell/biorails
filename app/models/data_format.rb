# == Schema Information
# Schema version: 359
#
# Table name: data_formats
#
#  id                 :integer(4)      not null, primary key
#  name               :string(128)     default(""), not null
#  description        :string(1024)    default(""), not null
#  default_value      :string(255)
#  format_regex       :string(255)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  data_type_id       :integer(4)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  format_sprintf     :string(255)
#

# == Description
# Data Formats define the rules for entry and display of data in the application. 
# They use Regular Expressions and C style Printf code to do this. For the uninitiated 
# these are in the are a little cryptic but they are well documented on the web.
#
#Data formats provide a mechanism for defining the precision of data captured in a data entry 
#sheet of a task, for example the number of significant figures or decimal points, whether 
#to allow scientific notation, URL validation.
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
class DataFormat < ActiveRecord::Base

  SCI_NUMBER         = %r{([+-]?\d*[\.,]?\d+(?:[Ee][+-]?)?\d*)}
  NUMBER_REGEX       = /#{SCI_NUMBER}*\s*(.+)?/
  UNIT_STRING_REGEX  = /#{SCI_NUMBER}*\s*([^\/]*)\/*(.+)*/

  NUMBER_FORMAT = [
    ["Any Number including scientific (eg 1.1E-07)",'[+-]?\d*[.]?\d+(?:[Ee][+-]?)?\d*)'],
    ["Time only  eg hh:mm:ss",'[+-]?[\d,:]*'],
    ["Integer only  eg nnnn",'[+-]?\d*'],
    ["Rational only eg nnnnn.nnnn",'[+-]?\d*[.]?\d'],
  ]
  DATE_FORMATS = [
    ['ISO year-month-day [eg 1999-01-31]','%Y-%m-%d'],
    ['USA month-day-year [eg 01-31-1999]','%m-%d-%Y'],
    ['UK day-month-year [eg 31-01-1999]','%d-%m-%Y'],
    ['ISO timestamp [eg 1999-01-31 23:59:00]','%Y-%m-%d %H:%M:%S'],
    ['USA timestamp [eg 01-31-1999 23:59:00]','%m-%d-%Y %H:%M:%S'],
    ['UK timestamp [eg 31-01-1999 23:59:00]','%d-%m-%Y %H:%M:%S'],
  ]
  acts_as_dictionary :name 
  # ## This record has a full audit log created for changes
  # 
  acts_as_audited :change_log
  # 
  # Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name,:case_sensitive=>false

  has_many :parameters, :dependent => :nullify
  has_many :assay_parameters,  :dependent => :nullify

  belongs_to :data_type

  # 
  # Test Whether this is in used in the database
  # 
  def used?
    return (assay_parameters.size > 0)
  end
  # 
  # Test if there is a input entry mask
  # 
  def mask?
    (self.format_regex and !self.format_regex.empty?  )
  end
  # 
  # Input mask to use to reading text
  # 
  def mask
    '(.*)' unless mask?
    self.format_regex
  end
  # 
  # Regexp version of the the mask
  # 
  def regexp
    Regexp.new(mask)
  end
  # 
  # Get the formating rule for output for use in sprintf
  # 
  def formatted
    return self.format_sprintf unless self.format_sprintf.empty?
    case self.data_type_id
    when 2 then "%g"
    when 3 then "%Y-%m-%d"
    when 4 then "%Y-%m-%d %H:%M:%S"
    else
      "%s"
    end
  end
  # 
  # Test if there is a output formatting rule
  # 
  def formatted?
    (self.format_sprintf and !self.format_sprintf.empty?  )
  end
  # 
  # Parse text with input mask
  # 
  def parse(text,options={})
    return "" if text.nil?      
    case self.data_type_id
    when 2
      return parse_number(text,options)
    when 3,4
      return parse_date(text,options)
    else 
      return parse_text(text,options)
    end
  rescue Exception =>ex    
    return nil
  end  
  # 
  # Format a value with the current printf rules
  # 
  def format(value,options={})
    return "" if value.nil?  
    case self.data_type_id
    when 2
      if value.is_a?(Numeric)
        format_number(value,options)
      else
        format_number(parse_number(value,options),options) 
      end 
    when 3,4
      if value.is_a?(Date) or value.is_a?(DateTime)
        format_date(value)
      else
        format_date(parse_date(value,options),options)
      end
    else 
      format_text(value)
    end
  rescue Exception =>ex  
    return nil
  end

  # 
  # Read a date mask
  # 
  def parse_date(text,options={})
    logger.debug  " convert date #{text} "
    date = nil
    if self.mask?
      return nil unless self.regexp =~ text.to_s
    end
    begin 
      date = Date.strptime(text.to_s, self.formatted)
    rescue
      begin
        date = Chronic.parse(text.to_s)
      rescue Exception => ex
        logger.debug "Failed to match #{text} with chronic #{ex.message}"
      end
    end
    return date    
  end
  #
  # parse a text 
  #
  def parse_text(text,options={})
    if self.mask?  
      m = self.regexp.match(text.to_s)
      return nil unless m
      m[0] 
    else
      text.to_s
    end        
  end
  #
  # Parse a number , using the unit passed in options as default
  #
  def parse_number(text,options={})
    if text=~ Unit::TIME_REGEX or text=~ Unit::FEET_INCH_REGEX or text=~ Unit::LBS_OZ_REGEX or text =~ Unit::RATIONAL_NUMBER
      Unit.new(text)
    elsif text =~ Unit::NUMBER_REGEX
      unit_text =$2
      unit_text = options[:unit] if $2.blank?
      text = $1
      if self.mask?
        m = self.regexp.match(text.to_s)
        return nil unless m
        text = m[0]
      end
      value = text.to_f
      return value if unit_text.empty?
      Unit.new(value,unit_text)
    else
      nil
    end
  end
  #
  # Print a text string
  #
  def format_text(value,options={})
    return  value.to_s unless self.formatted?
    sprintf(self.formatted, value)
  end
  #
  # Print a formatted number (units appended if present)
  #
  def format_number(value,options={})
    return "" unless value.is_a?(Numeric)
    return sprintf(self.formatted, value) unless value.is_a?(Unit)
    if  value.units == options[:unit] 
      return sprintf(self.formatted,value.scalar)     
    end        
    return "#{sprintf(self.formatted,value.scalar)} #{value.units}"     
  end  
  #
  # Print a formatted date string
  #
  def format_date(date,options={})
    return "" unless date.is_a?(Date) or date.is_a?(DateTime)
    date.strftime(self.formatted)
  end
  
  def to_s
    self.name
  end
  
end
