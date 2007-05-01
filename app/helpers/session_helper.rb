module SessionHelper

   
###
# Display a Hit list last search user performanced 
# This uses the session[:hits] as a cache of hits
# 
  def hitlist
     @hits = session[:hits] 
     render :partial => 'shared/hitlist', :layout => false      
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
       "Err. (no hitlist)"
  end

###
# Display a Hit list last search user performanced 
# This uses the session[:hits] as a cache of hits
# 
  def hitlist
     @hits = session[:hits] 
     render :partial => 'shared/hitlist', :layout => false      
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
       "Err. (no hitlist)"
  end

##
# Convert a type/id reference into a url to the correct controlelr
#    
  def link_to_object( element, name=nil ,options = {:action=>'show'})
    logger.info(" link_to_object #{name} #{element.class} #{element.id}")
    if element
      case  element
      when Project :        link_to name || element.name, project_url( options.merge({ :id=>element.id}) )
      when ProjectElement:  link_to name || element.name, element_url( options.merge({ :id=>element.id ,:folder_id=>element.parent_id}) )
      when ProjectContent:  link_to name || element.name, content_url( options.merge({ :id=>element.id ,:folder_id=>element.parent_id}) )
      when ProjectAsset :   link_to name || element.name, asset_url(   options.merge({ :id=>element.id ,:folder_id=>element.parent_id}) )
      
      when Study :          link_to name || element.name, study_url(      options.merge({ :id=>element.id}) )
      when StudyProtocol:   link_to name || element.name, protocol_url(   options.merge({ :id=>element.id})  )
      when StudyQueue:      link_to name || element.name, queue_url(      options.merge({ :id=>element.id})  )
      when QueueItem:       link_to name || element.data_name, queue_url( options.merge({ :id=> element.queue.id}) )
      when ProtocolVersion: link_to name || element.name, protocol_url(   options.merge({ :id=> element.protocol.id}) )
      when StudyParameter:  link_to name || element.name, study_parameter_url( options.merge({:id=>element.id}) )
  
      when Experiment:      link_to name || element.name, experiment_url(   options.merge({:id=>element.id})  )
      when Task:            link_to name || element.name, task_url(         options.merge({:id=>element.id})  )
      when Report:          link_to name || element.name, report_url(       options.merge({:id=>element.id})  )
      when Request:         link_to name || element.name, request_url(      options.merge({:id=>element.id})  )
      when RequestService:  link_to name || element.name, request_service_url(options.merge({:id=>element.request.id}) )

      when Compound:        link_to name || element.name, compound_url(       options.merge({:id=>element.id})  )
      when Batch:           link_to name || element.name, batch_url(          options.merge({:id=>element.id})  )
      #when Sample:          link_to name || element.name, sample_url(         options.merge({:id=>element.id})  )
      when Plate:           link_to name || element.name, plate_url(          options.merge({:id=>element.id}) )
      when Container:       link_to name || element.name, container_url(      options.merge({:id=>element.id})  )
      when Specimen:        link_to name || element.name, specimen_url(       options.merge({:id=>element.id})  )
      when TreatmentGroup:  link_to name || element.name, treatment_group_url(options.merge({:id=>element.id})  )
      else
         element.name if element.respond_to?(:name)
      end
    end
  end   
end

