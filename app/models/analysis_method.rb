# == Schema Information
# Schema version: 359
#
# Table name: analysis_methods
#
#  id                  :integer(4)      not null, primary key
#  name                :string(128)     default(""), not null
#  description         :string(1024)    default("")
#  class_name          :string(255)     default(""), not null
#  protocol_version_id :integer(4)
#  lock_version        :integer(4)      default(0), not null
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  updated_by_user_id  :integer(4)      default(1), not null
#  created_by_user_id  :integer(4)      default(1), not null
#

# == Description
# This registers a Analysis Methods (Externally plugged in piece of code)
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class AnalysisMethod < ActiveRecord::Base

  attr_accessor :process

  validates_presence_of :name
  validates_presence_of :class_name
  validates_uniqueness_of :name, :scope=>:protocol_version_id
  #
  # List of processes this is the default analysis method for
  #
  has_many :processes, 
           :class_name=>'ProcessInstance',
           :order => :name
  #
  # List parameterized settings for the analyse method
  #
  has_many :settings,  :class_name=>'AnalysisSetting',:foreign_key =>'analysis_method_id', :dependent => :destroy, :order => 'name'

  #
  # List of register processor type 
  #
  def self.processors
    AnalysisMethod.find(:all,:conditions=>'protocol_version_id is null')
  end
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
    Analysis.register(Alces::Processor::PlotXy)
    Analysis.register(Alces::Processor::Dummy)
#    Analysis.get(self.class_name)
    Alces::Processor::Dummy
  end
  #
  # run a analysis
  #
  def run(task)
     logger.info("Run Analysis #{self.name} on #{task.name}")
     @process = processor.new(task,self)
     @process.run
#  rescue Exception =>ex
#     @process = nil
#     logger.error ex.backtrace.join("\n") 
#     logger.warn "Analysis run aborted #{ex.message}"    
#     false
  end
  #
  # Has a analysis been run
  #
  def run?
    !@process.nil?
  end
  #
  # report on status on analysis
  #
  def report
    return "" unless @process
    @process.to_html    
  rescue Exception =>ex
    logger.warn "report generation aborted #{ex.message}"    
  end
     
  def configure(options={},task=nil)    
      settings.each do |setting|
         logger.debug "#{setting.name} = #{options[setting.name]}"
         setting.update_attributes(options[setting.name])
      end
      self.save    
  end
  
  def self.setup(params  ={})
    method = params[:method]
    proc = Analysis.get(method)
    if proc
      analysis = proc.setup(params[:name]) 
      if params[:settings]
        params[:settings].keys.each do |key|
          analysis.setting(key).update_attributes(params[:settings][key])
        end
      end
      analysis.save
      return analysis
    end
  end
end
