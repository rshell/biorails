module MenuHelper

##
# Create navigation menu across the top of the screen for major topics
# 
  def navigation_menu(&block)
    out = String.new
    out << "<div id='navigation'>"
    out << capture(&block)
    out << "</div>"  
  end

  def menu_topic(title, &block)
    out = String.new
    out << "<div> <span> #{title} </span>"
    out << capture(&block)
    out << "</div>"  
  end 
 
  def dropdown_menu(menu_id,title,  &block )
    out = String.new
    out << "<div> <span> #{title} </span>"
    out << capture(&block)
    out << "</div>"  

    out << '<script type="text/javascript">'
    out << ' // <![CDATA['
    out << "   var menu_#{menu_id};"
    out << "   window.onload = function()"
    out << "   {  menu_#{menu_id} = new SideMenu('#{menu_id}');"
    out << "      menu_#{menu_id}.markCurrent = true;"
    out << "      menu_#{menu_id}.speed = 3; "
    out << "      menu_#{menu_id}.init();}; "
    out << " // ]]>"
    out << "</script>"
    out << '<div id="#{menu_id}" class="sidemenu">'
    out <<   capture(&block) 
    out << '</div>'
  end

##
# Generate a menu 
# 
  def menu(menu_id,  &block )
    out = String.new
    out << "<div id='#{menu_id}' class='menu' onmouseover='menuMouseover(event)'>"
    out << capture(&block)
    out << "</div>"  
  end

##
# Output a Menu Item 
# 
  def menu_item(title,url)
    out << "<a class='menuItem' href='<%='#{url}'%>' >   <span class='menuItemText'<%=l(title)%></span></a>"
  end
  

  
end

