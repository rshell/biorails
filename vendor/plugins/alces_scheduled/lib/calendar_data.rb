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
    ##
    # Fill the calendar with items
    #  
    def fill(items)
      if items
        for item in items
           self.items << item         
           self.add_item(item.started_at, item)
           self.add_item(item.finished_at, item)
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
        n = time.to_date 
        if (n > self.started_at and n < self.finished_at)
           @boxes    ||= {}
           @boxes[n] ||= []
           @boxes[n] << item
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
