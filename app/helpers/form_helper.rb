##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
module FormHelper
##
# Date field for stadard forms
# 
  def date_field(object_name, method)
    calendar_ref = object_name + '_' + method
    <<-EOL
      <div id="dateBocks">
        <ul>
          <li>#{text_field object_name, method, { 
                   :onchange => "magicDate('#{calendar_ref}');", 
                   :onkeypress => "magicDateOnlyOnSubmit('#{calendar_ref}', event); return dateBocksKeyListener(event);", 
                   :onclick => "this.select();"} }</li>
          <li>#{subject_icon('icon-calendar.gif', :alt => 'Calendar', 
                                           :id => calendar_ref + 'Button', 
                                           :style => 'cursor: pointer;' ) }</li>
          <li>#{subject_icon('icon-help.gif', :alt => 'Help', :id => calendar_ref+ 'Help' ) }</li>

        </ul>
        <div id="dateBocksMessage"><div id="#{calendar_ref}Msg"></div></div>
        <script type="text/javascript">
          document.getElementById('#{calendar_ref}Msg').innerHTML = calendarFormatString;
          
          Calendar.setup({
      	   inputField     :    "#{calendar_ref}",        // id of the input field
      	   ifFormat       :    calendarIfFormat,         // format of the input field
      	   button         :    "#{calendar_ref}Button",  // trigger for the calendar (button ID)
      	   help           :    "#{calendar_ref}Help",    // trigger for the help menu
      	   align          :    "Br",                     // alignment (defaults to "Bl")
      	   singleClick    :    true
      	  });
          //document.getElementById('#{calendar_ref}').onkeydown = dateBocksKeyListener;
          
        </script>
      </div>
    EOL
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
       "Err. (no date picker)"
  end


##
#List of all the concepts in the system
#
#  * object  to build selector around
#  * method of the object to build selector for
#  * item [default=nil] root on tree of items to display
#
  def select_data_concept(object,method, root = nil) 
     list = [[nil,nil]]
     case root
     when DataConcept
       for item in root.decendents
          list.concat([item.path,item.id])
       end
     when DataElement
       list.concat([[root.concept.path,root.concept.id]])
     else
        list.concat(DataConcept.find(:all,:order=>'parent_id,name').collect{|c|[c.path,c.id]})
     end
     return  select(object, method ,list)      
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n") 
      return "[No Concepts]"  << hidden_field(object,method) 
  end

##
# Return a list of the allowed Elements that can be used as specializations 
# of the passed concept of children of the passed element.
# 
#  * object  to build selector around
#  * method of the object to build selector for
#  * root [default=nil] root on tree of items to display
# 
  def select_data_element(object,method, root=nil)   
     list = [[nil,nil]]
     case root
     when DataConcept
       for item in root.decendents
          list.concat(item.elements.collect{|c|[c.path,c.id]})
       end
     when DataElement
       for item in root.decendents
          list.concat([item.path,item.id])
       end
     else
         list.concat(DataElement.find(:all,:order=>'name').collect{|c|[c.path,c.id]})   
     end
     return  select(object, method ,list)      
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
  end

##
# List of a allowed data formats
# 
  def select_data_format(object,method, item = nil)   
     formats =[];
     case item
     when DataType
       formats = item.data_formats
     else
       formats = DataFormat.find(:all,:order=>'name') 
     end
     return collection_select(object, method ,formats, :id, :name) 
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      return "[No Formats]"  << hidden_field(object,method ) 
  end

##
#
##
# Return a list of the allowed Elements that can be used as specializations 
# of the passed concept.
# 
  def select_named( object,method, model = nil, initial=nil)   
     list = initial || []
     if model 
         list.concat(model.find(:all,:order=>'name').collect{|i|[i.name,i.id]})
     end 
     return select(object, method ,list) 
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      return "[No #{model.to_s}]"  << hidden_field(object,method) 
  end
##
# Selector for a study_protocol in a given context (Study,All,StudyProtocol)
# 
  def select_study( object,method)
    return collection_select(object, method ,studies, :id, :name) 
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      return "[No Studies]"  << hidden_field(object,method) 
  end

##
# Selector for a study_protocol in a given context (Study,All,StudyProtocol)
# 
  def select_protocol( object,method, item = nil)
     protocols = []
     case item
     when Study
       protocols = item.protocols
     when StudyProtocol
       protocols << item
     else
       protocols = StudyProtocol.find(:all)
     end
    return collection_select(object, method ,protocols, :id, :name) 
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      return "[No Protocols]"  << hidden_field(object,method) 
  end

