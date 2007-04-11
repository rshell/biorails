module SheetHelper

##
# Mega Helper for display of a whole data view
# Display the data for a task is a tabluar manor

 def task_dataview(task )
   data_view(task.grid )
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
 def data_view(grid )
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
     out << data_view_row(row)
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
 def data_view_row(row)
   out = String.new
   out << "<tr>\n  <th>" << row.label 
   out << "  </th>\n" 
   for cell in row.cells
     out << '  <td class="cell">'
     out << cell.value.to_s || ' '
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
   out << '<table class="sheet"><tbody>' << "\n"
   old = nil
   n= 1
   for row in grid.rows
     if row.definition != old
       old = row.definition
       out << "</tbody><tbody class=#{row.definition.dom_id('head')}>\n"
       out << data_grid_headers(row) 
       out << "</tbody><tbody id ='#{row.dom_id('body')}' class=#{row.definition.dom_id('body')}>\n"
     end
     out << data_grid_row(row,n)
     n +=1
   end    
   out << '</tbody></table>' << "\n"
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
   out << '<th width="10%">' 
   out << "<div class='data_sheet_buttons'> \n   <span id='#{row.dom_id('title')}' class='selected' >"
   out << link_to_function(row.definition.label + " x" + row.definition.default_count.to_s,
        "toggle_element('#{row.dom_id('title')}','#{row.dom_id('body')}');" )
   out << "   </span></div>\n"
   out << "</th>\n"
   for parameter in row.definition.parameters
     out << '<th>'
     out << subject_icon("#{parameter.data_type.name}.png")
     out << parameter.name
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
   out << '<tr> <th width="10%">' << row.label 
   out << '</th>' << "\n"
   for cell in row.cells
     out << '<td class="cell" id="' + cell.dom_id('cell')+'">'
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
     options = { :save => task_url(:action=>:cell_change, :id=>cell.row.grid.id), 
                :default =>"#{cell.value}", 
                :value => "#{cell.value}",
                :onkeyup => "FieldOnKeyPress( this,event)"                
                }
     my_field_tag( cell.dom_id('item'), cell.dom_id('item'), cell.parameter,options)
  end

end
