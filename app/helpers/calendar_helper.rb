

module CalendarHelper
  
  def month_navigator( schedule,options ={'action'=>'calendar'})
    out = '<table width="100%">'
    out << '<tr><td align="left" style="width:150px">'
    url = { :action => options['action'] ,:year =>schedule.last_month.year, :month =>schedule.last_month.month}

    out << link_to_remote('&#171;'+ schedule.last_month.strftime("%b-%Y")  , 
                {:update => "centre", :url => url },{:href => url_for(url )}  )
                    
    out << '</td> <td align="center">'
    out <<  '<b>' << schedule.started_at.strftime("%b-%Y") << '</b>'
    out << '</td>'
    out << '<td align="right" style="width:150px">'
    url = { :action => options['action'] ,:year =>schedule.next_month.year, :month =>schedule.next_month.month}
                                              
    out <<  link_to_remote( ' &#187;'+schedule.next_month.strftime("%b-%Y")  , 
               {:update => "centre", :url => url },{:href => url_for(url )}  )
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
 	  out << '<tr style="height:100px">'
    while day <= schedule.last_date
        if day.cwday == 1 
     	    out << '<th class="sow">' << day.cweek.to_s << "</th>"
        end
        out << "<td valign='top' class='" << (schedule.core?(day) ? "weekday" : "weekend") 
        out <<  (schedule.in_range?(day) ? " ":" grey") <<  (Date.today == day ?  " today" : "" ) << "'> " 
    	out << " <p class='day'>"  << ( day==Date.today ? "<b>#{day.day}</b>" : day.day.to_s)   << " </p>"	
    	for item in schedule.for_day(day)
    	    out << "<div class='tooltip'> <p class='state_#{item.status}'>"
            out << image_tag('arrow_from.png')  if item.starting?(day)
    	    if block_given?    
       	      out << capture(item,&proc)
    	    else
    	      out << item.name
    	    end
		     out <<    image_tag('arrow_to.png')  if item.ending?(day)
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
 
 
  def gnatt( items, options = {}, &block)
    raise ArgumentError, "No started date given" unless defined? options[:started]
    raise ArgumentError, "No ended date given" unless defined? options[:ended]
 
    schedule = CalendarData.new(options[:started],options[:ended])
    schedule.fill(items)
    out = "<table class='calendar'>"
    day = schedule.started_at
 	  out << '<tr style="height:100px">'
    while day <= schedule.finished_at	
        if day.cwday == 1 
     	    out << "<th>" << day.cweek << "</th>"
        end
        out << "<td valign='top'  "
        out << "    style='width:14%; "  << ( Date.today == day ? "background:#FDFED0;'>" : "'>")
    	out << " <p class='textright'>"  << ( day==Date.today ? "<b>#{day.day}</b>" : day.day) 
    	out << " </p>"	
    	for item in for_day(day)
    	    if block_given?    
    	        yield out,item     
    	    else
    	      out << item.name
    	    end
    	end
        out << "</td>\n"
        if (day.cwday >= 7 and day!=schedule.finished_at)
        	out << "</tr>\n"
        	out << '<tr style="height:100px">' 
    	end
    	day = day + 1
    end 
    out << "</tr>"
    out << "</table>"
    concat(out)
  end
  
end

