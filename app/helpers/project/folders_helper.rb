module Project::FoldersHelper

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
