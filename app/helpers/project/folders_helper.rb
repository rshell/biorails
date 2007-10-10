module Project::FoldersHelper

  include TreeHelper

def folder_to_json(folder) 
    list = [] 
    if folder 
      folder.elements.each do |item| 
         actions = " "
         actions << link_to( "Edit",   content_url( :action => 'edit', :id => item ), :class => "button") if item.is_a? ProjectContent
         actions << link_to( "Edit",     asset_url( :action => 'edit', :id => item ), :class => "button") if item.is_a? ProjectAsset
         actions << link_to( "Delete", folder_url( :action => 'destroy', :id => item ), :class => "button", :confirm => 'Are you sure?',:method => "post") if item.child_count==0 
         list <<   [item.id,
                     item.icon( {:images=>true} ),
                     link_to(item.name, element_to_url(item)),
                     item.summary,
                     item.updated_by,
                     item.updated_at.strftime("%Y-%m-%d %H:%M:%S"), 
                     actions,
                     item.to_html  ]
      end
     end
     list.to_json   
  end
  
  def folder_drag_and_drop(folder)
    out = String.new
    out << 'Droppables.drops = [];'
    out << "\n"       
    for item in folder.elements 
      out <<  draggable_element_js(item.dom_id(:current) ,:scroll=> true,:ghosting => true, :revert=> true) 
      out << "\n"       

      out <<  drop_receiving_element_js(item.dom_id(:element), :hoverclass => "drop-active",   
           :accept =>'folder_element',
           :url => folder_url(:action=>"move_element",:id=>folder.id, :before=>item.id ))
      out << "\n"       

      out <<  drop_receiving_element_js(item.dom_id(:element), :hoverclass => "drop-active",   
           :accept =>['project_element','project_reference','project_content','project_asset'],
           :url => folder_url(:action=>"drop_element",:id=>folder.id, :before=>item.id ))
      out << "\n"       
    end      
    out << drop_receiving_element_js('folder_top', 
            :hoverclass => "drop-active",
             :accept =>['project_element','project_reference','project_content','project_asset'],
             :url => folder_url(:action=>'add_element',:id=>folder )
             ) 
    if @layout[:right] == 'right_finder' 
      out << drop_receiving_element_js('clipboard', :hoverclass => "drop-active",   
           :accept =>'folder_element',
           :url => folder_url(:action=>"clipboard",:id=>folder.id ))

      out << drop_receiving_element_js('clipboard', :hoverclass => "drop-active",   
           :accept =>'project_element',
           :url => folder_url(:action=>"clipboard",:id=>folder.id ))
           

    end        
    return out
           

  end  
  
end
