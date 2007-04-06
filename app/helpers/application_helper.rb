##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def logged_in?
    !session[:user_id].nil?
  end
##
#Setup tabs for form
#
 def tab_setup(tab_ids,tab_names)
    out = String.new
    out = <<EOS
<script type="text/javascript" >
   function switchid(id){ $('#{tab_ids.join("','")}').invoke('hide'); Element.show(id); }
</script>
EOS
   return out
 end

##
# Generate a header for a tab
# 
# * tab_ids     array of div id for tabs
# * tab_names   array of tab names
# * tab_no      integer number of the tab in the array
# * current     integer number of the current tab
# 
# "javascript:switchid('<%= div_ids[i] %>');"
    
# 
 def tab_divide(tab_ids, tab_names, tab_no=0, current=0)
    out = String.new
    out << "<div id='#{tab_ids[tab_no]}' "
    if tab_no==current
      out << "style='display:block;'>" 
    else 
      out << "style='display:none;'> "
    end 
    out << '<br/>'
    out << '<ul class="tablist">'
    for i in 0 ... tab_ids.length do
        if tab_no == i
           out << "<li> <a class='current' " 
        else 
           out << "<li> <a " 
        end  
        out << 'href="javascript:switchid('
        out << "'" << tab_ids[i]
        out << "');"<< '"' << ">  #{tab_names[i]}  </a>"
        out << '</li>'
    end 
    out << '</ul>'
    return out
 end
 
###
# Simple boolean switch for display of a div 
# 
  def display(ok)
    if ok
     ''
    else
     'style="display: none;"'
    end
  end

end
