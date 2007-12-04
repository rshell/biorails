##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
module SheetHelper

  EXT_FIELD_TYPE = [ :textfield,:textfield,:datefield,:timefield,:elementcombo,:textfield,:textfield ] 
  
  def context_definition(context, url = nil) 
    url ||= "/protocols/table/#{context.id}"
    item = {:id => context.id,
            :url => url,
            :parent_id => context.parent_id,
            :level => context.level_no,
            :name => context.label,
            :path => context.path,
            :protocol_version_id => context.protocol_version_id,
            :parameter_context_id=>context.id,
            :parameters => context.parameters.collect{|i|i.attributes}
            }
    return item.to_json        
  end
  
  def context_model(context, url = nil) 
    url ||= "/protocols/table/#{context.id}"
    item = {:id => context.id,
            :url => url,
            :parent_id => context.parent_id,
            :level => context.level_no,
            :name => context.label,
            :name => context.label,
            :path => context.path,
            :total => context.parameters.size,
            :items => context.parameters.collect do |i|
              {:id => i.id,
               :name => i.name,
               :description => i.description, 
               :style => i.style,
               :regex => (i.data_format_id ? i.data_format.format_regex : nil),
               :column_no => i.column_no,  
               :data_type_id => i.data_type_id,
               :data_format_id => i.data_format_id,
               :data_element_id => i.data_element_id,
               :study_parameter_id => i.study_parameter_id,
               :default_value => i.default_value,
               :unit => i.display_unit,
               :mandatory => i.mandatory,
              }
            end
            }
    return item.to_json        
  end
  
  def context_dummy_data(context)
    items = {}
    context.parameters.each do |item|
      items[item.name] = item.default_value
    end
    return {
      :id => context.id,
      :name => context.label,
      :total => 2,
      :items => [items,items]
    }.to_json
  end

  def context_data(context)
    items = {}
    context.definition.parameters.each do |item|
      items[item.name] = ''
    end
    return {
      :id => context.id,
      :name => context.label,
      :total => 1,
      :items => [items]
    }.to_json   
  end
  
  def parameter_definition(parameter)
    out = <<JS
      {name: '#{parameter.name}',
       value:'#{parameter.default_value}', 
       unit: '#{parameter.display_unit}',
       column_no: '#{parameter.column_no}',
JS
    case parameter.data_type_id
      when 1  #text
        out << "editor:  new Ext.form.TextField({  name: '#{parameter.name}',fieldLabel: '#{parameter.name}' })"
      when 2  # numeric
        out << "editor: new Ext.form.NumberField({ name:'#{parameter.name}', fieldLabel: '#{parameter.name}' })"
      when 3  # date
        out << "editor:  new Ext.form.DateField({  name: '#{parameter.name}',fieldLabel: '#{parameter.name}' })"
      when 4  # time
        out << "editor:  new Ext.form.TimeField({  name: '#{parameter.name}',fieldLabel: '#{parameter.name}' })"
      when 5  # dictionary
        out << "editor:  new Biorails.ComboField({ name: '#{parameter.name}',root_id: #{parameter.data_element_id}, fieldLabel:  '#{parameter.name}' })"
      when 6  # url
        out << "editor:  new Ext.form.TextField({  name: '#{parameter.name}',vtype: url, fieldLabel: '#{parameter.name}' })"
      when 7  # file   
        out << "editor:  new Biorails.FileComboField({  name: '#{parameter.name}',folder_id: #{current_project.home.id}, fieldLabel: '#{parameter.name}' })"
      end
      out = "}"
      return out.to_s
  end
  #
  # Display a form based on the current context
  #
  def form_definition(context)
    out = <<JS
new Ext.FormPanel({
   labelWidth: 75, 
   frame:true,
   title: '#{context.label}',
   bodyStyle:'padding:5px 5px 0',
   defaults: {width: 400},
   defaultType: 'textfield',\n
   items: [
JS
    items = context.parameters.collect do |param|
    case param.data_type_id
      when 1  #text
       "   new Ext.form.TextField({ name: '#{param.name}', fieldLabel: '#{param.name}' })"
      when 2  # numeric
       "  new Ext.form.NumberField({name:'#{param.name}', fieldLabel: '#{param.name}' })"
      when 3  # date
       "  new Ext.form.DateField({  name: '#{param.name}', fieldLabel: '#{param.name}' })"
      when 4  # time
       "  new Ext.form.TimeField({  name: '#{param.name}', fieldLabel: '#{param.name}' })"
      when 5  # dictionary
       "  new Biorails.ComboField({  name: '#{param.name}',root_id: #{param.data_element_id}, fieldLabel:  '#{param.name}' })"
      when 6  # url
       "  new Ext.form.TextField({  name: '#{param.name}',vtype: url, fieldLabel: '#{param.name}' })"
      when 7  # file   
       "  new Biorails.FileComboField({  name: '#{param.name}',folder_id: #{current_project.home.id}, fieldLabel: '#{param.name}' })"
      end
    end

    out << items.join(",\n")
    out << "\n ]});"
    return out.to_s
  end
  #
  # Display a table definition on the current context
  #
  def table_definition(context)
    out = <<JS
    
JS
    return out.to_s
  end

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
       out << cell.to_html 
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
     out << " ("
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

