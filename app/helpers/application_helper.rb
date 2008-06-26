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
  
   
  # ## Convert a element in to a url call to display it
  # 
  def element_to_url(element)
    if element.content_id
      content_url(:action=>'show', :id=>element.id, :folder_id=>element.parent_id )
    elsif element.asset_id
      asset_url(:action=>'show',:id=>element.id, :folder_id=>element.parent_id )
    else
      folder_url(:action=>'show', :id=> element.id )
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
    when 'AssayProtocol' then   protocol_url(:action=>'show', :id=> element.reference_id )
    when 'Experiment' then      experiment_url(:action=>'show', :id=> element.reference_id )
    when 'Task' then            task_url(:action=>'show', :id=> element.reference_id )
    when 'Report' then          report_url(:action=>'show', :id=> element.reference_id )
    when 'Request' then         request_url(:action=>'show', :id=> element.reference_id )
    when 'Compound' then        compound_url(:action=>'show', :id=> element.reference_id )
    else
      element_to_url(element)
    end
  end  

end