##
# Selector for a study_protocol in a given context (Study,All,StudyProtocol)
# 
  def select_task( object,method, item = nil)
     tasks = []
     case item
     when Study
       tasks = item.tasks
     when StudyProtocol
       tasks == item.tasks
     else
       tasks = Tasks.find(:all)
     end
    return collection_select(object, method ,tasks, :id, :name) 
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      return "[No Tasks]"  << hidden_field(object,method) 
  end


###
# Generate a selector for a model in the system. 
# 
# Had tried a simple objectspace lookup but unluckily all classes may not be loaded to went back to dir scan
# ObjectSpace.each_object(Class) do |obj| 
#   choices << obj if (obj.ancestors.any?{|item|item==klass} and !obj.abstract_class)
# end
# 
  def select_model(object, method, root=ActiveRecord::Base, options = {}, html_options = {})
   unless @models
     @models = []
     Dir.chdir(File.join(RAILS_ROOT, "app/models")) do 
       Dir["*.rb"].each do |m|
         class_name = Inflector.camelize(m.sub(/\.rb$/, ''))
         klass = Object.const_get(class_name) rescue nil
         if klass && klass.ancestors.any?{|item|item==root} and !klass.abstract_class
           puts "Looking at #{class_name}"
           @models << klass
         else
          puts "Skipping #{class_name}"
         end
       end
     end 
     @models -= [ActiveRecord::Base, CGI::Session::ActiveRecordStore::Session]
   end
   choices = @models.collect{|obj|obj.to_s}.sort.collect{|obj|[obj,obj]}
   select(object, method, choices,options,html_options) 
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      return "[No Models]"  << hidden_field(object,method) 
  end
  
  
##
# For a specific data element list the value option
# 
# suports DataConcept,DataElement,Id or Name as item in import
# 
  def select_value(object, method, item, options = {}, html_options = {})
    choices = []
    data_element = nil
    case item
    when DataElement
      data_element = item
    when DataConcept
      data_element = DataElement.find(:first, :conditions=>['data_concept_id=?',item.id])
    when String
      data_element = DataElement.find_by_name(item)
    else
      data_element = DataElement.find(item)
    end
    choices = data_element.choices if data_element
    select(object, method, choices, options, html_options) 
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
  end

##
# select for a ProtocolVersion (eg How to do stuff)
# 
  def select_process( object,method,item = nil)
    processes = []
    case item
     when Study
       processes = item.protocols.collect{|i|i.process}
     when StudyProtocol
       processes = item.definition.versions
     else
       processes = ProtocolVersion.find(:all,:order=>'name')
     end
    return collection_select(object, method , processes, :id, :name) 
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
  end

##
# Handlers for specific data types
# 
  def my_field_tag(id, name, parameter, options = {})
#     logger.info "my_field_tag( #{id}, #{name}, #{parameter} ,#{options.to_s})"
     options[:mask] ||= parameter.mask if parameter.mask
     options[:default] ||= parameter.default_value  if parameter.default_value  
     options[:value] ||=  parameter.default_value  if parameter.default_value  
      
     case parameter.data_type_id
     when 1: my_regex_tag(id, name, options)
     when 2: my_regex_tag(id, name, options)
     when 3: my_date_field(id,name,parameter.default_value,options)
     when 4: my_regex_tag(id, name,options)
     when 5: my_lookup_tag(id,name, parameter.element,options)
     when 6: my_regex_tag(id, name, options)
     when 7: my_file_field(id,name,parameter.default_value)
     else 
        text_field_tag(cell.dom_id,cell.value)
     end     
  end

##
# Handlers for specific data types
# 
  def my_sheet_tag(id, name, cell, options = {})
#     logger.info "my_field_tag( #{id}, #{name}, #{parameter} ,#{options.to_s})"
     options[:mask]    ||= cell.parameter.mask if cell.parameter.mask
     options[:default] ||= cell.parameter.default_value  if cell.parameter.default_value  
     options[:value]   ||= cell.parameter.default_value  if cell.parameter.default_value  
      
     case cell.parameter.data_type_id
     when 1: my_regex_tag(id, name, options)
     when 2: my_regex_tag(id, name, options)
     when 3: my_date_field(id,name,cell.parameter.default_value,options)
     when 4: my_regex_tag(id, name,options)
     when 5: my_lookup_tag(id,name,cell.parameter.element,options)
     when 6: my_regex_tag(id, name, options)
     when 7: my_file_field(id,name,cell.task.folder,options)
     else 
        text_field_tag(cell.dom_id,cell.value,options)
     end     
  end
##
# 1) Display Text field
# 2) On change validate with regex
# 3) On exit of field do ajax to server to save
#
  def my_regex_tag(id, name, options={})
    options[:mask]    ||= '.'
    options[:value]   ||= ''
    options[:default] ||= ''
    options[:onfocus] ||= 'FieldEntry( this,event)'
    options[:onkeyup] ||= 'FieldValidate( this,event)'
    options[:onblur]  ||= 'FieldExit(this,event)'    
    tag :input, { "type" => "text", "name" => name, "id" => id}.update(options.stringify_keys)
  end

