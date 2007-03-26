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


class Schedule
  attr_accessor :items
  attr_accessor :boxes
  attr_accessor :first
  attr_accessor :last
  attr_accessor :delta

##
#  Default initialize with a empty week,
#  
def initialize
   @boxes = []
   @items = []
   @first = DateTime.now
   @last  = DateTime.now + 7.days
   @delta = 1.day
end

##
# Calculate the period of the schedule 
#
def period
  return @last - @first
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
#Build a schedule of tasks in the passed in experiment (the scientists views)  
#  
def Schedule.tasks_in(experiment)
   schedule = Schedule.new
   if experiment.tasks.size > 0
     schedule.first = experiment.start_date.at_beginning_of_day
     schedule.last = experiment.end_date + 24.hours 
     schedule.default_delta
     schedule.fill(experiment.tasks)
   end
   return schedule
end

##
#Build a schedule of experiments in study ( the project management view) 
#  
def Schedule.experiments_in(study)
   schedule = Schedule.new
   if study.experiment.size > 0
     schedule.first = study.start_date.at_beginning_of_day
     schedule.last = study.end_date + 24.hours 
     schedule.default_delta
     schedule.fill(study.experiment)
   end
   return schedule
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