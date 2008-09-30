# == Schema Information
# Schema version: 359
#
# Table name: analysis_settings
#
#  id                 :integer(4)      not null, primary key
#  analysis_method_id :integer(4)
#  name               :string(62)
#  script_body        :text
#  options            :text
#  parameter_id       :integer(4)
#  data_type_id       :integer(4)
#  level_no           :integer(4)
#  column_no          :integer(4)
#  io_mode            :integer(4)
#  mandatory          :string(255)     default("N")
#  default_value      :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# 
# This allow the saving on customized options for analysis methods associted with a protocol
#
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class AnalysisSetting < ActiveRecord::Base

 belongs_to :analysis,  :class_name =>'AnalysisMethod',:foreign_key =>'analysis_method_id'
 belongs_to :type,      :class_name =>'DataType',      :foreign_key =>'data_type_id'
 belongs_to :parameter, :class_name =>'Parameter',     :foreign_key =>'parameter_id'
 serialize :options

  def input?
    ((io_mode && 1) == 1)
  end

  def output?
    ((io_mode && 2) == 2)
  end

  def mode
   self.io_mode  
  end
  
  def mode=(value)
    self.io_mode = value
  end
  
  def io_style
   case io_mode
   when 1 then '[in]'
   when 2 then '[out]'
   when 3 then '[in/out]'
   else 
     '[script]'
   end
  end

  def script?
    !self.script_body.nil?
  end

  def style
    case level_no
    when 0
      'Value ' + io_style
    when 1
      'Array '+ io_style
    else
      'Manual '+ io_style
    end
  end
  
end
