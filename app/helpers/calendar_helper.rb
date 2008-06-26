##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

module CalendarHelper
  
  def month_navigator( schedule,options ={'action'=>'calendar'})
    out = '<table width="100%">'
    out << '<tr><td align="left" style="width:150px">'
    url = { :action => options['action'] ,:year =>schedule.last_month.year, :month =>schedule.last_month.month}

    out << link_to_remote('&#171;'+ schedule.last_month.strftime("%b-%Y")  , 
                { :url => url },{:href => url_for(url )}  )
                    
    out << '</td> <td align="center">'
    out <<  '<b>' << schedule.started_at.strftime("%b-%Y") << '</b>'
    out << '</td>'
    out << '<td align="right" style="width:150px">'
    url = { :action => options['action'] ,:year =>schedule.next_month.year, :month =>schedule.next_month.month}
                                              
    out <<  link_to_remote( ' &#187;'+schedule.next_month.strftime("%b-%Y")  , 
               {:url => url },{:href => url_for(url )}  )
    out << '</td></tr></table>'
    return out.to_s
  end
  
  
###
#Generate a schedule for output from a collection of scheduled items
#
    #  calendar(items, {:started=>start,:ended=>ended}, do |out,item|
    #     out = link_to item.name, task_url(:action=>'show',:id=>item)
    #  end
# 
  def calendar(schedule , &proc)
    raise ArgumentError, "Missing item formatter block" unless block_given?
    raise ArgumentError, "Missing schedule " unless schedule
    
    out = '<table class="calendar-grid"><thead><tr><th></th>'
    1.upto(7) do |d| 
       out << '    <th class="daynames">' << day_name(d).to_s << '</th>'
    end
    out<< "</tr>"
    out<< "</thead>"

    day = schedule.first_date
 	  out << '<tr style="height:70px">'
    while day <= schedule.last_date
        if day.cwday == 1 
     	    out << '<th class="sow">' << day.cweek.to_s << "</th>"
        end
        out << "<td valign='top' class='" << (schedule.core?(day) ? "weekday" : "weekend") 
        out <<  (schedule.in_range?(day) ? " ":" grey") <<  (Date.today == day ?  " today" : "" ) << "'> " 
    	out << " <p class='day'>"  << ( day==Date.today ? "<b>#{day.day}</b>" : day.day.to_s)   << " </p>"	
    	for item in schedule.for_day(day)
    	    out << "<div class='tooltip'> <p class='state_#{item.status}'>"
            out << image_tag('enterprise/calendar/arrow_from-small.png') if item.starting?(day)
    	    if block_given?    
       	      out << capture(item,&proc)
    	    else
    	      out << item.name
    	    end
	     out << image_tag('enterprise/calendar/arrow_to-small.png') if item.ending?(day)
	     out << '</p></div>'
    	end
        out << "</td>\n"
        if (day.cwday >= 7 and day!=schedule.finished_at)
        	out << "</tr>\n"
        	out << '<tr style="height:100px">' 
    	end
    	day = day + 1
    end 
    out << '</tr><tr><th></th>'
    1.upto(7) do |d| 
       out << '<th></th>'
    end
    out<< "</tr>"
    out << "</table>"
    concat(out,proc.binding)
  end
  
end

