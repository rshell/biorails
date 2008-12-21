##
# Copyright © 2006 Alces Ltd All Rights Reserved
# Author: Robert Shell
# See license agreement for additional rights
##
#
#
#
module Alces
    module WorkflowItem #:nodoc:
 
      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods


        # == Configuration options
    # This implements use of the object as a scheduled item with status in most cases a simple
    #    
    #
    # Its is expecting the following fields in the class for local audit information
    # 
    # 
        def has_state(options={})

          configuration = { :workflow => :default,:class_name=>'State'}.merge(options)      
          class_inheritable_reader :default_workflow
          write_inheritable_attribute(:default_workflow,   configuration.delete(:workflow) )        

          
          extend Alces::WorkflowItem::SingletonMethods
          include Alces::WorkflowItem::InstanceMethods         
        end
      end
#######################################################################################
# Add to model class
# 
      module SingletonMethods
        # 
         def live(*args)
           self.with_scope( :find => {:include=>{:project_element=>:state},:conditions=>['states.level_no between ? and ?',State::ACTIVE_LEVEL,State::FROZEN_LEVEL]} )  do
             list(*args)
           end
         end
        
         def pending(*args)
           self.with_scope( :find => {:include=>{:project_element=>:state},:conditions=>['states.level_no between ? and ?',0,State::ACTIVE_LEVEL-1]} )  do
             list(*args)
           end
         end

         def published(*args)
           self.with_scope( :find => {:include=>{:project_element=>:state},:conditions=>['states.level_no >= ?',State::PUBLIC_LEVEL]} )  do
             find(*args)
           end
         end

      end # module SingletonMethods
      

#######################################################################################
# Add to model Instance
# 
      module InstanceMethods

        ##
        # Get the current status_id value
        #  
         def state_id
            self.project_element.state_id if self.project_element
         end

         def state
            self.project_element.state if self.project_element
         end
         
         def status
           ((self.project_element and self.project_element.state) ? self.project_element.state.name : nil)
         end
         
         ##
         #
         #
         def status_summary
          return self.status unless scheduled_summary   
          out = "["
          tmp = self.send(scheduled_summary) || []
          out << tmp.size.to_s
          out << '| ' << tmp.inject(0){|sum, item| sum + (item.state.active? ? 1 : 0 )}.to_s
          out << '| ' << tmp.inject(0){|sum, item| sum + (item.state.completed? ? 1 : 0 )}.to_s
          out << ']'
         end
      

      end    
    end
end
