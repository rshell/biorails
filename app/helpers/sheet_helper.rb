##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
module SheetHelper

##
# Mega Helper for display of a whole data view
# Display the data for a task is a tabluar manor

 def task_dataview(task,auditing =false)
   data_view(task.grid,auditing )
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
 end
 
##
# Mega Helper creates a complete data entry grid. Most likily 
# should split up a bit and more to rhtml.
#
 def task_datasheet(task )
   data_sheet(task.grid )
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
 end
 
##
# create a data display grid for the passed task and parameter_context
# 
 def data_view(grid,auditing =false)
   out = String.new
   out << '<table class="sheet"><tbody>' << "\n"
   old = nil
   n= 0
   for row in grid.rows
     if row.definition != old
       old = row.definition
       out << "</tbody><tbody>\n"
       out << data_grid_headers(row) 
       out << "</tbody><tbody id ='#{row.dom_id('body')}' >\n"
     end
     out << data_view_row(row,auditing)
     n +=1
   end    
   out << '</tbody></table>' << "\n"
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
 end

##
# Out a grid row of data cells
# 
 def data_view_row(row,auditing =false)
   out = String.new
   out << "<tr>\n  <th>" << row.label 
   out << "  </th>\n" 
   for cell in row.cells
     out << '  <td class="cell">'
     if cell.item and auditing
       out << link_to_remote( cell.to_s, :url=> audit_url(:action=>'show', :auditable_type=> cell.item.class.to_s, :id => cell.item.id ))
     else
       out << cell.to_s || ' '
     end
     out << "  </td>\n"
   end
   out << "</tr>\n"
   return out
  end
 

##
# create a data entry grid for the passed task and parameter_context
 def data_sheet(grid )
   #logger.debug "Datasheet " +grid.to_s
   out = String.new
   out << '<table class="sheet">' << "\n"
   old = nil
   nrows =0
   n= 1
   for row in grid.rows
     if row.definition != old
       out << "</tbody>" if nrows>0 
       old = row.definition
       out << "<thead class='#{row.definition.dom_id(:head)}'>\n"
       out << data_grid_headers(row) 
       out << "</thead> \n"
       nrows =0 
     end
     out << "<tbody id ='#{row.dom_id('body')}' class='#{row.definition.dom_id(:body)}'>\n" if nrows ==0
     out << data_grid_row(row,n)
     nrows +=1
     n +=1
   end    
   out << "</tbody>" if nrows>0 
   out << '</table>' << "\n"
 rescue Exception => ex
    logger.error ex.message     
    logger.error ex.backtrace.join("\n")  
 end

##
# Output grid headers based on parameter names
# 
 def data_grid_headers(row)
   out = String.new
   out << "<tr>"
   out << '<th>' 
   out << "<div class='data_sheet_buttons'> \n   <span id='#{row.dom_id('title')}' class='selected' >"
   out << row.definition.label + " x" + row.definition.default_count.to_s
   out << "   </span></div>\n"
   out << "</th>\n"
   for parameter in row.definition.parameters
     out << '<th>'
     out << subject_icon("#{parameter.data_type.name}.png")
     out << parameter.name
     out << "<br/>("
     out << parameter.style.to_s  
     out << " "
     out << parameter.display_unit.to_s     
     out << ")"
     out << "</th>\n" 
   end
   out << "</tr>\n"
   return out
 end 

##
# Out a grid row of data cells
# 
 def data_grid_row(row,n)
   out = String.new
   out << '<tr> <th>' << row.label 
   out << '</th>' << "\n"
   for cell in row.cells
     out << "<td class='cell #{cell.css_class}' id='"+ cell.dom_id('cell')+"'>"
     out << data_grid_cell(cell)
     out << '</td>' << "\n"
   end
   out << '</tr>' << "\n"
   return out
  end

##
# Handlers for specific data types
# 
  def data_grid_cell(cell)
     options = { :save => task_url(:action=>:cell_change, :id=>cell.task.id), 
                :default =>"#{cell.value}", 
                :value => "#{cell.value}",
                :onkeyup => "FieldOnKeyPress( this,event)"                
                }
     my_sheet_tag( cell.dom_id('item'), cell.dom_id('item'), cell, options)
  end

end
