module Project::FoldersHelper

  include TreeHelper

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
