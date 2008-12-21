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
        :updated_at => folder.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
        :actions => link_to( l(:Show),  reference_to_url(folder), :class => "icon icon-show")}
    end
    elements.each do |item| 
      entry = {:id =>item.id,
        :position => item.position,
        :left_limit => item.left_limit,
        :right_limit => item.right_limit,
        :iconCls =>  (item.reference_type ? "icon-#{item.reference_type.underscore}" : "icon-#{item.class.to_s.underscore}"),
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
      entry[:actions] << link_to( l(:Show),  reference_to_url(item), :class => "icon icon-show")
      if item.is_a? ProjectContent
        entry[:actions] << link_to( l(:Edit), content_url( :action => 'edit', :id => item ), :class => "icon icon-edit")
      elsif item.is_a? ProjectAsset
        entry[:actions] << link_to( l(:Edit),  asset_url( :action => 'edit', :id => item ), :class => "icon icon-edit")
        entry[:html] = link_to item.html, asset_url(:id=>item)
      end
      if item.deletable?
        entry[:actions] << link_to( l(:Delete), folder_url( :action => 'destroy', :id => item ),
          :class => "icon icon-del", :confirm => 'Are you sure?',:method => "post")
      end
      list << entry
    end
    {:folder_id => folder.id, :path => folder.path,  :total => folder.elements.size+1 ,:items => list }.to_json	    
  end

end
