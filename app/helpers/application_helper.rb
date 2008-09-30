# ##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
# Methods added to this helper will be available to all templates in the
# application.
module ApplicationHelper
  
  #def logged_in?
  #  !session[:user_id].nil?
  #end
 
  # ### Simple boolean switch for display of a div
  # 
  def display(ok)
    if ok
      ''
    else
      'style="display: none;"'
    end
  end

  # 
  # Customer version of error_messages display
  # 
  def error_messages_for(*params)
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'errorExplanation'
        end
      end
      header_message = "Errors prohibited this [#{(options[:object_name] || params.first).to_s.gsub('_', ' ')}] from being saved"
      error_messages = objects.collect {|object| 
        object.errors.collect {|att, msg| 
          if msg.is_a?Array 
            content_tag(:li,  object.class.human_attribute_name(att) +' '+  msg[0].sub(/%d/,msg[1].to_s) 
            )
          else 
            content_tag(:li, object.class.human_attribute_name(att) + ' ' + msg)
          end } }
      content_tag(:div,
        content_tag(options[:header_tag] || :h4, header_message) <<
          content_tag(:p, 'There were problems with the following fields:') <<
          content_tag(:ol, error_messages),
        html
      )
    else
      ''
    end
  end
  # 
  # Update the the content of the main  panel
  # 
  def main_panel(*options_for_render)
    call 'Element.update','center', render(*options_for_render)   
  end
  # 
  # Update the the content of the help panel
  # 
  def help_panel(*options_for_render)
    call 'Element.update','help', render(*options_for_render)   
  end
  # 
  # Update the the content of the work area panel
  # 
  def work_panel(*options_for_render)
    call 'Element.update','work', render(*options_for_render)   
  end
  # 
  # Update the the content of the status panel
  # 
  def status_panel(*options_for_render)
    call 'Element.update','status', render(*options_for_render)  
    page<< "Biorails.focus('status');"
  end
 
  def message_panel(*options_for_render)
    call 'Element.update','messages', render(*options_for_render)  
  end

  # 
  # Update the the content of the audit panel
  # 
  def audit_panel(*options_for_render)
    call 'Element.update','audit', render(*options_for_render)
  end
  # 
  # Update the menu actions
  # 
  def actions_panel(*options_for_render)
    call 'Element.update','sidemenu', render(*options_for_render)
  end
  # 
  # Update the tree panel
  # 
  def tree_panel(*options_for_render)
    call 'Element.update','tree', render(*options_for_render)
  end

  # 
  # @TODO move version number as part of signature
  # 
  def version_no(path)
    # #a bit cryptic this - we want the number in the filename after the _V but
    # before the .extension #so we match all the digits after _V.  The result of
    # the match is stored in a thread-local variable $2 #($1 contains '_V').  if
    # there is no document which is versioned return 0 rather than nil
    path.match(/(_V)(\d*)/)
    $2 || '0'
  end
  
  def docpath(path)
    # #it's hard to rescue the error caused by a missing file in the public
    # directory because it's served before the application #controller can catch
    # the error - so check the file is there first
    if File.file?(File.join(RAILS_ROOT,"public",SystemSetting.get("published_folder").value,path+".pdf"))
      return "<a href='/"+SystemSetting.get("published_folder").value+"/"+path+".pdf'>show pdf</a>"
    else
      return "missing file "
    end  
  end
  
  def zippath(path)
    if File.file?(File.join(RAILS_ROOT,"public",SystemSetting.get("published_folder").value,path+".tar.gz"))
      return "<a href='/"+SystemSetting.get("published_folder").value+"/"+path+".tar.gz'>show zip</a>"
    else
      return "missing file "
    end
  end
  
##
# Convert a type/id reference into a url to the correct controlelr
#    
  def link_to_object( object, link_name=nil ,options = {:action=>'show'})
    return "[none]" unless object
    name = link_name
    name ||= object.name if object.respond_to?(:name)
    name ||= object.name if object.respond_to?(:data_name)
    name ||= object.class.to_s
    if object
        link_to(name,object_to_url(object,options) )
    end
  end   
  
  
  ##
