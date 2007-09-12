##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
#
#
module Alces
    module ScheduledItem #:nodoc:
      ##
      # Allowed status values 
      #  
        NEW       =0
        ACCEPTED  =1
        WAITING   =2
        PROCESSING=3
        VALIDATION=4
        COMPLETED =5
        REJECTED  =-1
        ABORTED   =-2
        
      ###
      # Status to human readable version for display
      # 
      STATES = {NEW =>'new',
                ACCEPTED =>'accepted',
                WAITING =>'waiting',
                PROCESSING =>'processing',
                VALIDATION =>'validation',
                COMPLETED =>'completed',
                ABORTED=>'aborted',
                REJECTED =>'rejected'     }
                
      ##
      # This the the table of allowed state changes for the system
      #   
        STATE_CHANGES = {
                  nil        =>[NEW],
                  NEW        =>[NEW,ACCEPTED,REJECTED,WAITING,PROCESSING,VALIDATION,COMPLETED],
                  ACCEPTED   =>[ACCEPTED,WAITING,PROCESSING,VALIDATION,COMPLETED,REJECTED,ABORTED],
                  WAITING    =>[WAITING,PROCESSING,VALIDATION,COMPLETED,ABORTED],
                  PROCESSING =>[WAITING,PROCESSING,VALIDATION,COMPLETED,ABORTED],
                  VALIDATION =>[WAITING,PROCESSING,VALIDATION,COMPLETED,ABORTED],
                  COMPLETED  =>[COMPLETED,REJECTED],
                  ABORTED    =>[ABORTED,NEW],
                  REJECTED   =>[REJECTED,NEW]
                  }  
        ##
        # Collective state group names
        # 
        NEW_STATES = [nil,NEW]
        PAUSED_STATES = [NEW,ACCEPTED,WAITING]
        ACTIVE_STATES = [ACCEPTED,WAITING,PROCESSING,VALIDATION]
        FINISHED_STATES= [REJECTED,ABORTED,COMPLETED]
        FAILED_STATES = [REJECTED,ABORTED]

      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods


        # == Configuration options
    # This implements use of the object as a scheduled item with status in most cases a simple
    #    
    #      acts_as_scheduled
    #      
    # This expects the following fields in the table
    # 
    #  t.column :status_id,  :integer, :default => 0, :null => false
    #  t.column :started_at,  :datetime, :null => false
    #  t.column :expected_at, :datetime, :null => false
    #  t.column :ended_at,    :datetime
    #  
    #  By default it uses the state and state_changes from this plugin for management of the status.
    #  If needed all these values can be over ridden
    #   
    #     acts_as_scheduled  :status => :status_id, 
    #                        :started_at=>:started_at ,
    #                        :ended_at =>:ended_at,
    #                        :expected_at => :expected_at
    #                        :states => {0=>'new',-1=> 'reject',1=>'active',2=>'completed'}
    #                        :state_changes => { 0 => [1,2,3], 1=>[2,-1], 2=> [1,-1], -1=>[0]}
    #                        :active => [0,1]
    #                        :finished => [-1,2]
    #                        :failed => [-1]
    #                        
    #                        
    #   end
    #
    # Its is expecting the following fields in the class for local audit information
    # 
    # 
        def acts_as_scheduled(options={})
          
          # don't allow multiple calls
          class_eval do
          
            write_inheritable_attribute(:scheduled_summary,   options[:summary]   )

            write_inheritable_attribute(:schedule_states,         options[:states] || STATES )
            write_inheritable_attribute(:schedule_state_changes,  options[:state_changes] || STATE_CHANGES )
            write_inheritable_attribute(:schedule_state_active,   options[:state_active] || ACTIVE_STATES )
            write_inheritable_attribute(:schedule_state_finished, options[:state_finished] || FINISHED_STATES )
            write_inheritable_attribute(:schedule_state_failed,   options[:state_failed] || FAILED_STATES )



            class_inheritable_reader :scheduled_summary


            class_inheritable_reader :schedule_states
            class_inheritable_reader :schedule_state_changes
            class_inheritable_reader :schedule_state_active
            class_inheritable_reader :schedule_state_finished
            class_inheritable_reader :schedule_state_failed
        
          end

          return if self.included_modules.include?(Alces::ScheduledItem::InstanceMethods)
          include Alces::ScheduledItem::InstanceMethods         


        end
      end
