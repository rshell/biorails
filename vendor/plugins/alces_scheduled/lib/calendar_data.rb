##
# Copyright © 2006 Alces Ltd All Rights Reserved
# Author: Robert Shell
# See license agreement for additional rights
##
#
require 'icalendar'
require 'date'

   class CalendarData
      attr_accessor :items
      attr_accessor :boxes
      attr_accessor :months
      attr_accessor :started_at
      attr_accessor :finished_at
      attr_accessor :first_date
      attr_accessor :last_date
      
      
    ##
    #  Initialize calendar with rounting of to neverest months
    #  
    def initialize(started, months=1 )
      @started_at  = Date.civil(started.year,started.month,1)
      @months = months
      if started.month==12
         @finished_at = Date.civil(started.year+1, 1 ,1 )
      else
         @finished_at = Date.civil(started.year, started.month + 1 ,1 )
      end 
    # start on monday
    # finish on sunday
      @first_date ||= @started_at - (@started_at.cwday-1)
      @last_date ||= @finished_at + (7-@finished_at.cwday)  
  
      #
      # fill with boxes for items
      # 
      @boxes = {}
      day = self.started_at
      while day <= self.finished_at
            @boxes[day] = []
            day += 1.day
       end
       @items = []
       @delta = 1.day
    end
    
    def self.find_boxed(klass,folder,states,started_at, finished_at)
    sql = <<-SQL
exists ( 
 select 1 from project_elements
        where project_elements.left_limit>= #{folder.left_limit}
        and project_elements.right_limit <= #{folder.right_limit}
        and project_elements.project_id  =  #{folder.project_id}
        and project_elements.reference_type='#{klass.class_name}'
        and project_elements.state_id in ( #{ states.keys.join(',') } )
        and #{klass.table_name}.id = project_elements.reference_id )
    and (   (#{klass.table_name}.started_at  between  ? and  ? )
        or (#{klass.table_name}.expected_at between  ? and  ? ) )
SQL
      list = klass.list(:all,
                   :order => "#{klass.table_name}.started_at, #{klass.table_name}.ended_at",
                   :conditions => [ sql,  started_at, finished_at, started_at, finished_at] )
      
    end

    def add_model_from_folder_tree(klass,folder,states)
      list = CalendarData.find_boxed(klass,folder,states, started_at, finished_at )
      self.fill(list)                     
    end
    
    ##
    # Fill the calendar with items
    #  
    def fill(items)
      if items
        for item in items
           self.items << item         
           self.add_item(item.started_at, item)
           self.add_item(item.expected_at, item)
        end
      end
      return items
    end
    
    def next_month
      Date.civil(@finished_at.year,@finished_at.month,1)         
    end
    
    def last_month
      return Date.civil(@started_at.year-1,12,1) if  @started_at.month == 1
      Date.civil(@started_at.year,@started_at.month-1,1)
    end    
    
    ##
    # Add items to calendar
    #
    def add_item(time,item)
      if time
        case time
        when Time then   n = time.to_datetime.to_date
        when DateTime then   n = time.to_date
        when Date then   n = time
        else n =time.to_date
        end
        if (n >= self.started_at and n <= self.finished_at)
           @boxes    ||= {}
           @boxes[n] ||= []
           unless @boxes[n].any?{|i|i == item}
             item.logger.info "added #{item.dom_id} #{item.name}"
             @boxes[n] << item
           end
        else   
           item.logger.info "not added #{item.class} #{item.name} [#{n} > #{self.started_at}] [#{n} < #{self.finished_at}]"
        end
      end
    end
    ##
    # Get the items for a day 
    #
    def for_day(day)
       list = @boxes[day.to_date] || []
       list.sort{|a,b|a.id <=> b.id}
    end
  
    def core?(day)
      return day.cwday<6     
    end

    def in_range?(day)
      return (day>=started_at and day <finished_at)     
    end
    
    
    def to_ical
     cal = Icalendar::Calendar.new
     for item in items
         event = cal.event 
         event.start = item.started_at
         event.dtend = item.finished_at
         event.description = item.description
         event.summary = item.name
         event.status = item.status
      end
      return cal.to_ical
    end
    
  end
