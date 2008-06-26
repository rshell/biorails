# == Schema Information
# Schema version: 306
#
# Table name: analysis_settings
#
#  id                 :integer(11)   not null, primary key
#  analysis_method_id :integer(11)   
#  name               :string(62)    
#  script_body        :string(2048)  
#  options            :string(2048)  
#  parameter_id       :integer(11)   
#  data_type_id       :integer(11)   
#  level_no           :integer(11)   
#  column_no          :integer(11)   
#  io_mode            :integer(11)   
#  mandatory          :string(255)   default(N)
#  default_value      :string(255)   
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
# This allow the saving on customized options for analysis methods associted with a protocol
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
