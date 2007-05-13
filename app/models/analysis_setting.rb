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
    ((mode && 1) == 1)
  end

  def output?
    ((mode && 2) == 2)
  end

  def io_style
   case mode
   when 1 : '[in]'
   when 2 : '[out]'
   when 3 : '[in/out]'
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
      'Manual'+ io_style
    end
  end
  
  def update(params={})
    params.stringify_keys!
    for item in params.keys
       send(item.to_s + '=', params[item] ) if self.attributes[item]
    end
  end
end