# Convert a type/id reference into a url to the correct controlelr
#    
  def object_to_url( object,options = {:action=>'show'})
    return "" unless object
    id = object.id
    if object
      case  object
      when ProjectAsset then    asset_url(   options.merge(  { :id=>id ,:folder_id=>object.parent_id}) )
      when ProjectContent then  content_url( options.merge({ :id=>id ,:folder_id=>object.parent_id}) )
      when ProjectElement then  folder_url(  options.merge( { :id=>id ,:folder_id=>object.parent_id}) )

      when QueueItem then       queue_item_url( options.merge({ :id=> id}) )
      when ProcessInstance then process_instance_url(   options.merge({ :id=> object.id}) )
      when ProcessFlow     then process_flow_url(   options.merge({ :id=> object.id}) )
      when RequestService then  request_url(options.merge({:id=>object.request.id}) )

      when Project then         project_url( options.merge({ :id=>id} ) )
      when ProjectElement then  folder_url( options.merge({ :id=>id} ) )
      when ProjectFolder then   folder_url( options.merge({ :id=>id} ) )
      
      when Assay then           assay_url(  options.merge({ :id=>id}) )
      when AssayProtocol then   assay_url(   options.merge({ :id=>object.assay_id})  )
      when AssayQueue then      queue_url(  options.merge({ :id=>id})  )
      when QueueItem then       queue_item_url( options.merge({ :id=> id}) )
      when AssayParameter then  assay_parameter_url( options.merge({:id=>id}) )
  
      when Experiment then      experiment_url(   options.merge({:id=>id})  )
      when Task then            task_url(         options.merge({:id=>id})  )
      when Report then          report_url(       options.merge({:id=>id})  )
      when Request then         request_url(      options.merge({:id=>id})  )
#
# @todo hooks from plugins 
#
      when Compound then       compound_url(       options.merge({:id=>id})  )
      when Batch then          batch_url(          options.merge({:id=>id})  )
      when Plate then          plate_url(          options.merge({:id=>id}) )
       
      else 
        # catch all guess controller from model name
        #
        url_for( options.merge({:controller=>object.class.to_s.tableize,:action=>'show', :id=>id}) )
      end
    end
  end  
   
  # ## Convert a element in to a url call to display it
  # 
  def element_to_url(element)
    case element
    when ProjectFolder
      folder_url(:action=>'show', :id=> element.id )
    when ProjectContent
      content_url(:action=>'show', :id=>element.id ,:folder_id=>element.parent_id )
    when ProjectAsset
      asset_url(:action=>'show',:id=>element.id,:folder_id=>element.parent_id )
    else
      element_url(:action=>'show', :id=>element.id, :folder_id=>element.parent_id )
    end
  end  

  # ## Convert a type/id reference into a url to the correct controlelr
  # 
  def reference_to_url(element)
    case element.attributes['reference_type']
    when 'Project'  then        project_url(:action=>'show', :id=>element.reference_id )
    when 'ProjectContent' then  content_url(:action=>'show', :id=>element.id ,:folder_id=>element.parent_id )
    when 'ProjectAsset'  then   asset_url(:action=>'show',:id=>element.id,:folder_id=>element.parent_id )
    when 'Assay'  then          assay_url(:action=>'show', :id=> element.reference_id )
    when 'AssayParameter' then  assay_parameter_url(:action=>'show', :id=> element.reference_id )
    when 'AssayProtocol' then   object_to_url(element.reference.latest )
    when 'ProtocolVersion' then object_to_url(element.reference )
    when 'Experiment' then      experiment_url(:action=>'show', :id=> element.reference_id )
    when 'Task' then            task_url(:action=>'show', :id=> element.reference_id )
    when 'Report' then          report_url(:action=>'show', :id=> element.reference_id )
    when 'Request' then         request_url(:action=>'show', :id=> element.reference_id )
    when 'Compound' then        compound_url(:action=>'show', :id=> element.reference_id )
    else
      element_to_url(element)
    end
  end  
  #
  # Complete tree for project
  #  
  def project_tree(folder)
    branch = folder.self_and_ancestors
    root  = branch[0]
    elements = root.full_set
    tree = {}
    items = []
    elements.each do |rec| 
      item = element_to_hash(rec) 
      tree[rec.id] = item        
      if (branch.include?(rec))       
        item[:expanded] = true
      end
      if rec.parent_id  
        parent = tree[rec.parent_id] 
        parent[:children] ||=[]
        parent[:children] << item
      else
        items << item  
      end
    end  
    items.to_json          
  end  
  #
  #
  #
  def elements_to_open(elements,chain=nil)
    chain ||= []
    open_element = chain.first        
    items =[]
    elements.each do |rec| 
        item = element_to_hash(rec)     
          if (open_element == rec)       
             item[:expanded] = true
             item[:children] = elements_to_open(rec.children,chain[1..10000]) 
          end
      items << item  
    end       
    return items
  end
  #
  #
  #
  def elements_to_json_level(elements)
    items = elements.collect { |rec|    element_to_hash(rec) } 
    items.to_json      
  end
  #
  # Create a tree with a open branch based on the chain
  #
  def elements_to_json_tree(elements,chain)
    items = elements_to_open(elements,chain)
    items.to_json      
  end
  #
  # Convert a element to a hash to transfer to javascript
  #
  def element_to_hash(rec)
      {
      :id => rec.id,
      :text => rec.name,
      :href => reference_to_url(rec),
      :icon => rec.icon,
      :iconCls =>  "icon-#{rec.class.to_s.underscore}",
      :allowDrag => true,
      :allowDrop => (rec.class == ProjectFolder),	
      :leaf => !(rec.class == ProjectFolder), 
      :qtip => rec.summary		
      }    
  end

  def tab_item(params={})
    if params[:partial]
    out = <<-HTML
       { title: "#{params[:title]||params[:name]}",
          contentEl: "tab-#{params[:name]}"  }
