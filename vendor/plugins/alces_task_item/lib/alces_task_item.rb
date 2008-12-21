# AlcesTaskItem
# AlcesHasPriorities
##
# Copyright © 2006 Alces Ltd All Rights Reserved
# Author: Robert Shell
# 
# See license agreement for additional rights
##
#
#
#
module Alces
  module TaskItem #:nodoc:

    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods

      # == Configuration options
      # This implements use of the object as a scheduled item with status in most cases a simple
      #
      #      has_priorities :priority_id, :allowed => { 0=> :low, 1=>:normal, 2 =>:high }
      #
      #
      # Its is expecting the following fields in the class for local audit information
      #
      #
      def acts_as_task_item( options={:id=>:data_id,
            :name=>:data_name,
            :type=>:data_type} )
                                    
        include Alces::TaskItem::InstanceMethods
        extend Alces::TaskItem::SingletonMethods

      end
    end
    #######################################################################################
    # Add to model class
    #
    module SingletonMethods

    end # module SingletonMethods
      

    #######################################################################################
    # Add to model Instance
    #
    module InstanceMethods
      #
      # Name of a task item based on parameter used
      #
      def name
        return parameter.name if parameter
      end

      def label
        return "#{name}[#{context.label}]" if context
        "#{name}[]"
      end

      #
      # column_no in the overall protocol grid
      #
      def column_no
        return parameter.column_no if (parameter_id && parameter)
        return -1
      end
      #
      #Get the row number of the value in task grid
      #
      def row_no
        return context.row_no if (task_context_id && context)
      end
      ##
      # Current experiment for this Value
      #
      def experiment
        context.task.experiment if context and context.task
      end

      ##
      # Current process for this Value
      #
      def process
        context.task.process if context and context.task
      end
      #
      # get the formula
      #
      def formula
        parameter.default_value if parameter
      end

      ##
      # Test whether Item is linked to a old version of process Instance
      # Useful for auditing rules applied when the data was captured
      # (old data does become invalid as process adapts unless resync is done)
      #
      def is_old_version
        return ( parameter.process == context.task.process)
      end

      def to_s
        return "#{context.to_s}[#{self.name}]=#{self.value}"
      end

  
    end
  end
end
