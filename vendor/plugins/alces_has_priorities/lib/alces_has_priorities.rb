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
    module HasPriorities #:nodoc:
        ##
        # Allowed status values 
        #  
          LOW    =0
          NORMAL =1
          HIGH   =2

        ###
        # Status to human readable version for display
        # 
          PRIORITIES = {NORMAL =>'normal',
                        LOW=>'low',
                        HIGH =>'high',
                        nil =>'undefined' }
                      
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
        def has_priorities(field = :priority_id, options={} )
          include Alces::HasPriorities::InstanceMethods         
          extend Alces::HasPriorities::SingletonMethods

        end
      end
#######################################################################################
# Add to model class
# 
      module SingletonMethods

         def allowed_priority_list
           list = []
           for item in PRIORITIES.keys
             list << [PRIORITIES[item],item]
           end
           return list    
        end
      end # module SingletonMethods
      

#######################################################################################
# Add to model Instance
# 
      module InstanceMethods
  
        def priority
         return PRIORITIES[self.priority_id]   
        end          

         def allowed_priority_list
           list = []
           for item in PRIORITIES.keys
             list << [PRIORITIES[item],item]
           end
           return list    
        end
        
        def priority=(value)
          case value
          when Fixnum
            self.priority_id = value
          when String
            self.priority_id =  PRIORITIES.invert[value]  
          else
            self.priority_id == value.id
          end
          return  PRIORITIES[self.priority_id]
        end
  
      end    
    end
end
