# == Form Helper
# This is used to provide simple form processing helper
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
module FormHelper
  @@logger=Logger.new(STDOUT)
  OPEN_DIALOG = <<-EOL
<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>
    <div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc">        
  EOL

  END_DIALOG = <<-EOL
    </div></div></div>
<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>
  EOL
  
  
  def dialog(name, &block)
    if block_given?
      content = capture(&block)
      concat( OPEN_DIALOG , block.binding)
      concat("<h3 style='margin-bottom:5px;'> #{name}</h3>", block.binding) 
      concat(content,block.binding)
      concat( END_DIALOG , block.binding)
    end
  end


  def validated_form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
    options.merge(:class=>"validated")
    return form_tag(url_for_options , options , *parameters_for_url, &block)
  end
  # ## Date field for stadard forms
  # 
  def date_field(object_name, method)
    date = eval("@#{object_name}.#{method}") 
    value = date if date.is_a? String 
    value ||= date ? date.strftime("%Y-%m-%d") :""
    <<HTML	
 <input id="#{object_name}_#{method}" name="#{object_name}[#{method}]" type="text" value="#{value}" />
 <script type="text/javascript">
    Ext.onReady( function(){ new Biorails.DateField({ format: 'Y-m-d', applyTo: '#{object_name}_#{method}'}); } );
 </script>
HTML
	
  rescue Exception => ex
    logger.error ex.message
    logger.error ex.backtrace.join("\n")    
    "Err. (no date picker)"
  end

  # ## Html editor data entry field
  # 
  def html_field(object_name,method ,options={:class=>'x-hidden'})
    return <<HTML	
 #{text_area(object_name,method,options)} 
 <script type="text/javascript">
    Ext.onReady( function(){ 
       Ext.QuickTips.init();  // enable tooltips
       control = new Ext.form.HtmlEditor(
          Ext.apply( #{options.to_json} ,{
             applyTo: "#{object_name}_#{method}",
             id: "#{object_name}_#{method}",
             enableFontSize: true,
             enableFormat: true,
             enableLists: true,
             anchor:'100%, 100%',
             width: (Biorails.getWidth()-50),
             height: (Biorails.getHeight()-250),
             enableLinks: true,
             enableSourceEdit: true,
             enableColours:true
            }));

      control.applyToMarkup("#{object_name}_#{method}"); 
      control.getToolbar().setHeight(28);
      control.getToolbar().setWidth(control.width-2);      
      control.on('show', function(field){field.updateBox(1,1,Biorails.getWidth()-50,Biorails.getHeight()-250);});
    } );
 </script>
HTML
    rescue Exception => ex
    logger.error ex.message
    "Err. (no html editor found)"
  end
  # ## Html editor data entry field
  # 
  def document_field(object_name,method,options={})
    title ||= method
    return <<HTML	
  #{text_area(object_name,method,options)} 
 <script type="text/javascript">
    Ext.onReady( function(){ 
        new Biorails.DocumentField( '#{object_name}_#{method}'); 
    } );
 </script>
HTML
    rescue Exception => ex
    logger.error ex.message
    "Err. (no html editor found)"
  end
 
  # 
  # multiple purpose selector of items Accepts
  #    1. arrays of named objects
  #    2. Instances of Assay,Experiment,Project,ProjectFolder,DataContent,DataElement
  #    3. Model Class
  #    4. String name for a data concept
  # 
  def select_values(object,method, source = nil,initial_list=nil)
    list = initial_list || [[nil,nil]]
    if source[0].respond_to?(:path)
      source.each { |item| list << [item.path,item.id]}
    elsif source[0].respond_to?(:name)
      source.each { |item| list << [item.name,item.id]}
    elsif source[0].is_a?(ActiveRecord::Base)
      source.each { |item| list << [item.to_s,item.id]}
    elsif source[0].is_a?(Array)
      source.each { |item| list << [item[0],item[1]]}
    else
      source.each { |item| list << [item.to_s,item]}
    end
    <<HTML
  #{select(object, method ,list)}
  <script type="text/javascript">
    Ext.onReady( function(){ 
              new Biorails.SelectField({
                           transform: '#{object}_#{method}',
                           root_class: '#{source.class}',
                           root_id: '#{source.object_id}'
                        });
   });
  </script> 