##
# lookup cell either a combo for short list of a autocomplete for longer lists
# 
  def my_file_field(id,name, folder=nil ,options={})
    return my_regex_tag(id,name,options) if folder.nil?
    options[:mask]    ||= '.'
    options[:default] ||= ''
    options[:autocomplete]   ||= 'off'
    options[:onfocus] ||= 'FieldEntry( this,event)'
    options[:onkeyup] ||= 'FieldValidate( this,event)'
    options[:onchanged]  ||= 'FieldSave(this,event)'    
    options[:onblur]  ||= 'FieldExit(this,event)'  
    out = "<table><tr><td>"
    out << tag( :input, { "type" => "text", "name" => name, "id" => id}.update(options.stringify_keys)) 
    out << content_tag("div", "", :id => "#{id}_auto_complete", :class => "auto_complete") 
    out << "</td><td>"
    out << hidden_field_tag("#{id}_ref")
    out << link_to_function(subject_icon("down"), "#{id}_auto_completer.activate()") 
    out << "</td></tr></table>\n"  
    
    options[:url] = {:controller =>'project/folders',:action=>'choices',:id=>folder.id} 
    options[:min_chars] =2
    options[:after_update_element]= "FieldSave"

    out << "\n"  
    out << auto_complete_field(id, options)
  end



##
# Date selector cell
#   
  def my_date_field(id,name,value,options={})
    options[:mask]    ||= '.'
    options[:value]   ||= value
    options[:default] ||= ''
    options[:autocomplete]   ||= 'off'
    options[:onfocus] ||= 'FieldEntry( this,event)'
    options[:onkeypress]  ||= 'DateFieldOnKeyPress(this,event); return dateBocksKeyListener(event);'   
    options[:onchanged]  ||= 'FieldSave(this,event)'    
    options[:onblur]  ||= 'DateFieldExit(this,event);' 
    options[:onclick]  ||= 'this.select();'
 
    out = String.new

    out  << '<div id="dateBocks">'
    out  << '<table><tr> <td>'
    out << tag( :input, { "type" => "text", "name" => name, "id" => id}.update(options.stringify_keys)) 
    out << <<EOS
          </td>
          <td>#{image_tag('icon-calendar.gif', :alt => 'Calendar', :id => id + '_Button', :style => 'cursor: pointer;' ) }</td>
          <td>#{image_tag('icon-help.gif', :alt => 'Help', :id => id+ '_Help' ) }</td>
        </tr></table>
        <script type="text/javascript">          
          Calendar.setup({
      	   inputField     :    "#{id}",        // id of the input field
      	   ifFormat       :    calendarIfFormat,         // format of the input field
      	   button         :    "#{id}_Button",  // trigger for the calendar (button ID)
      	   help           :    "#{id}_Help",    // trigger for the help menu
      	   align          :    "Br",                     // alignment (defaults to "Bl")
      	   singleClick    :    true,
      	  });
        </script>
      </div>
EOS
  end
 
  def my_in_place_editor_field(object, method, tag_options = {}, in_place_editor_options = {})
      tag_options = {:id => "#{object.class.to_s.underscore}_#{method}_#{object.id}_in_place_editor", 
                     :class => "in_place_editor_field"}.merge!(tag_options)
      in_place_editor_options[:url] = in_place_editor_options[:url] || url_for({ :action => "set_#{object.class.to_s.underscore}_#{method}", :id => object.id })
      content_tag("span",object.send(method), tag_options) +   in_place_editor(tag_options[:id], in_place_editor_options)
  end


##
# lookup cell either a combo for short list of a autocomplete for longer lists
# 
  def my_lookup_tag(id,name, data_element=nil ,options={})
    options[:mask]    ||= '.'
    options[:onfocus] ||= 'FieldEntry( this,event)' 
