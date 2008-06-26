# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class TaskDrop < BaseDrop
 #
 # Special base handling for timestamps
 #
 timezone_dates :created_at, :updated_at
 #
 # Extra non attribute methods called
 #
 extra_attributes << :contexts << :items 
 
 def initialize(source,options={})
   super source
    @options  = options
 end
 
 def contexts
   liquify(@source.contexts) 
 end
 
 def items
   liquify(@source.items)    
 end

 def status
   liquify(@source.status)    
 end
 
 def assigned_to
   liquify(@source.assigned_to)       
 end
 
 def started
   @source.started_at.strftime("%Y:%m:%d")
 end
 
 def finished
   @source.finished_at.strftime("%Y:%m:%d")
 end
 
 def expected
   @source.expected_at.strftime("%Y:%m:%d")
 end
 
 def assigned_user
   liquify(@source.assigned_to.name)       
 end
 
 def results_table
   if @source.contexts.size < 2000 
      out = data_view(@source,true) 
   else
     out = <<HTML
      <p class="icon icon-info">
        This display is optimized for ~2000 rows of data and this task has too
        much data to display. Currently developing a more advanced AJAX based#version with improved pagnation to resolve this issue.
      </p>
HTML
   end
   return out    
 rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")       

 end
 
 protected
 
 ##
# create a data display grid for the passed task and parameter_context
# 
 def data_view(task,auditing =false)
   out = String.new
   out << '<table WIDTH="95%" BORDER="1" CELLPADDING="1" CELLSPACING="0">' << "\n"
   old = nil
   n= 0
   for row in task.contexts
     if row.parameters.size>SystemSetting.max_table_columns
       out << data_view_list(row,auditing)
     else  
       if row.definition != old
         out << '</table>' << "\n"
         out << '<br \>'
         out << '<table WIDTH="95%" BORDER="1" CELLPADDING="1" CELLSPACING="0">' << "\n"
         old = row.definition
         out << data_view_headers(row) 
       end
       out << data_view_row(row,auditing)
     end
     n +=1
   end    
   out << '</table>' << "\n"
 rescue Exception => ex
      logger.error ex.backtrace.join("\n")    
      logger.error ex.message
 end

 def data_view_list(row,auditing)
   out = String.new
   out << "<tr><th align='left' colspan='2' BGCOLOR='#cccccc'><strong><u>#{row.label}</u></strong> </th></tr>\n" 
   for parameter in row.definition.parameters
     out << "<tr><th  width='30%' align='left' BGCOLOR='#cccccc'> #{parameter.name} #{parameter.style} #{parameter.display_unit}</th>\n" 
     out << "<td class='cell'>"
     item = row.item(parameter)
     if (auditing and item.id)     
       out << link_to_remote( item.to_s, :url=> "/audit/show/#{item.id}?auditable_type=#{item.class.to_s}")
     else
       out << item.to_s
     end
     out << "  </td>\n"
     out << "</tr>\n"
   end
   return out
 end  
##
# Out a grid row of data cells
# 
 def data_view_row(row,auditing =false)
   out = String.new
   out << "<tr>\n  <th align='left' BGCOLOR='#cccccc'>" << row.label 
   out << "  </th>\n" 
   for parameter in row.definition.parameters
     out << '  <td class="cell">'
     item = row.item(parameter)
     if (auditing and item.id)     
       out << link_to_remote( item.to_s, :url=> "/audit/show/#{item.id}?auditable_type=#{item.class.to_s}")
     else
       out << item.to_s
     end
     out << "  </td>\n"
   end
   out << "</tr>\n"
   return out
  end

 
##
# Output grid headers based on parameter names
# 
 def data_view_headers(row)
   out = String.new
   out << "<tr >"
   out << "<th BGCOLOR='#cccccc'><span> #{row.definition.label} x #{row.definition.default_count.to_s} </span></th>\n"
   for parameter in row.definition.parameters
     out << "<th BGCOLOR='#cccccc'> #{parameter.name} <br />#{parameter.style} #{parameter.display_unit}</th>\n" 
   end
   out << "</tr>\n"
   return out
 end 

end
