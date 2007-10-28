##
#
# Copyright © 2006 Alces Ltd All Rights Reserved
# Author: Robert Shell
# See license agreement for additional rights
# 
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
#The schedule is expecteding the base queue to contain the following attibtures
#
#  status_id           :integer(11)   Status  
#  is_milestone        :boolean(1)    milestone flag to change icon
#  priority_id         :integer(11)   priority
#  started_at          :datetime      start
#  ended_at            :datetime      end
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

def scale
  zoom = 1
  zoom.times { zoom = zoom * 2 }
  subject_width = 260
  header_heigth = 18
  headers_heigth = header_heigth
  show_weeks = false
  show_days = false
  
  if zoom >1
      show_weeks = true
      headers_heigth = 2*header_heigth
      if zoom > 2
          show_days = true
          headers_heigth = 3*header_heigth
      end
  end
  g_width = (date_to - date_from + 1)*zoom
  g_height = [(20 * items.length + 6)+150, 206].max
  t_height = g_height + headers_heigth
end

##
# Get a list of items for this date
# 
def for_day(day)
  for item in @items
    day_issues << i if item.send(@options[:start]).to_date == day or item.send(@options[:end]).to_date == day 
  end
  return day_issues
end


def icon(item,day)
  if item.send(@options[:start]).to_date == day and item.send(@options[:end]).to_date == day
  image_tag('arrow_bw.png')
      
  elsif item.send(@options[:start]).to_date == day
    image_tag('arrow_from.png') 
    
  elsif item.send(@options[:end]).to_date == day
    image_tag('arrow_to.png') 
  end   
end


def link(item)

end

#
# Months headers
#
def to_month_header
  out = ""
  month_f = @date_from
  left = 0
  height = (show_weeks ? header_heigth : header_heigth + g_height)
  @months.times do 
      width = ((month_f >> 1) - month_f) * zoom - 1
      out << " <div style='left:#{left}px; width:#{width}px; height:#{height}px;' class='gantt_hdr'>"
      out << link_to( "#{month_f.year}-#{month_f.month}", { :year => month_f.year, :month => month_f.month, :zoom => @zoom, :months => @months }, :title => "#{month_name(month_f.month)} #{month_f.year}")
      out << '</div>'
      left = left + width + 1
      month_f = month_f >> 1
  end 
end

#
# Weeks headers
#
def  html_week_header
  out = ""
  if show_weeks  
    left = 0
    height = (show_days ? header_heigth-1 : header_heigth-1 + g_height)
    if @date_from.cwday == 1
        # @date_from is monday
          week_f = @date_from
    else
        # find next monday after @date_from
      week_f = @date_from + (7 - @date_from.cwday + 1)
      width = (7 - @date_from.cwday + 1) * zoom-1

      out << "<div style='left:#{left}px; top:19px; width:#{width}px; height:#{height}px;' class='gantt_hdr'>&nbsp;</div>"

      left = left + width+1
    end 

    while week_f <= @date_to
      width = (week_f + 6 <= @date_to) ? (7 * zoom -1) : (@date_to - week_f + 1) * zoom-1

      out << "<div style='left:#{left}px;top:19px;width:#{width}px;height:#{height}px;' class='gantt_hdr'>"
      out << '<small><%= week_f.cweek if width >= 16 %></small>'
      out << '</div>'
      left = left + width+1
      week_f = week_f+7
    end
  end 
end

#
# Days headers
#
def html_day_heder
  left = 0
  height = g_height + header_heigth - 1
  wday = @date_from.cwday
    (@date_to - @date_from + 1).to_i.times do 
	width =  zoom - 1
	
	<div style="left:<%= left %>px;top:37px;width:<%= width %>px;height:<%= height %>px;font-size:0.7em;<%= "background:#f1f1f1;" if wday > 5 %>" class="gantt_hdr">
	<%= day_name(wday)[0,1] %>
	</div>
	 
	left = left + width+1
	wday = wday + 1
	wday = 1 if wday > 7
  end
end

def to_html
  out = to_month_header
  out << html_week_header << if show_weeks
  out << html_day_header << if show_days    
  end
end