#    options[:onkeyup] ||= 'LookupOnKeyPress(this,event)'
    if data_element.nil?
       return my_regex_tag(id, name,options)
    elsif data_element.estimated_count and data_element.estimated_count < 10
       #options[:onchange]  ||= 'FieldSave(this,event)'   
       #options[:onblur]  ||= 'FieldExit(this,event)'       
       option_tags = options_for_select(data_element.values.collect{|i|[i.name,i.name]},options[:value])
       return content_tag( :select, option_tags, { "name" => name, "id" => id }.update(options.stringify_keys))
    else
       return combo_box_tag_auto_complete( id,"",data_element_url(:action=>'select', :id=> data_element.id), options, 
       {:after_update_element=>'FieldSave', :useCache=>true, :row_count => 20, :min_chars => 2})
    end
  end


  # Use this method in your view to generate a return for the AJAX autocomplete requests.
  #
  # Example action:
  #
  #   def auto_complete_for_item_title
  #     @items = Item.find(:all, 
  #       :conditions => [ 'LOWER(description) LIKE ?', 
  #       '%' + request.raw_post.downcase + '%' ])
  #     render :inline => "<%= select_auto_complete_result(@items, 'description', id) %>"
  #   end
  #
  # The select_auto_complete_result can of course also be called from a view belonging to the 
  # auto_complete action if you need to decorate it further.

  def select_auto_complete_result(entries, field, idField = "id", phrase = nil)
    return unless entries
    items = entries.map { |entry| content_tag("option", phrase ? highlight(entry[field], phrase) : h(entry[field]),
    :value => entry[idField]) }
    content_tag("select", items.uniq)
  end
  
        # Wrapper for text_field with added AJAX selectAutocompletion functionality.
        #
        # In your controller, you'll need to define an action called
        # select_auto_complete_for_object_method to respond the AJAX calls,
        # 
        # See the RDoc on ActionController::AutoComplete to learn more about this.
        
  def combo_box_tag_auto_complete(id,value, url, tag_options = {}, completion_options = {})
    out = "<table><tr><td>"
    out << text_field_tag(id, value, tag_options) 
    out << content_tag("div", "", :id => "#{id}_select_auto_complete", :class => "select_auto_complete") 
    out << hidden_field_tag("#{id}_ref")
    out << "</td><td>"
    out << link_to_function(subject_icon("down"), "#{id}_select_auto_completer.activate()") 
    out << "</td></tr></table>"
    out << select_auto_complete_field("#{id}", { :url => url }.update(completion_options))
    out.to_s
  end

  # Simililar to Autocompleter functionality except it
  # pops up a listbox instead of a list; Adds autocomplete to the text input field with the 
  # DOM ID specified by +field_id+.
  #
  # This function expects that the called action returns an HTML <select> element,
  # or nothing if no entries should be displayed for autocompletion.
  #
  # You'll probably want to turn the browser's built-in autocompletion off,
  # so be sure to include an <tt>autocomplete="off"</tt> attribute with your text
  # input field.
  #
  # The autocompleter object is assigned to a Javascript variable named <tt>field_id</tt>_auto_completer.
  # This object is useful if you for example want to trigger the auto-complete suggestions through
  # other means than user input (for that specific case, call the <tt>activate</tt> method on that object). 
  # 
  # Required +options+ are:
  # <tt>:url</tt>::                  URL to call for autocompletion results
  #                                  in url_for format.
  # 
  # Additional +options+ to the ones of autocompleter are:
  # <tt>:value_element</tt>::        The id of a text or hidden field to receive the value
  #                                  corresponding to to the selection
  # <tt>:redirect_url</tt>::        URL where the page will be redirected upon selection
  #                                  in url_for format.
  #                                  the string '??' in the URL will be replace by the value
  #                                  corresponding to to the selection 
  # <tt>:row_count</tt>::           The number of rows in the select element.
  # <tt>:use_cache</tt>::           Cache the result on the client side.
  #
  def select_auto_complete_field(field_id, options = {})
    function =  "var #{field_id}_select_auto_completer = new Ajax.SelectAutocompleter("
    function << "'#{field_id}', "
    function << "'" + (options[:update] || "#{field_id}_select_auto_complete") + "', "
    function << "'#{url_for(options[:url])}'"
    
    js_options = {}
    js_options[:tokens] = array_or_string_for_javascript(options[:tokens]) if options[:tokens]
    js_options[:callback]   = "function(element, value) { return #{options[:with]} }" if options[:with]
    js_options[:indicator]  = "'#{options[:indicator]}'" if options[:indicator]
    js_options[:select]     = "'#{options[:select]}'" if options[:select]
    js_options[:paramName]  = "'#{options[:param_name]}'" if options[:param_name]
    js_options[:frequency]  = "#{options[:frequency]}" if options[:frequency]
    js_options[:valueElement]  = "'#{options[:value_element]}'" if options[:value_element]
    js_options[:rowCount]  = "#{options[:row_count]}" if options[:row_count]
    js_options[:useCache]  = options[:use_cache] == false ? false : true
    js_options[:redirect_url]  = "'#{url_for(options[:redirect_url])}'" if options[:redirect_url]

    { :after_update_element => :afterUpdateElement, 
      :on_show => :onShow, :on_hide => :onHide, :min_chars => :minChars }.each do |k,v|
      js_options[v] = options[k] if options[k]
    end

    function << (', ' + options_for_javascript(js_options) + ')')

    javascript_tag(function)
  end
  

end
  