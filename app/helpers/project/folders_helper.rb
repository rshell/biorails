module Project::FoldersHelper

  include TreeHelper

##
# Generate a Tree for a project
#
  def tree_for_project(project)
      tree=TreeHelper::Tree.new('Project')
      tree.use_cookies = true
      folders = tree.add_node(project.home,:name,:elements) do |node,rec|
               node.html_link = element_to_url(rec)
      end    
      folders.open =true
      tree.add_collection('Studies',project.studies,:name,:protocols) do |node,rec|
          node.url = study_url(:action=>:show,:id=>rec) 
          node.icon = subject_icon("study")
      end
      tree.add_collection('Experiments',project.experiments,:name,:tasks)
      tree.add_collection('Requests',project.requests,:name,:services)
      return tree.to_html
  rescue Exception => ex
      logger.error "error: #{ex.message}"
      logger.error ex.backtrace.join("\n")    
      return "Failed in tree_for"
   end  
   
   
  def element_to_url(element)
    case element.attributes['reference_type']
    when 'ProjectContent'
       folder_url(:action=>'article', :folder_id=>element.parent.id, :element_id=>element.id, :content_id=> element.reference_id )

    when 'ProjectAsset'
       folder_url(:action=>'asset',   :folder_id=>element.parent.id, :element_id=>element.id, :asset_id=> element.reference_id )

    when 'Study'
       study_url(:action=>'show', :id=> element.reference_id )
       
    when 'Experiment'
       experiment_url(:action=>'show', :id=> element.reference_id )
       
    when 'Task'
       task_url(:action=>'show', :id=> element.reference_id )
       
    when 'StudyProtocol'
       protocol_url(:action=>'show', :id=> element.reference_id )
       
    else
       folder_url(:action=>'show', :id=> element.id )
    end
  end
  
end