HTML
    rescue Exception => ex
    logger.error ex.message
  end

  def assigned_user_combo(entity,options={})
    options = {
      :with =>'assigned_to_user_id',
      :url=>{:action=>'update_row',:id=>entity},}.merge(options)
    
    text = select_tag 'assigned_to_user_id', 
      options_for_select( entity.folder.access_control_list.users, entity.assigned_to_user_id), 
      {:id=> entity.dom_id('assigned_to_user_id')}  

    text << observe_field(entity.dom_id('assigned_to_user_id'),options)    
    return content_tag('div',text)   
  end

  def states_combo(element,cascade=true)
    if element.state.published? or element.state.signed?
      content_tag('strong',element.state)
    elsif element.right?(:data,:update)
      state =State.get(element.state)
      list =  element.allowed_states(cascade)
      list = list.select{|i|!i.signed?}
      text = select_tag(element.dom_id('state_id') ,
        options_from_collection_for_select(list,:id,:name,state.id ),
        :class=>"state-level#{state.level_no} icon icon-status_#{state.name.downcase}" )
      
      text << observe_field(element.dom_id('state_id'), 
        :url=>element_url({:action=>'state',:display=>'combo',:id=>element}),
        :update=>element.dom_id('state'),
        :with =>'state_id')
            
      return content_tag('div',text,
        :id=>element.dom_id('state')   )
    end
  end
  
  # ## Return a list of the allowed Elements that can be used as specializations
  # of the passed concept of children of the passed element.
  # 
  #  * object  to build selector around
  #  * method of the object to build selector for
  #  * root [default=nil] root on tree of items to display
  # 
  def select_data_element(object,method, root=nil)
    list = []
    case root
    when String
      element = DataElement.find_by_name(root)
      for item in element
        list.concat(item.elements.collect{|c|[c.summary,c.id]})
      end     
    when DataConcept
      logger.info "concept #{root}"
      for item in root.decendents
        list.concat(item.elements.collect{|c|[c.summary,c.id]})
      end
    when DataElement
      for item in root.decendents
        list.concat([item.summary,item.id])
      end
    else
      list.concat(DataElement.find(:all,:conditions=>'parent_id is null',:order=>'name').collect{|c|[c.summary,c.id]})   
    end
    <<HTML
  #{select(object, method ,list)}
  </script> 
HTML
    rescue Exception => ex
    logger.error ex.message
    return "[No Element]"  << hidden_field(object,method )
  end


  def select_data_element_tag(object, source = nil, value=nil,options={})
    data_element = case source
                    when String then DataElement.find_by_name(source)
                    when Fixnum then DataElement.find_(source)
                    when DataElement then source
                      DataElement.find(:first,:conditions=>'parent_id is null',:order=>'name')
                    end
    select_tag(object, options_for_select(data_element.values.collect{|i|[i.name,i.name]},value))
  rescue Exception => ex
     logger.error ex.message
     return "[No Element #{ex.message}]"  << hidden_field_tag(object)
  end

  # ## List of a allowed data formats
  # 
  def select_data_format(object,method, item = nil)   
    formats =[];
    case item
    when DataType
      formats = item.data_formats
    else
      formats = DataFormat.find(:all,:order=>'name') 
    end
    <<HTML
  #{collection_select(object, method ,formats, :id, :name) }
  </script> 
HTML
    rescue Exception => ex
    logger.error ex.message
    return "[No Formats]"  << hidden_field(object,method )
  end
  #
  # Lookup Combo for default data element linked to a concept.
  #
  def select_concept(object,method,concept,value=nil)
    data_concept = (concept.is_a?(DataConcept) ? concept : DataConcept.find(concept) )
    return "[No data concept: #{concept}]" unless data_concept
    return "[No implementation of concept: #{concept}]" unless data_concept.default
    select_element(object,method, data_concept.default,value)
  rescue Exception => ex
    logger.error ex.message
    return "[Error: #{ex.message} for Concept #{concept} ]"  << hidden_field(object,method)
  end
  #
  # Lookup Combo for default data element linked to a concept.
  #
  def select_element(object,method, element,value=nil)
    data_element = (element.is_a?(element) ? element : DataElement.find(element) )
    return "[No data element: #{element}]" unless data_element
    <<HTML
      #{hidden_field(object, method,value.id)}
		  #{text_field_tag("#{object}_#{method}_name",value.name)}
		 <script type="text/javascript">
		   Ext.onReady( function(){
            new Biorails.PropertyComboField({
                  url: '/admin/element/select/#{data_element.id}',
                  hiddenField: '#{object}_#{method}',
                  valueField:  'id',
                  minListwidth: 150,
                  displayField: 'name',
                  applyTo: '#{object}_#{method}_name'
                 });
           } );
		 </script>
