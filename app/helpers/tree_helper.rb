##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
# Methods added to this helper will be available to all templates in the application.
module TreeHelper
#
# General JOSN for folder elements 
#  @param folder to use
#  @param elements optional subset of elements to use in case of large folders
#  @return string json 
#
  def folder_to_json( folder,elements = nil) 
    elements ||= folder.elements 
    list = []
    if folder.parent_id
       list << {:id => folder.id,
	         :icon => '/images/model/folder.png',
             :position => -1,
             :left_limit => -1,
             :right_limit => -1,
             :name => link_to_remote('..', :url=>folder_url(:action=>'show',:id=>folder.parent_id)),
             :summary => '[parent folder]',
             :updated_by => folder.updated_by,
             :updated_at => folder.updated_at.strftime("%Y-%m-%d %H:%M:%S") }
    end
    elements.sort{|a,b|a.left_limit <=> b.left_limit}.each_with_index{|e,i| e.position=i} 
    elements.each do |item| 
         actions = " "
         actions << link_to( " Edit ",   content_url( :action => 'edit', :id => item ), :class => "button") if item.is_a? ProjectContent
         actions << link_to( " Edit ",     asset_url( :action => 'edit', :id => item ), :class => "button") if item.is_a? ProjectAsset
         actions << link_to( " Delete ", folder_url( :action => 'destroy', :id => item ), :class => "button", :confirm => 'Are you sure?',:method => "post") if item.child_count==0 
         list <<   {:id =>item.id,
                    :position => item.position,
                    :left_limit => item.left_limit,
                    :right_limit => item.right_limit,
                    :icon =>  item.icon( {:images=>true} ),
                    :name =>  link_to_remote(item.name, :url=>element_to_url(item)),
                    :summary => item.summary,
					:reference_type => item.reference_type, 
                    :updated_by => item.updated_by,
                    :updated_at => item.updated_at.strftime("%Y-%m-%d %H:%M:%S"), 
                    :actions =>  actions }
    end
    {:folder_id => folder.id, :path => folder.path,  :total => folder.elements.count,:items => list }.to_json	    
  end

# 
# Convert a array of project elenments to json
#
#
  def elements_to_json(elements)
    items = elements.collect do |rec| 
	  {
		 :id => rec.id,
		 :text => rec.name,
         :href => reference_to_url(rec),
         :icon => rec.icon,
	     :iconCls =>  "icon-#{rec.class.to_s.underscore}",
         :allowDrag => !(rec.class == ProjectFolder),
         :allowDrop => (rec.class == ProjectFolder),	
	     :leaf => !(rec.class == ProjectFolder),
	     :qtip => rec.summary		
      }
    end 
    items.to_json      
  end
 
# 
# Convert a array of project elenments to json
#
#
  def data_concepts_to_json(elements)
    items = elements.collect do |rec| 
	  {
		 :id => rec.id,
		 :text => rec.name,
         :url => catalogue_url(:action=>:show,:id => rec.id),
	     :iconCls =>  "icon-concept",	
	     :leaf => (rec.children.count==0),
	     :qtip => rec.description		
      }
    end 
    items.to_json      
  end
 

  
##
# Convert a element in to a url call to display it
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

##
# Convert a type/id reference into a url to the correct controlelr
#    
  def reference_to_url(element)
    case element.attributes['reference_type']
    when 'Project' :        project_url(:action=>'show', :id=>element.reference_id )
    when 'ProjectContent':  content_url(:action=>'show', :id=>element.id ,:folder_id=>element.parent_id )
    when 'ProjectAsset' :   asset_url(:action=>'show',:id=>element.id,:folder_id=>element.parent_id )
    when 'Study' :          study_url(:action=>'show', :id=> element.reference_id )
    when 'StudyParameter':  study_parameter_url(:action=>'show', :id=> element.reference_id )
    when 'StudyProtocol':   protocol_url(:action=>'show', :id=> element.reference_id )
    when 'Experiment':      experiment_url(:action=>'show', :id=> element.reference_id )
    when 'Task':            task_url(:action=>'show', :id=> element.reference_id )
    when 'Report':          report_url(:action=>'show', :id=> element.reference_id )
    when 'Request':         request_url(:action=>'show', :id=> element.reference_id )
    when 'Compound':        compound_url(:action=>'show', :id=> element.reference_id )
    else
       element_to_url(element)
    end
  end  

end
