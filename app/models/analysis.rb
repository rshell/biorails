# == Description
# Base Class for external analysis
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class Analysis
  @task
  @config ={}
  
  def self.logger
    ActiveRecord::Base.logger
  end
  
  @@sync = true 
  @@processors = {}
  #
  # Get the processor class
  #
  def self.get(name)
    processors[name.to_s]    
  end
  #
  # Get the named Analysis method
  #
  def self.method(name)
    self.sync_db unless @sync
    process = get(name)
    if process
      return AnalysisMethod.find_by_name(process.name) 
    end      
    return nil
  end
  
  def self.processors
    @@processors
  end

  def self.list
    processors.keys
  end
  #
  # Create Active record records for analysis methods
  #
  def self.sync_db
    for klass in processors.values
      unless AnalysisMethod.find_by_name(klass.name)
         method = klass.setup(klass.name)
         unless method.save
           logger.warn "failed to save Analysis Class #{klass}"
         else
           logger.info "Setup Analysis #{method.name}"
         end
      end  
    end
    @sync = true
  end
  #
  # Reigster a analysis processor 
  #
  def self.register(  klass)
    if klass.respond_to?(:name) and klass.respond_to?(:description) and klass.respond_to?(:setup)
      processors[klass.to_s] = klass
      @@sync = false
    end
  end

end
