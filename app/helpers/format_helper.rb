# == Format Helper
# This is used to provide simple formats for date,time and numbers.
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
module FormatHelper
 
 
 def format_date(date)
    l_date(date) if date
  end
  
  def format_time(time)
    l_datetime(time) if time
  end
  
  def day_name(day)
    l(:general_day_names).split(',')[day-1]
  end
  
  def month_name(month)
    l(:actionview_datehelper_select_month_names).split(',')[month-1]
  end  
  
  
##
# Generate a short date format to display on screen dd-mmm-yyyy
#
  def short_date(date = nil)
    if date
       date.strftime("%Y-%b-%d")
    else
       "Not Set"
    end   
  rescue Exception => ex
      logger.error ex.message   
      "#Err"
  end
  
  
##
# Generate a short time format to display on screen 00:00:00
#
  def short_time(time = nil)
   if time
     time.strftime("%H:%M:%S")
   else
     "Not Set"
   end
  rescue Exception => ex
      logger.error ex.message
      "#Err"
  end
  
  def subject_icon( source,options={} )
     if (source.split("/").last || source).include?(".") || source.blank?
        image_tag(source,options)
     else
        image_tag("#{source}.png",options) 
     end
  end

 
 
###
# Simple number rounding routine to help in display of data in tables
#  
  def number_round(num = nil ,precision=6)
    if num
       "%.#{precision}g" % num
    else
       ""
    end   
  rescue Exception => ex
      logger.error ex.message
       "#Err"
  end


end