#######################################################################################
# Add to model class
# 
      module SingletonMethods
          # Executes the block with the auditing callbacks disabled.
          #
          #   Foo.without_auditing do
          #     @foo.save
          #   end
          #
        ##
        # Test if state change is valid
        # 
         def allowed_change?(old_id,new_id)
            self.schedule_state_changes[old_id.to_i].include?(new_id.to_i)
         end

      end # module SingletonMethods
      

#######################################################################################
# Add to model Instance
# 
      module InstanceMethods
        ##
        # Test if state change is valid
        # 
         def is_allowed_state(new_id)
            self.schedule_state_changes[self.status_id].include?(new_id.to_i)
         end
        
        ##
        # Get the current status_id value
        #  
         def state_id
            self.status_id
         end
        ##
        # Change the current status_id if allowed and return the value
        # 
         def state_id=(new_id)
            new_id = new_id.to_i 
            if is_allowed_state(new_id) and new_id != self.status_id 
              self.status_id = new_id
              if self.is_active
                 self.started_at ||= Time.new  
              end
              if self.is_finished
                 self.started_at ||= Time.new 
                 self.ended_at = Time.new 
              end
              self.updated_at = Time.new  if self.respond_to?(:updated_at)
            end
            ##
            #update dependent items with overall progress
            #
            if scheduled_summary
                items = self.send(scheduled_summary)
                for item  in items
                    item.status_id = new_id if (new_id>item.status_id)
                end    
            end
            self.status_id
         end
        ##
        # Get the status of the object  
        # 
         def status
           return self.schedule_states[self.status_id]
         end

          ##
        # Change the status of the object
        # 
         def status=(value)
            case value
            when Fixnum
              self.status_id = value
            when String
              self.status_id =  self.schedule_states.invert[value]  
            else
              self.status_id == value.id
            end
            return  self.schedule_states[self.status_id]
         end
         
         
         ##
         #
         #
         def status_summary
          return self.status unless scheduled_summary   
          out = "["
          tmp = self.send(scheduled_summary) || []
          out << tmp.size.to_s
          out << '| ' << tmp.inject(0){|sum, item| sum + (item.is_active ? 1 : 0 )}.to_s
          out << '| ' << tmp.inject(0){|sum, item| sum + (item.is_finished ? 1 : 0 )}.to_s
          out << ']'
         end
      
         
        ##
        # Get a list of  
         def allowed_status_list
           list = []
           for item in self.schedule_state_changes[self.status_id]
             list << [self.schedule_states[item],item]
           end
           return list
         end
        
        ##
        # Is the object in this state
         def is_status(value)
            case value
            when Fixnum
              return self.status_id == value
            when String
              return self.status == value
            when Array
              return value.include?(self.status_id)  
            else
              return self.status_id == value.id
            end
         end
          ##
          # Test whether this recording is activily being worked on 
           def is_active
             return schedule_state_active.include?(self.status_id)
           end
          
          ##
          # Test whether work is completed with this object
             def is_finished
               return schedule_state_finished.include?(self.status_id)
             end

            ##
          # Test whether the object has failed 
          # 
           def has_failed
             return schedule_state_failed.include?(self.status_id)   
           end
           
           
           def finished_at
              return self.ended_at    if self.ended_at
              return self.expected_at if self.expected_at
              return Time.new+ 7.days unless scheduled_summary   
              tmp = self.send(scheduled_summary) || []
              tmp.collect{|item|item.finished_at}.max
           end

          ##
          #get the default period of time for a task
          #
           def period 
             if finished_at > started_at 
                (finished_at.to_time - started_at.to_time) 
             else
                1
             end
           end
           
           def starting?(day = Time.new )
             return  (!started_at.nil? and  day.to_date == started_at.to_date)
           end
           
           def ending?(day = Time.new )
             return (!finished_at.nil? and day.to_date == finished_at.to_date)
           end
           
           def current?(day = Time.new )
              return (self.start_at < day and (self.ended_at.nil? or self.ended_at>day ))
           end
           
           def overdue?
              return (self.start_at < Time.new  and (!self.expected_at.nil? and self.expected_at<Time.new  ))
           end
      end    
    end
end