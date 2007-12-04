# == Schema Information
# Schema version: 281
#
# Table name: data_formats
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  description        :text          
#  default_value      :string(255)   
#  format_regex       :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  data_type_id       :integer(11)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#  format_sprintf     :string(255)   
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class DataFormat < ActiveRecord::Base
  included Named
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name

  has_many :parameters, :dependent => :destroy
  has_many :study_parameters, :dependent => :destroy

  belongs_to :data_type

  def self.content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ || c.name == inheritance_column }
  end

#
# Test Whether this is in used in the database
#  
  def used?
    return (study_parameters.size > 0 or  parameters.size>0)
  end 
#
# Format a value with the current printf rules
#
  def format(value)
      return "" if value.nil?  
      logger.info "format #{value.class} #{value}"
     if format_sprintf
       case value
       when Unit
          return sprintf(format_sprintf,value.scalar,value.units)         
       when DateTime,Date,Time
          return value.strftime(format_sprintf)
       else   
          return sprintf(format_sprintf, value)
       end
    end
     value.to_s
  end

end
