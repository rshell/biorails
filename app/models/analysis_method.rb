# == Schema Information
# Schema version: 281
#
# Table name: analysis_methods
#
#  id                  :integer(11)   not null, primary key
#  name                :string(128)   default(), not null
#  description         :text          
#  class_name          :string(255)   default(), not null
#  protocol_version_id :integer(11)   
#  lock_version        :integer(11)   default(0), not null
#  created_at          :datetime      not null
#  updated_at          :datetime      not null
#  updated_by_user_id  :integer(11)   default(1), not null
#  created_by_user_id  :integer(11)   default(1), not null
#


class AnalysisMethod < ActiveRecord::Base
  cattr_accessor :processors_plugins
  attr_accessor :processor
  attr_accessor :process

  has_many :settings,  :class_name=>'AnalysisSetting',:foreign_key =>'analysis_methodt_id', :dependent => :destroy, :order => 'name'
#
# Get a setting from the current configuration
#
  def setting(name)
    settings.detect{|i|i.name == name.to_s}  
  end
#
# Get the process
#
  def processor
    @processor ||=  @@processors_plugins[self.class_name]
    @processor
  end
  
  def run(task)
     @process = processor.new(task,self)
     @process.run
  end
  
  def has_run?
    !@process.nil?
  end
 
  def report(task)
     unless @process and  @process.task == task
       self.run(task)
     end
     @process.to_html    
  end
  
  
  def self.setup(params  ={})
    AnalysisMethod.add_processor(Alces::Processor::PlotXy)
    AnalysisMethod.add_processor(Alces::Processor::Dummy)
    method = params['method'] ||  "alces/processor/dummy"
    @processor = AnalysisMethod.processor(method)
    @analysis = @processor.setup if @processor
    @analysis ||= AnalysisMethod.new
    if params['setting']
      params['setting'].keys.each do |key|
        @analysis.setting(key).update(params['setting'][key])
      end
    end
    @analysis.save
    return @analysis
  end
  
  def self.add_processor(  klass)
    @@processors_plugins ||= {}
    @@processors_plugins[klass.name] = klass
  end
  
  def self.processor(name)
    @@processors_plugins ||= {}
    return @@processors_plugins[name.to_s]
  end
  
  def self.processors
    @@processors_plugins ||= {}
    @@processors_plugins.keys
  end
end
