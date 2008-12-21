##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

module  ScheduleHelper


  def calendar_navigator
    out =' <table width="100%">'
    out << ' <tr>'
    out << '  <td align="left" style="width:150px">'
    out << link_to_remote( (@month==1 ? "#{month_name(12)} #{@year-1}" : "#{month_name(@month-1)}" ) ,
      {:update => "main", :url => { :year => (@month==1 ? @year-1 : @year), :month =>(@month==1 ? 12 : @month-1) }},
      {:href => url_for(:action => 'calendar', :year => (@month==1 ? @year-1 : @year), :month =>(@month==1 ? 12 : @month-1))})
    out << '  </td>'
    out << '  <td align="center">'
    out << select_month(@month, :prefix => "month", :discard_type => true)
    out << select_year(@year, :prefix => "year", :discard_type => true)
    out << submit_tag( "submit", :class => "button-small")
    out << '  </td>'
    out << '  <td align="right" style="width:150px">'
    out <<  link_to_remote( (@month==12 ? "#{month_name(1)} #{@year+1}" : "#{month_name(@month+1)}") ,
      {:update => "main", :url => { :year => (@month==12 ? @year+1 : @year), :month =>(@month==12 ? 1 : @month+1) }},
      {:href => url_for(:action => 'calendar', :year => (@month==12 ? @year+1 : @year), :month =>(@month==12 ? 1 : @month+1))})
    out << '  </td>'
    out << ' </tr>'
    out << '</table>'
    return out
  end

  def calendar_body
    out =  '<table class="list with-cells">'
    out << '<table class="list with-cells">'
    out << '<thead> '
    out << '<tr> '
    out << '<th> </th>'
    out << "<th style='width:14%'> #{day_name(1)} </th>"
    out << "<th style='width:14%'> #{day_name(2)} </th>"
    out << "<th style='width:14%'> #{day_name(3)} </th>"
    out << "<th style='width:14%'> #{day_name(4)} </th>"
    out << "<th style='width:14%'> #{day_name(5)} </th>"
     
    out << "<th style='width:14%'> #{day_name(6)} </th>"
    out << "<th style='width:14%'> #{day_name(7)} </th>"
    out << '</tr>'
    out << '</thead>'
    out << '<tbody>'
    out << '<tr style="height:100px">'
    out <<  day = @date_from
    while day <= @date_to
	    if day.cwday == 1
        our '<th>' << day.cweek <<  '</th>'
 	    end	
      out << '<td valign="top" class="' <<  (day.month==@month ? "even" : "odd")
      out << '"    style="width:14%; ' <<  (Date.today == day ? 'background:#FDFED0;' : '') << '">'
    	out << ' <p class="textright">' << (day==Date.today ? "<b>#{day.day}</b>" : day.day) << '</p>'	
      day_issues = []
      
      @tasks.each do |item|
        day_issues << item  if (item.started_at.to_date == day or item.finished_at.to_date == day)
      end
      	
    	day_issues.each do |item|
        out << '<div class="tooltip">'
    		if (day == item.started_at and day == item.finished_at.to_date)
          out << image_tag('date.png')
    		    
    		elsif (day == i.started_at.to_date)
          out << image_tag('started.png')
    		    
    		elsif  item.expected_at and day == item.expected_at.to_date
          out << image_tag('action.png')
    		    
    		elsif day == item.finished_at.to_date
          out << image_tag('ended.png')
    		    
    		end
    		out << '<small>'
    		out link_to( "#{item.name}", task_url( :action => 'show', :id => i ))
    		out << '</small>'		
        out << '<span class="tip">'
        out << "<strong>Task: #{item.name} [#{tem.status}] </strong>"
        out << "    <p> #{item.description} </p>"
        out << "    <ul>"
        out << "        <li>Started at  #{short_date  item.started_at} </li>"
        out << "        <li>Expected at #{short_date  item.expected_at} </li>"
        out << "        <li>Ended at    #{short_date  item.ended_at} </li>"
        out << "    </ul>"
        out << "</span>"
    		out << "</div>"
    	end
    	out << ' </td> '
	    out << '</tr><tr style="height:100px">' if day.cwday >= 7 and day!=@date_to
      day = day + 1
    end
    out << '</tr>'
    out << '</tbody>'
    out << '</table>'
    out << image_tag('started.png')
    out << image_tag('ended.png')
    out << image_tag('date.png')
  end



end

