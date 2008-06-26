require File.dirname(__FILE__) + '/../test_helper'


# Re-raise errors caught by the controller.
class CalendarHelperTest < TestHelper
  include CalendarHelper
  include FormatHelper
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  
  def build_calendar
    @project = Project.find(2)
    started = Date.civil(2007,12,1)  
    find_options = {:conditions=> "status_id in ( 1,2,3,4,5 )"}
    @calendar = CalendarData.new(started,1)
    @project.tasks.add_into(@calendar,find_options)            
    @project.experiments.add_into(@calendar,find_options)       
    @project.assays.add_into(@calendar,find_options)           
    @project.requests.add_into(@calendar,find_options)           
    @project.requested_services.add_into(@calendar,find_options)  
    @project.queue_items.add_into(@calendar,find_options)             
  end

  def test_month_navigator
    @calendar = build_calendar
    html = month_navigator(@calendar)
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def concat(out,proc)
    out
  end
  
  def test_calendar
    @calendar = build_calendar
    html = calendar(@calendar) do
      "test"
    end
    assert html.is_a?(String)
    assert html.size>0
  end


end