HTML
  rescue Exception => ex
    logger.error ex.message
    return "[Error: #{ex.message} for Concept #{element} ]"  << hidden_field(object,method)
  end

  def select_parameter_role(object, method_name)
    list = ParameterRole.find(:all,:order=>:name)
    collection_select(object, method_name,list,:id,:name)
  rescue Exception => ex
    logger.error ex.message
    return "[Error: #{ex.message} #{source.to_s} Model]"  << hidden_field(object,method_name)
  end
  #
  # Select within the scope of the passed instance or model
  #
  def select_named(object, method_name, source = nil,options={})
      model = ModelExtras.model_from_name(source)
      begin
        value =  eval("@#{object}.send :#{method_name}") unless object.nil? or method_name.nil?
        value =  model.find(value)
      rescue Exception=>ex
        logger.info "select_named(#{object},#{method_name},#{source}..) #{ex.message}"
        value = nil
      end

    return <<HTML

      #{hidden_field(object, method_name)}
		  #{text_field_tag("#{object}_#{method_name}_name", (value ? value.name : nil))  }

		  <script type="text/javascript">
			Ext.onReady( function(){
            new Biorails.PropertyComboField({
                  url: '/admin/element/choices/#{model}',
                  hiddenField: '#{object}_#{method_name}',
                  minListwidth: 150,
                  width: #{options[:width]||150},
                  valueField:  'id',
                  displayField: 'name',
                  applyTo: '#{object}_#{method_name}_name'
                 });
            } );
		  </script>
HTML
  rescue Exception => ex
    logger.error ex.message
    return "[Error: #{ex.message} #{source.to_s} Model]"  << hidden_field(object,method_name)
  end

  #
  # Select within the scope of the passed instance or model
  #
  def select_named_tag(object, source = nil, value=nil,options={})
      model = ModelExtras.model_from_name(source)
      field_options = {:type=>:hidden, :value=> value,:name=>object, :id=> object}.merge(options)
      value = model.find(value||:first)
      return <<HTML
      #{tag(:input, field_options)}
		  #{text_field_tag("#{object}_name",(value ? value.name : nil))}
		  <script type="text/javascript">
			Ext.onReady( function(){
            new Biorails.PropertyComboField({
                  url: '/admin/element/choices/#{model}',
                  hiddenField: "#{object}",
                  valueField:  'id',
                  minListwidth: 150,
                  width: #{options[:width]||150},
                  displayField: 'name',
                  applyTo: "#{object}_name"
                 });
            } );
		  </script>
HTML
  rescue Exception => ex
    logger.error ex.message
    return "[Error: #{ex.message} #{source.to_s} Model]"  << hidden_field_tag(object)
  end

  # 
  # 
  # 
  def select_process(object,method, list = nil,latest=false)
    protocol_options= []
    list ||= Project.current.protocols
    list.each do |item|
      if item.released
        protocol_options << ["#{item.released.summary} ",item.released.id]
      elsif (latest)
        protocol_options << ["#{item.latest.summary} ",item.latest.id]
      end
    end    
    <<HTML
  #{select(object, method ,protocol_options) }
HTML
    rescue Exception => ex
    logger.error ex.message
    logger.error ex.backtrace.join("\n")    
    return "[No Protocols]"  << hidden_field(object,method) 
  end  

  def select_process_instance(object,method, list = nil)
    protocol_options= []
    list ||= Project.current.process_instances
    list.each do |item|
      protocol_options << ["#{item.summary} ",item.id]
    end
    
    <<HTML
  #{select(object, method ,protocol_options.sort) }
HTML
    rescue Exception => ex
    logger.error ex.message
    return "[No Protocols]"  << hidden_field(object,method) 
  end

  # ## Handlers for specific data types
  # 
  def my_field_tag(id, name, parameter, options = {})
    #     logger.info "my_field_tag( #{id}, #{name}, #{parameter} ,#{options.to_s})"
    options[:mask]    ||= parameter.mask if parameter.mask
    options[:default] ||= parameter.default_value  if parameter.default_value  
    options[:value]   ||=  parameter.default_value  if parameter.default_value  
      
    case parameter.data_type_id
    when 1 then my_regex_tag(id, name, options)
    when 2 then my_regex_tag(id, name, options)
    when 3 then my_date_field(id,name,parameter.default_value,options)
    when 4 then my_regex_tag(id, name,options)
    when 5 then my_lookup_tag(id,name, parameter.element,options)
    when 6 then my_regex_tag(id, name, options)
    when 7 then my_file_field(id,name, current_element)
    else 
      text_field_tag(cell.dom_id,cell.value)
    end     
  rescue Exception => ex
    logger.warn "#Error "+ex.message
  end

  # ## 1) Display Text field 2) On change validate with regex 3) On exit of
  # field do ajax to server to save
  # 
  def my_regex_tag(id, name, options={})
    
    return <<HTML