HTML
    else  
    out = <<-HTML
       { title: "#{params[:title]||params[:name]}",
         contentEl: "tab-#{params[:name]}",
         listeners: { activate: function(panel){
                         panel.getUpdater().refresh();} 
                    },
         autoLoad: {url: "#{params[:url]}", scripts: true}  }
HTML
    end
  end  

# tab_strip("xxx",[
#  {:name =>'show'    , :div=> :tab-show }
#  {:name =>'import'  , :url=> task_url(:action=>'import',   :format=>:ext,:id=>@task) }
#  {:name =>'entry'   , :url=> task_url(:action=>'sheet',    :format=>:ext,:id=>@task) }
#  {:name =>'review'  , :url=> task_url(:action=>'view',     :format=>:ext,:id=>@task)}
#  {:name =>'analysis', :url=> task_url(:action=>'analysis', :format => :ext, :id=> @task) }
#  {:name =>'metrics' , :url=> task_url(:action=>'metrics',  :format=>:ext,:id=>@task)}])
# end
# 
  def tab_strip(name,active=0,tabs=[])
    html_divs= tabs.collect do |tab| 
      if tab[:partial] 
        out = render(:partial => tab[:partial])
      else
        out = ""
      end
      " <div id='tab-#{tab[:name]}' class='tab-content x-hidden'>  #{out} </div>"
    end
    
    items= tabs.collect{|tab|tab_item(tab)}.join(",")
    out = <<-HTML
    <div id="#{name}" class="tabs">
       #{html_divs.join("\n")}
    </div>  
    
    <script type="text/javascript"> 
      Ext.onReady(function(){
        var tabs = new Ext.TabPanel({
          id: 'center-tabstrip',
          renderTo:"#{name}",
          activeTab: #{active},
          autoWidth: true,
          defaults: {
            autoWidth: true,
            autoHeight: true,
            autoScroll: false
          },
          items: [#{items}]});
    });
    </script>  
HTML
  end

end
