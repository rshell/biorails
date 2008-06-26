##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##


module Project::FoldersHelper
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
             :summary => '[parent] ',
             :updated_by => folder.updated_by,
             :updated_at => folder.updated_at.strftime("%Y-%m-%d %H:%M:%S") }
    end
    elements.each do |item| 
         actions = " "
         if item.is_a? ProjectContent
           actions << link_to( " Edit ",   content_url( :action => 'edit', :id => item ), :class => "button") 
         elsif item.is_a? ProjectAsset
           actions << link_to( " Edit ",     asset_url( :action => 'edit', :id => item ), :class => "button") 
         elsif item.reference
           actions << link_to( " Open ",     reference_to_url(item), :class => "button") 
         end    
         if item.child_count==0 and item.reference.blank?
           actions << link_to( " Delete ", folder_url( :action => 'destroy', :id => item ),
                     :class => "button", :confirm => 'Are you sure?',:method => "post") 
         end
         list <<   {:id =>item.id,
                    :position => item.position,
                    :left_limit => item.left_limit,
                    :right_limit => item.right_limit,
                    :icon => item.icon( {:images=>true} ) ,
                    :name => element_to_json_or_url(item), 
                    :summary => item.summary,
                    :reference_type => item.reference_type, 
                    :version_no => item.version_no,
                    :updated_by => item.updated_by,
                    :updated_at => item.updated_at.strftime("%Y-%m-%d %H:%M:%S"), 
                    :actions =>  actions }     
    end
    {:folder_id => folder.id, :path => folder.path,  :total => folder.elements.size ,:items => list }.to_json	    
  end

  #
  # version of element_url modified with quick hack to display pop ups
  # @TODO sort this and more to javascript
  #
  def element_to_json_or_url(item)
    if item.content_id
          { :title=>item.name,
            :url=>content_url(:action=>'show',:format=>'ext', :id=>item.id, :folder_id=>item.parent_id ), 
          }.to_json
      elsif item.asset_id
          { :title=>item.name,
            :icon=>item.icon({:images=>true}),
            :url=>asset_url(:action=>"show",:format=>'ext', :id=>item), 
            :height=>400,
            :width=>400
          }.to_json
    else
         link_to(item.name, folder_url(:action=>'show', :id=> item.id ))
      end
  end
  
end
