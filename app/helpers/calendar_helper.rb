# CalendarHelper allows you to draw a databound calendar with fine-grained CSS formatting
# Copyright (C) 2005 Jeremy Voorhis, Shachaf Ben-Kiki
# Modified (C) 2006 ProjectLounge.com Inc, Ian Connor
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


module CalendarHelper

   NTHDAY = ["0","1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th",
                  "11th", "12th", "13th", "14th", "15th", "16th", "17th", "18th", "19th", "20th",
                  "21st", "22nd", "23rd", "24th", "25th", "26th", "27th", "28th", "29th", "30th",
                  "31st"]
  # Returns an HTML calendar. In its simplest form, this method generates a plain
  # calendar (which can then be customized with CSS) for a given month and year.
  # However, this may be customized in a variety of ways -- changing the default CSS
  # classes, generating the individual day entries yourself, and so on.
  # 
  # The following options are required:
  #  :year  # The  year number to show the calendar for.
  #  :month # The month number to show the calendar for.
  # 
  # The following are optional, available for customizing the default behaviour:
  #   :table_class       => "calendar"        # The class for the <table> tag.
  #   :month_name_class  => "monthName"       # The class for the name of the month, at the top of the table.
  #   :other_month_class => "otherMonthClass" # Not implemented yet.
  #   :day_name_class    => "dayName"         # The class is for the names of the weekdays, at the top.
  #   :day_class         => "day"             # The class for the individual day number cells.
  #                                             Not used if you specify a block (see below).
  #   :abbrev            => (0..2)            # This option specifies how the day names should be abbreviated.
  #                                             Use (0..2) for the first three letters, (0..0) for the first, and
  #                                             (0..-1) for the entire name.
  #   :block             => nil               # This option is a code block that gets one argument, a Date object,
  #                                             and returns a value that should be similiar to "<td>n</td>", where
  #                                             n is Date#mtime for the date object. If this option or a code
  #                                             block are not given, a default of "<td>n</td>" is used.
  # 
  # Example usage:
  #   calendar(:year => 2005, :month => 6) # This generates the simplest possible calendar.
  #   calendar({:year => 2005, :month => 6, :table_class => "calendar_helper"})
  def calendar(options = {}, &block)
    raise ArgumentError, "No year given" unless defined? options[:year]
    raise ArgumentError, "No month given" unless defined? options[:month]

    block                        ||= proc {|d| nil} 
    options[:table_class       ] ||= "calendarmonthtable"
    options[:month_name_class  ] ||= "monthName"
    options[:other_month_class ] ||= "calendardisabled"
    options[:day_name_class    ] ||= "dayName"
    options[:day_class         ] ||= "day"
    options[:abbrev            ] ||= (0..2)

    # initialize range
    first = Date.civil(options[:year], options[:month], 1)
    last = Date.civil(options[:year], options[:month], -1)
    
    lastMonth = Time.local(@year,@month,1,1,1,1).last_month.month
    lastMonthYear = Time.local(@year,@month,1,1,1,1).last_month.year
    nextMonth = Time.local(@year,@month,1,1,1,1).next_month.month
    nextMonthYear = Time.local(@year,@month,1,1,1,1).next_month.year

    # draw of table
    cal = <<EOF
      <div id="infobar">
	  <div id="date1">#{Date::MONTHNAMES[options[:month]]}, #{options[:year]}</div><div id="date2">#{Date::MONTHNAMES[options[:month]]}, #{options[:year]}</div>
	  <div id="monthlybuttons">
    	  <a href="/calendar/monthly?month=#{lastMonth}&year=#{lastMonthYear}"><img src="/images/infobar_previous.jpg" width="17" height="20" border=0 /></a>
    	  <a href="/calendar/monthly"><img src="/images/infobargrid.jpg" width="17" height="20" border=0 /><a>    	  
    	  <a href="/calendar/weekly?day=1&month=#{first.month}&year=#{first.year}"><img src="/images/infobarmultiple.jpg" width="17" height="20" border=0 /></a>
    	  <a href="/calendar/monthly?month=#{nextMonth}&year=#{nextMonthYear}"><img src="/images/infobarnext.jpg" width="17" height="20" border=0 /></a>
	  </div>
	  </div>
<table width="100%" border="0" cellpadding="2" cellspacing="2" class="calendarmonthtable">
    <tr>
