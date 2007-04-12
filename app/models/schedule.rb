##
# Build a schedule for display on forms
# This consists of a collection of date boxes with linked list of items in the boxes
# 
#  schedule.first  starting date
#  schedule.last   finishing date
#  schedule.delta  size of a date period box
#  schedule.boxes[n] start date of a date box
#  schedule.items[n] array of things scheduled in period
#
# Constructors
# 
#  schedule = Schedule.tasks_in(experiment)
#  schedule = Schedule.experiments_in(study)
#  
#  Hope later to add work_on(inventory_item) etc 
#  
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 


##
#The schedule is expecteding the base queue to contain the following attibtures
#
#
#  status_id           :integer(11)   Status  
#  is_milestone        :boolean(1)    milestone flag to change icon
#  priority_id         :integer(11)   priority
#  start_date          :datetime      start
#  end_date            :datetime      end
#  expected_hours      :float         
#  done_hours          :float    
#
#
class Schedule

  attr_accessor :items
  attr_accessor :boxes
  attr_accessor :first
  attr_accessor :last
  attr_accessor :delta

  attr_accessor :model
  attr_accessor :filter
  attr_accessor :options

  attr_accessor :year
  attr_accessor :year_from
  attr_accessor :month
  attr_accessor :month_from
  attr_accessor :months
  attr_accessor :zoom
 

##
#  Default initialize with a empty week,
#  
def initialize(model = Task,options={})
   @options = options
   @options[:data_from] ||= DateTime.now
   @options[:data_to]   ||= DateTime.now + 7.days
   @options[:delta]     ||=  1.day
   @options[:start]     ||= 'created_at'
   @options[:end]       ||= 'updated_at'
   @options[:filter]    ||= nil
   @options[:model]     ||= model.to_s
   @boxes = []
   @items = []
   @first = DateTime.now
   @last  = DateTime.now + 7.days
   @delta = 1.day
   @model = model
end

def date_from
  @options[:data_from].to_date
end

def date_from=(date)
  @options[:data_from] = date
end

def date_to
  @options[:data_to].to_date
end

def date_to=(date)
  @options[:data_to] = date
end
##
# get a select filter 
# 
def filter
  @options[:filter] 
end
##
# set a select filter 
# 
def filter=(conditions)
  @options[:filter] = conditions  
end
# Calculate the period of the schedule 
#
def period
  return @options[:data_to].to_d - @options[:data_from].to_s
end
##
# Get a list of all the events in the schedule
 def events
   items.flatten
 end
##
# Get the number of time boxes in the schedule 
# each box will have a size of delta<time>
#  
 def size
   boxes.size
 end

##
# get the current conditions filter for querying
# 
#  :start defaults created_at
#  :end  defaults updated_at
#  :filter  defaults project_id
#  
def refresh(options={})
   options = @options.merge(options)

   if (@model and options[:data_from] and options[:data_to])
     if @filter
       @items = @model.find(:all, :order => "#{options[:start]}, #{options[:end]}", 
         :conditions => ["((#{options[:start]} between  ? and  ? ) or (#{options[:end]} between  ? and  ? )) and ( #{filter[0]} )",
                           date_from, date_to, date_from, date_to, filter[1] ])
     else
       @items = @model.find(:all, :order => "#{options[:start]}, #{options[:end]}",
         :conditions => ["((#{options[:start]} between  ? and  ? ) or (#{options[:end]} between  ? and  ? ))",
                           date_from, date_to, date_from, date_to ])
     end
   end
end

##
# setup a calender from parameters
# 
def calendar(params={})
    options  = @options.merge(params)
    if options[:year] and options[:year].to_i > 1900
      self.year = options[:year].to_i
      if options[:month] and options[:month].to_i > 0 and options[:month].to_i < 13
        self.month = options[:month].to_i
      end    
    end

    self.year ||= Date.today.year
    self.month ||= Date.today.month
    self.months = 1
    self.date_from = Date.civil(self.year, self.month, 1)
    self.date_to = (self.date_from >> 1)-1
    # start on monday
    self.date_from = self.date_from - (self.date_from.cwday-1)
    # finish on sunday
    self.date_to = self.date_to + (7-self.date_to.cwday)  
    return self    
end

##
# Setup schedule for a gnatt
def gnatt(params)
    if options[:year] and options[:year].to_i >0
      self.year_from = options[:year].to_i
      if options[:month] and options[:month].to_i >=1 and options[:month].to_i <= 12
        self.month_from = options[:month].to_i
      else
        self.month_from = 1
      end
    else
      self.month_from ||= (Date.today << 1).month
      self.year_from ||= (Date.today << 1).year
    end
    
    self.zoom = (options[:zoom].to_i > 0 and options[:zoom].to_i < 5) ? options[:zoom].to_i : 2
    self.months = (options[:months].to_i > 0 and options[:months].to_i < 25) ? options[:months].to_i : 6
    
    self.date_from = Date.civil(year_from, month_from, 1)
    self.date_to = (self.date_from >> self.months) - 1
end

##
#Build a schedule of data for subject (the analysts views) 
#  
def Schedule.results_for(subject)
   schedule = Schedule.new
   sql =<<-SQL 
      select * from task_contexts c,task_references r 
      where c.id=r.task_context_id 
      and r.data_type='#{subject.class}' and r.data_id=#{subject.id}'
SQL
   contexts = TaskContext.find_by_sql(sql)
   if contexts.size > 0
     first = TaskReference.find_by_type(subject, :order_by => 'created_at asc')
     last = TaskReference.find_by_type(subject, :order_by => 'updated_at desc')
     schedule.first = first.created_at.at_beginning_of_day
     schedule.last = last.updated_at + 24.hours 
     schedule.default_delta
     schedule.fill(contexts)
   end
   return schedule
end

def fill(values)
   from = @first
   to = @first+ @delta
   while from < @last
      @boxes << from 
      @items << values.reject{|item| item.start_date < from or item.start_date >= to}
      from += @delta 
      to += @delta
   end
end

##
# Calculate the size of a cell in the schedule
# 
def default_delta
  @delta = 1.month      
  @show_month = true
  if self.period < 4.weeks
      @show_month = false
      @delta = 1.day        
  elsif self.period < 2.month
      @delta = 1.weeks
  end
  return delta
end

end