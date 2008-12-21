##
# Copyright © 2006 Alces Ltd All Rights Reserved
# Author: Robert Shell
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
    ACTIVE    =1
    COMPLETED =2
    PUBLISHED =3
    ABORTED   =-1
        
    ###
    # Status to human readable version for display
    #
    STATUS = {NEW =>'new', ACTIVE =>'accepted', COMPLETED =>'completed', PUBLISHED =>'published',  ABORTED =>'rejected'}
                 

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
          class_inheritable_reader :scheduled_summary

        end

        return if self.included_modules.include?(Alces::ScheduledItem::InstanceMethods)
        include Alces::ScheduledItem::InstanceMethods


      end
    end
    #######################################################################################
    # Add to model Instance
    #
    module InstanceMethods
      
      def state
        return State.find(:first) unless self.folder and self.folder.state
        self.folder.state 
      end

      def state=(new_state)
        self.folder.set_state(new_state) if self.folder
      end
      ##
      # Get the current status_id value
      #
      def state_id
        self.folder.state_id if self.folder
      end
      ##
      # Change the current status_id if allowed and return the value
      #
      def state_id=(new_id)
        self.folder.set_state(new_id) if self.folder
      end

      def allowed_status_list
        if self.new_record? or self.folder.nil?
          return [State.find(:first)]
        end
        self.folder.state_flow.next_states(state_id)
      end
      ##
      # Get the status of the object
      #
      def status
        return state.name
      end

      ##
      # Is the object in this state
      def status?(value)
        case value
        when Fixnum
          return self.state_id == value
        when String
          return self.status == value
        when Array
          return value.include?(self.state_id)
        else
          return self.state_id == value.id
        end
      end

      def unused?
        status_id==0
      end

      def active?
        state.active?
      end

      def aborted?
        state.ignore?
      end

      def published?
        state.published?
      end

      def finished?
        completed? or aborted?
      end

      def completed?
        state.completed?
      end
      ##
      #
      #
      def status_summary
        return self.status unless scheduled_summary
        out = "["
        tmp = self.send(scheduled_summary) || []
        out << tmp.size.to_s
        out << '| ' << tmp.inject(0){|sum, item| sum + (item.active? ? 1 : 0 )}.to_s
        out << '| ' << tmp.inject(0){|sum, item| sum + (item.finished? ? 1 : 0 )}.to_s
        out << ']'
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

      def validate_period
        if started_at and expected_at
          a = started_at.to_time
          b = expected_at.to_time
          errors.add(:started_at,"cant parse date #{started_at} => #{a}") unless a
          errors.add(:expected_at,"cant parse date #{expected_at} => #{b}") unless b
          errors.add(:expected_at,"expected_at #{b} should be greater then started_at #{a}") unless a and b and b >= a
        end
      end
           
      def starting?(day = Time.new )
        return  (!started_at.nil? and  day.to_date == started_at.to_datetime.to_date)
      end
           
      def ending?(day = Time.new )
        return (!finished_at.nil? and day.to_date == finished_at.to_datetime.to_date)
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
