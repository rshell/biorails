##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##


module FoldersHelper
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
             :owner => folder.created_by,
             :state => folder.state_name,
             :summary => '[parent] ',
             :updated_by => folder.updated_by,
             :updated_at => folder.updated_at.strftime("%Y-%m-%d %H:%M:%S") }
    end
    elements.each do |item| 
         entry = {:id =>item.id,
                  :position => item.position,
                  :left_limit => item.left_limit,
                  :right_limit => item.right_limit,
                  :icon => item.icon( {:images=>true} ) ,
                  :path => item.path,
                  :name => link_to(item.name,element_to_url(item)), 
                  :html => (item.content ? item.content.body_html : ""),
                  :href => reference_to_url(item),
                  :state => item.state_name,
                  :summary => item.summary,
                  :reference_type => item.reference_type, 
                  :version_no => 0,
                  :updated_by => item.updated_by,
                  :updated_at => item.updated_at.strftime("%Y-%m-%d %H:%M:%S"), 
                  :actions =>  "" 
            }     
       if item.is_a? ProjectContent
           entry[:actions] << link_to( " Edit ", content_url( :action => 'edit', :id => item ), :class => "button") 
         elsif item.is_a? ProjectAsset
           entry[:actions] << link_to( " Edit ",  asset_url( :action => 'edit', :id => item ), :class => "button") 
           entry[:html] = link_to item.html, asset_url(:id=>item) 
         elsif item.reference
           entry[:actions] << link_to( " Open ",  reference_to_url(item), :class => "button") 
         end    
         if item.all_children_count==0 and item.reference.blank?
           entry[:actions] << link_to( " Delete ", folder_url( :action => 'destroy', :id => item ),
                     :class => "button", :confirm => 'Are you sure?',:method => "post") 
         end
         list << entry  
    end
    {:folder_id => folder.id, :path => folder.path,  :total => folder.elements.size+1 ,:items => list }.to_json	    
  end

end
