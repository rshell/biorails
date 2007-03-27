
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
module Execute::RequestsHelper

##
# Create a simple view of results row
# 
 def results_view(rows)
   out = String.new
   definition = nil 
   for row in Task.find(:first).contexts
     if row.definition != definition 
       out << "</tbody></table>" if definition
       definition = row.definition
       out << "<table class='Sheet'>"
       out << "<thead>"
       out << results_header(row) 
       out << "</thead>"    
       out << "<tbody>"
     end
     out << results_row(row)
   end
   out << "</tbody></table>"
   return out
 end
 
##
# Output results headers based on parameter names
# 
 def results_header(row)
   out = String.new
   out << "<tr>\n"
   out << "<th>#{row.definition.process.path}</th>"
   out << "<th>Last Changed</th>"
   for parameter in row.definition.parameters
     out << '<th class="Parameter" id="' << parameter.id.to_s << '">'
     out << subject_icon("#{parameter.data_type.name}.png")
     out << parameter.name
     out << '</th>' 
   end
   out << "</tr>\n"
   return out
 end 

##
# Out a results row of data cells
# 
 def results_row(row)
   out = String.new
   out << '<th>' << link_to(row.task.name,:controller =>'tasks',:action=>'show',:id=>row.task.id) 
   out << '</th>' 
   out << '<th>' << short_date(row.task.updated_at) 
   out << '</th>' 
   for parameter in row.parameters
     item = row.item(parameter) 
     out << '<td class="cell">'
     out << '<span background-color="#999900" >' 
     out << item.value.to_s if item
     out << "</span>"
     out << '</td>' 
   end
   out << "</tr>\n"
   return out
  end
 

end
