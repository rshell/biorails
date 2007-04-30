##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
#
#
module Alces
    # This implements auditing with a model table to fill audits
    #
    #   class User < ActiveRecord::Base
    #     acts_as_audited
    #   end
    #
    # Its is expecting the following fields in the class for local audit information
    # 
    #  t.column "lock_version", :integer, :default => 0, :null => false
    #  t.column "created_by_user_id", :integer, :default => 1, :null => false
    #  t.column "created_at", :datetime, :null => false
    #  t.column "updated_by_user_id", :integer, :default => 1, :null => false
    #  t.column "updated_at", :datetime, :null => false
    # 
    # 
    module ScheduledCollection #:nodoc:
          DEFAULT_SCHEDULE_SUMMARY = <<SQL
          case 
          when status_id in (0,1,2,3,4) and ended_at < current_date then 'overdue'
          when status_id in (0,1,2,3,4) and ended_at > current_date then 'todo'
          when status_id < 0  then 'failed'
          else 'done'
          end
SQL

       
          DEFAULT_SCHEDULE_ORDER = <<SQL 
          case 
          when status_id in (0,1,2,3,4) and ended_at < current_date then '1'
          when status_id in (0,1,2,3,4) and ended_at > current_date then '2'
          when status_id < 0  then '3'
          else '4'
          end, ended_at
SQL

      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods


        # == Configuration options

        #     class User < ActiveRecord::Base
        #       has_many_scheduled :tasks
        #     end
        # 
        def has_many_scheduled(scheduled_collection = :schedule, options = {})
        

          
          # don't allow multiple calls
          class_eval do

            has_many scheduled_collection ,{:order =>'started_at desc'}.merge(options) do
                ##
                # Important schedule items linked to this object with optional limit count (default=10)
                # The important is done via overdue ,future, aborted then completed items
                # 
                # stuff.schedule.importants(10)
                # 
                def importants(limit=10,options={})
                  with_scope :find => options  do
                    find(:all,:order=> DEFAULT_SCHEDULE_ORDER ,:limit=>limit  )
                  end  
                end
                ##
                # Overdue schedule items linked to this object with optional limit count (default=10)
                # 
                # stuff.schedule.overdue(10)
                # 
                def overdue(limit=10,options={})
                  with_scope :find => options  do
                    find(:all,:conditions=>['ended_at < ? and status_id in (0,1,2,3,4) ',Time.now],:limit=>limit  )
                  end  
                end
                ##
                # Current items for linked to this.
                # 
                # stuff.schedule.importants(10)
                #
                def current(limit=10,options={})
                  with_scope :find => options  do
                    find(:all,:conditions=>['? between started_at and ended_at and status_id in (0,1,2,3,4) ',Time.now],:limit=>limit  )
                  end
                end

                ##
                # Get a list of overlaping with the current time period
                # 
                # stuff.schedule.range(Time.now, Time.now + 5.days)
                #
                def range(date_from,date_to, limit=10, options={})
                  with_scope :find => options do
                    find(:all, :order => "started_at, ended_at", 
                          :conditions => ["( (started_at between  ? and  ? ) or (ended_at between  ? and  ? ) ) ",
                                           date_from, date_to, date_from, date_to] )
                  end                 
                end
                
                ##
                # get fill calenndar for the date range
                # 
                def calendar(data_from,months=1, options={})
                   calendar = CalendarData.new(data_from,months)
                   with_scope :find => options do
                     calendar.fill(find(:all, :order => "started_at, ended_at", 
                          :conditions => ["( (started_at between  ? and  ? ) or (ended_at between  ? and  ? ) ) ",
                                 calendar.started_at, calendar.finished_at, calendar.started_at, calendar.finished_at] ))
                  end                 
                  return calendar 
                end
                
                
                ##
                # get fill calenndar for the date range
                # 
                def add_into(calendar, options={})
                   with_scope :find => options do
                     calendar.fill(find(:all, :order => "started_at, ended_at", 
                          :conditions => ["( (started_at between  ? and  ? ) or (ended_at between  ? and  ? ) ) ",
                                   calendar.started_at, calendar.finished_at, calendar.started_at, calendar.finished_at] ))
                  end                 
                  return calendar 
                end
                
                                
                ##
                # count of items with a status accepts single or array
                # 
                # stuff.schedule.count_status([1,2,3])
                #  
                def count_status(object)
                   case object
                   when Array
                      count(:conditions=>"status_id in (#{object.join(',')})" )
                   else
                      count(:conditions=>['status_id=?',object])
                   end 
                end

                ##
                # Current items for linked to this.
                # 
                # stuff.schedule.future(10)
                #
                def future(limit=10,options={})
                  with_scope :find => options do
                    find(:all,:conditions=>[' started_at > ?  and status_id in (0,1,2,3,4) ',Time.now],:limit=>limit )
                  end
                end
                                
                ##
                # Summary of items 
                # 
                # stuff.schedule.summary
                # 
                # ==> [num_item,first_date,Last_date,state]
                # 
                #
                def summary_list(options={}) 
                  with_scope :find => options do
                    find(:all,:select => "count(*) num_items ,min(started_at) first_date,max(ended_at) last_date, #{DEFAULT_SCHEDULE_SUMMARY} state ",
                              :group => DEFAULT_SCHEDULE_SUMMARY )
                  end
                end
                
                def status_summary
                   summary_list.collect{|i|"#{i.state}:#{i.num_items}"}.join("/")
                end
                
                def summary
                    return "#{count_status(0)} / #{count_status([1,2,3,4])} / #{count_status([5,-1,-2])}"
                end
            end
            
          end
        end
      end
    
    end
end