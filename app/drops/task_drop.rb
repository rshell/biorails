# == Task Drop
# Drops are error safe macros for the liquid template language. These are used 
# to map models into the Liquid with a safe limited scope
# 
# This allow the following links to be followed
# * folder
# * contexts
# * items
# * status
# * assigned_to
# * assigned_user
# * results_table
#  
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
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

  def folder
    liquify(@source.folder)    
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

  def state
   @source.folder.state_name
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
 
  def table_of(name,style=nil)
    definition = @source.process.context(name)
    return "no context #{name}" unless definition
    case style
    when 'split'
      return split_view(context,task) 
    when 'rotate'
      return rotated_view(context,task) 
    when 'scaled'       
      return scaled_view(context,task) 
    when 'form'       
      return record_view(context,task) 
    else
      return normal_view(context,task) 
    end
  end
  
  def results_table
    if @source.contexts.size < 2000 
      out = table_view(@source,true) 
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
 
  def guess_width(row)
    title_size = row.parameters.inject(0){|sum,i|sum +=i.name.size+2}
  end  

  def table_view(task,auditing =true)
    out = String.new
    out << '<table WIDTH="95%" BORDER="1" CELLPADDING="1" CELLSPACING="0">' << "\n"
    old = nil  
    n= 0
    for context in task.process.contexts
      case context.output_style
      when 'split'
        out << split_view(context,task,auditing) 
      when 'rotate'
        out << rotated_view(context,task,auditing) 
      when 'scaled'       
        out << scaled_view(context,task,auditing) 
      when 'form'       
        out << record_view(context,task,context.parameters,auditing) 
      else
        out << normal_view(context,task,context.parameters,auditing) 
      end
    end
    out << '</table>' << "\n"
  rescue Exception => ex
    logger.error ex.backtrace.join("\n")    
    logger.error ex.message
  end  
  #
  # Rotate page for table
  #
  def scaled_view(definition,task,auditing=true)
    width = guess_width(definition)
    out = "<font size='1'>"
    out << normal_view(definition,task,auditing)
    out = "</font>"
  end
  #
  # Rotate page for table
  #
  def rotated_view(definition,task,auditing=true)
    out = "<!-- MEDIA LANDSCPAE YES -->\n"
    out << normal_view(definition,task,auditing)
    out << "<!-- MEDIA LANDSCPAE NO -->\n"
  end
  #
  # Split the table into a number of sub tables printed
  # one after another
  #
  def split_view(definition,task,chuck_size=6,auditing=true)
    len = row.definition.parameters.size / chuck_size 
    splits =[]
    row.definition.parameters.each_with_index do |x,i|
      splits << [] if i%len ==0
      splits.last << x
    end
    for parameters in splits
      out << normal_view(definition,task,parameters,auditing)
    end 
  end
  #
  # Standard table output format
  #
  def normal_view(definition,task,parameters=nil,auditing=true)
    parameters ||= definition.parameters
    out = String.new
    out << '<table WIDTH="95%" BORDER="1" CELLPADDING="1" CELLSPACING="0">' << "\n"
    out << "<thead><tr >"
    out << "<th BGCOLOR='#cccccc'><span> #{definition.label} x #{definition.default_count.to_s} </span></th>\n"
    out << "<th BGCOLOR='#cccccc'><span> Groups </span></th>\n"
    for parameter in parameters
      out << "<th BGCOLOR='#cccccc'> #{parameter.name} <br />#{parameter.style} #{parameter.display_unit}</th>\n" 
    end    
    out << "</tr></thead>\n"
    out << "<tbody>\n"
    old = ""
    for row in task.contexts
      if row.definition == definition
        if old != row.row_group
          out << "<tr><td BGCOLOR='#cccccc' colspan='#{definition.parameters.size+2}'><span> #{row.row_group} </span></td></tr>\n" 
          old = row.row_group
        end
        out << "<tr>\n"  
        out << "  <th align='left' BGCOLOR='#cccccc'>" 
        out << row.row_group
        out << "  </th>\n" 
        out << "  <th align='left' BGCOLOR='#cccccc'>" 
        out << row.label
        out << "  </th>\n" 
        for parameter in parameters
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
      end
    end    
    out << "</tbody>\n"
    out << '</table>' << "\n"
  rescue Exception => ex
    logger.error ex.backtrace.join("\n")    
    logger.error ex.message
  end  
  
  def record_view(definition,task,parameters=nil,auditing=true)
    parameters ||= row.definition.parameters
    out = String.new
    for row in task.contexts
      if row.definition == definition
        out << '<table WIDTH="95%" BORDER="1" CELLPADDING="1" CELLSPACING="0">' << "\n"
        out << "<tr><th align='left' colspan='2' BGCOLOR='#cccccc'><strong><u>#{row.label}</u></strong> </th></tr>\n" 
        for parameter in parameters
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
      end
    end
    return out    
  end
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
