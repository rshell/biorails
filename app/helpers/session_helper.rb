module SessionHelper

   
##
# Convert a type/id reference into a url to the correct controlelr
#    
  def link_to_object( element, link_name=nil ,options = {:action=>'show'})
    name = link_name
    name ||= element.name if element.respond_to?(:name)
    if element
      case  element
      when ProjectElement:  link_to name , folder_url( options.merge({ :id=>element.id ,:folder_id=>element.parent_id}) )
      when QueueItem:       link_to element.data_name, queue_item_url( options.merge({ :id=> element.id}) )
      when ProtocolVersion: link_to name , protocol_url(   options.merge({ :id=> element.protocol.id}) )
      when RequestService:  link_to name , request_service_url(options.merge({:id=>element.request.id}) )
      else
          link_to_model(element.class,element.id,name,options)
      end
    end
  end   

##
# Convert a type/id reference into a url to the correct controlelr
#    
  def link_to_model( model,id, link_name=nil ,options = {:action=>'show'})
    name = link_name || model.to_s 
    if model and id
      case  model.to_s.camelcase
      when 'Project' :        link_to  name, project_url( options.merge({ :id=>id} ) )
      when 'ProjectElement':  link_to  name, folder_url( options.merge({ :id=>id} ) )
      when 'ProjectFolder':   link_to  name, folder_url( options.merge({ :id=>id} ) )
      
      when 'Study' :          link_to name , study_url(      options.merge({ :id=>id}) )
      when 'StudyProtocol':   link_to name , protocol_url(   options.merge({ :id=>id})  )
      when 'StudyQueue':      link_to name , queue_url(      options.merge({ :id=>id})  )
      when 'QueueItem':       link_to name , queue_item_url( options.merge({ :id=> id}) )
      when 'StudyParameter':  link_to name , study_parameter_url( options.merge({:id=>id}) )
  
      when 'Experiment':      link_to name , experiment_url(   options.merge({:id=>id})  )
      when 'Task':            link_to name , task_url(         options.merge({:id=>id})  )
      when 'Report':          link_to name , report_url(       options.merge({:id=>id})  )
      when 'Request':         link_to name , request_url(      options.merge({:id=>id})  )
      when 'RequestService':  link_to name , request_service_url(options.merge({:id=>id}) )

      when 'Compound':        link_to name , compound_url(       options.merge({:id=>id})  )
      when 'Batch':           link_to name , batch_url(          options.merge({:id=>id})  )
      when 'Plate':           link_to name , plate_url(          options.merge({:id=>id}) )
      when 'Container':       link_to name , container_url(      options.merge({:id=>id})  )
      when 'Specimen':        link_to name , specimen_url(       options.merge({:id=>id})  )
      when 'TreatmentGroup':  link_to name , treatment_group_url(options.merge({:id=>id})  )
      else
         name
      end
    end
  end   

end

