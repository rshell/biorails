##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
module  Named 
#
# Overide context_columns to remove all the internal system columns.
# 
  def self.content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ || c.name == inheritance_column }
  end

  def to_s
    return "#{self.dom_id} #{self.name}"
  end
  
##
# Simple rules for name generation for various data type in the system
#   
  def Named.generator(object)
    case object
    when RequestService
      return "RS-#{object.id}"    
    when Task
      return "T-#{object.id}"    
    when Experiment
      return "E-#{object.id}"    
    when Study
      return "S-#{object.id}"    
    when StudyProtocol
      return "SP-#{object.id}"    
    when QueueItem
      return "QI-#{object.id}"    
    when StudyQueue
      return "#{object.study.name}-#{object.id}"    
    when RequestService
      return "RS-#{object.request.id}-#{object.service.id}"    
    when Request
      return "R-#{object.id}"      
    when Compound
      return "C-#{object.id}"
    when Batch
      return "#{object.compound.name}-#{object.id}"
    else
      return object.dom_id     
    end
  end
end