EOF
    Date::DAYNAMES.each {|d| cal << "      <th scope=\"col\">#{d[options[:abbrev]]}</th>\n"} # day names
    cal << "    </tr>
  </tr>
    <tr>\n"
    0.upto(first.wday - 1) {|d| cal << "      <td class=\"#{options[:other_month_class]}\"></td>\n"} unless first.wday == 0 # empty cells
    first.upto(last) do |cur|
      cell_text, cell_attrs = block.call(cur) # allow block to render contents of table cells
      cell_text  ||= cur.mday
      cell_attrs ||= {:class => options[:day_class]} # allow user to define attributes of table cells
      cell_attrs = cell_attrs.map {|k, v| "#{k}=\"#{v}\""}.join(' ')
      cal << "      <td>#{cell_text}</td>\n" 
      cal << "    </tr>\n    <tr>\n" if cur.wday == 6 # start new table row
    end
    last.wday.upto(5) {|d| cal << "      <td class=\"#{options[:other_month_class]}\"></td>\n"} unless last.wday == 6 # empty cells
    cal << "    </tr>\n  </table>"
    #cal << "<script type='text/javascript'>\n"
    #cal << "// <![CDATA[\n"
    #lists = ""
    #30.times  do |i| 
    # lists << "'sortable_list[#{i+1}]'," 
    #end
    #30.times do |j|
    #cal << "Sortable.create('sortable_list[#{j+1}]',"
    #cal << "{dropOnEmpty:true,containment:[" + lists + "'sortable_list[30]'],constraint:false,"
    #cal << "onUpdate:function(){new Ajax.Request('/calendar/update_positions', {asynchronous:true, evalScripts:true, parameters:Sortable.serialize('sortable_list[#{j+1}]')})}});\n"
    #end
    #cal << "// ]]>\n"
    #cal << "</script>\n"
    
  end
  
    def calendar_weekly(options = {}, &block)
    raise ArgumentError, "No start year given" unless defined? options[:start_year]
    raise ArgumentError, "No start month given" unless defined? options[:start_month]
    raise ArgumentError, "No end year given" unless defined? options[:end_year]
    raise ArgumentError, "No end month given" unless defined? options[:end_month]
    raise ArgumentError, "No start day given" unless defined? options[:start_day]
    raise ArgumentError, "No end day given" unless defined? options[:end_day]

    block                        ||= proc {|d| nil} 
    options[:table_class       ] ||= "calendarmonthtable"
    options[:month_name_class  ] ||= "monthName"
    options[:other_month_class ] ||= "calendardisabled"
    options[:day_name_class    ] ||= "dayName"
    options[:day_class         ] ||= "day"
    options[:abbrev            ] ||= (0..2)

    # initialize range
    
    first_time = Time.local(options[:start_year], options[:start_month], options[:start_day])    
    last_time = Time.local(options[:end_year], options[:end_month], options[:end_day])
    
    first = Date.civil(options[:start_year], options[:start_month], options[:start_day]) 
    last = Date.civil(options[:end_year], options[:end_month], options[:end_day]) 

    lastDate = first_time.yesterday().beginning_of_week
    lastDay = lastDate.day
    lastWeekMonth = lastDate.month
    lastWeekYear = lastDate.year
    
    nextDate = first_time.next_week
    nextDay = nextDate.day
    nextWeekMonth = nextDate.month
    nextWeekYear = nextDate.year


    # draw of table
    cal = <<EOF
      <div id="infobar">
	  <div id="date1">#{first_time.strftime('%d/%b/%y')}</div><div id="date2">#{last_time.strftime('%d/%b/%y')}</div>
	  <div id="monthlybuttons">
    	  <a href="/calendar/weekly?day=#{lastDay}&month=#{lastWeekMonth}&year=#{lastWeekYear}"><img src="/images/infobar_previous.jpg" width="17" height="20" border=0 /></a>
    	  <a href="/calendar/monthly?month=#{first.month}&year=#{first.year}"><img src="/images/infobargrid.jpg" width="17" height="20" border=0 /><a>
    	  <a href="/calendar/weekly"><img src="/images/infobarmultiple.jpg" width="17" height="20" border=0 /></a>
    	  <a href="/calendar/weekly?day=#{nextDay}&month=#{nextWeekMonth}&year=#{nextWeekYear}"><img src="/images/infobarnext.jpg" width="17" height="20" border=0 /></a>
	  </div>
	  </div>
<table class="weeklytable" cellspacing="0">
	  <thead>
	  <tr>
          <th scope="column"  colspan="2" id="weeklyheader"> </th>
          </tr>
		 </thead>
EOF

    first.upto(last) do |cur|
      cell_text, cell_attrs = block.call(cur) # allow block to render contents of table cells
      cell_text  ||= cur.mday
      cell_attrs ||= {:class => options[:day_class]} # allow user to define attributes of table cells
      cell_attrs = cell_attrs.map {|k, v| "#{k}=\"#{v}\""}.join(' ')
      cal << "<tr><td class=\"weeklydate\" scope=\"row\">#{NTHDAY[cur.day]} #{cur.strftime('%B ')}</td>"
      cal << "      <td class=\"weeklycontent\" >#{cell_text}</td></tr>\n"
    end
        
    cal << "</table>\n"    
    #cal << "<script type='text/javascript'>\n"
    #cal << "// <![CDATA[\n"
    #lists = ""
    #30.times  do |i| 
    # lists << "'sortable_list[#{i+1}]'," 
    #end
    #30.times do |j|
    #cal << "Sortable.create('sortable_list[#{j+1}]',"
    #cal << "{dropOnEmpty:true,containment:[" + lists + "'sortable_list[30]'],constraint:false,"
    #cal << "onUpdate:function(){new Ajax.Request('/calendar/update_positions', {asynchronous:true, evalScripts:true, parameters:Sortable.serialize('sortable_list[#{j+1}]')})}});\n"
    #end
    #cal << "// ]]>\n"
    #cal << "</script>\n"
    
  end

  def action_links(extra_prelinks = nil, extra_postlinks = nil)
        links = "<ul>"
        extra_prelinks.each {|value| links << value } unless extra_prelinks == nil        
        links << add_link('New Event', :controller => 'events', :action => 'new') if authorized_author
        extra_postlinks.each {|value| links << value } unless extra_postlinks == nil
        links << "</ul>"
        links
   end
   
   def add_link(name, options = {}, html_options = nil)
        link = ""
        link << "<li>" 
        link << link_to(name, options, html_options)
        link << "</li>"
        link
   end  

end