#{content_tag( :input,nil, { "name" => name, "id" => id }.update(options.stringify_keys)) }
    <script type="text/javascript">
    Ext.onReady( function(){ 

    field = new Biorails.RegExpField({
    regex: new RegExp('#{options[:mask]}'),  
                    url: '#{options[:save]}',
                    applyTo: '#{id}'   
      }); 
    } );
 </script>
HTML
  end

  # ## lookup cell either a combo for short list of a autocomplete for longer
  # lists
  # 
  def my_file_field(id,name, folder=nil ,options={})
    return my_regex_tag(id,name,options) if folder.nil?
    options[:mask]    ||= '.'
    options[:default] ||= ''
    options[:autocomplete]   ||= 'off'
    return <<HTML
#{content_tag( :input,nil, { "name" => name, "id" => id }.update(options.stringify_keys)) }
    <script type="text/javascript">
    Ext.onReady( function(){

    field = new Biorails.FileComboField({
    applyTo: '#{id}',
             folder_id: #{folder.id},
             url: '#{options[:save]}'
      });
  });
</script> 
HTML
  end

  # ## Date selector cell
  # 
  def my_date_field(id,name,value,options={})
    options[:mask]    ||= '.'
    options[:value]   ||= value ? value.strftime("%Y-%m-%d") :""
    options[:default] ||= ''
    options[:autocomplete]   ||= 'off'
 
    out = String.new	 
    out << tag( :input, { "type" => "text", "name" => name, "id" => id}.update(options.stringify_keys)) 
    out << <<HTML	
 <script type="text/javascript">
    Ext.onReady( function(){ 
        new Biorails.DateField({ 
            format: 'Y-m-d', 
            url: '#{options[:save]}',
            applyTo: '#{id}'
        }); 
    } );
 </script>
HTML

  end

  # ## lookup cell either a combo for short list of a autocomplete for longer
  # lists
  # 
  def my_lookup_tag(id,name, data_element=nil ,options={})
    options[:mask]    ||= '.'
    # ##    options[:onfocus] ||= 'FieldEntry( this,event)'
    if data_element.nil?
      return my_regex_tag(id, name,options)
    elsif data_element.estimated_count and data_element.estimated_count < 20
      options[:onchange]  ||= 'FieldSave(this,event)'         
      option_tags = options_for_select(data_element.values.collect{|i|[i.name,i.name]},options[:value]) 
      return <<HTML
		 #{content_tag( :select, option_tags, { "name" => name, "id" => id }.update(options.stringify_keys)) }
		 <script type="text/javascript">
		   Ext.onReady( function(){ 
              new Biorails.SelectField({ 
                        url: '#{options[:save]}',
                        transform: '#{id}',
                        root_class: 'DataElement',
                        root_id: #{data_element.id}
                    }); 
           } );
		 </script> 
HTML
	   
    else
      return <<HTML
		  #{content_tag( :input,nil, { "name" => name, "id" => id }.update(options.stringify_keys)) }
		  <script type="text/javascript">
			Ext.onReady( function(){ 
                new Biorails.ComboField({
                        url: '#{options[:save]}',
                        applyTo: '#{id}',
                        root_class: 'DataElement',
                        root_id: #{data_element.id}
                 }); 
            } );
		  </script> 
HTML
    end
  end
 
  def my_in_place_editor_field(object, method, tag_options = {}, in_place_editor_options = {})
    tag_options = {:id => "#{object.class.to_s.underscore}_#{method}_#{object.id}_in_place_editor", 
      :class => "in_place_editor_field"}.merge!(tag_options)
    in_place_editor_options[:url] = in_place_editor_options[:url] || url_for({ :action => "set_#{object.class.to_s.underscore}_#{method}", :id => object.id })
    content_tag("span",object.send(method), tag_options) +   in_place_editor(tag_options[:id], in_place_editor_options)
  end

end
  
