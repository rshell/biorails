class RsyncFolderReference < ActiveRecord::Migration
  
  def self.up
    
    #
    # xxxx
    #
    Project.find(:all).collect do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
      item.project_element_id
    end
    #
    # Project/assays/xxxx
    #
    Assay.find(:all).each do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
    end
    
    #
    # Project/assays/xxxx/parameters/xxxx
    #
    AssayParameter.find(:all).each do | item|
     item.project_element = ProjectElement.references(item)[0]
     item.save!
    end

    #
    # Project/assays/xxxx/queues/xxxx
    #
    AssayQueue.find(:all).each do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
    end

    #
    # project/assays/xxxx/protocols/xxxx
    #
    AssayProtocol.find(:all).each do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
    end
    #
    # project/assays/xxxx/protocols/xxxx/yyyy
    #
    ProtocolVersion.find(:all).each do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
    end
    
    #
    # project/experiments/xxxx/tasks/yyyy
    #
    Experiment.find(:all).each do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
    end
    #
    # project/experiments/xxxx/tasks/yyyy
    #
    Task.find(:all).each do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
    end
    #
    # project/experiments/xxxx/tasks/yyyy
    #
    Report.find(:all).each do | item|
      if item.project_id
        item.project_element = ProjectElement.references(item)[0]
        item.save!
      end
    end    
    #
    # project/experiments/xxxx/tasks/yyyy
    #
    CrossTab.find(:all).each do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
    end    
    #
    # project/experiments/xxxx/tasks/yyyy
    #
    Request.find(:all).each do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
    end
    #
    # project/requests/xxxx/requested_services/yyy
    # project/assay/xxxx/queue/yyyy/requested_services/yyy
    #
    RequestService.find(:all).each do | item|
      item.project_element = ProjectElement.references(item)[0]
      item.save!
    end

  end

end
