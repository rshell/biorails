module Project::OverviewHelper
  def render_events(events, later = false)
    text = []
    if events.any?
      events.each_with_index { |evt, i| text << render(:partial => "#{evt.mode}_event", :locals => { :event => evt, :shaded => (i % 2 > 0), :later => later }) }
    else
      text << %(<li class="event-none shade">Nothing happening</li>)
    end
      %(<ul class="events">#{text.join}</ul>)
  end

  def event_time_for(event, long = false)
    utc_to_local(event.created_at).send *(long ? [:to_ordinalized_s, :plain] : [:to_s, :time_only])
  end
  
  def todays_short_date
    utc_to_local(Time.now.utc).to_ordinalized_s(:stub)
  end
 
  def yesterdays_short_date
    utc_to_local(Time.now.utc.yesterday).to_ordinalized_s(:stub)
  end
end
