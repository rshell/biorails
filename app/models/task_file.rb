# == Schema Information
# Schema version: 233
#
# Table name: task_files
#
#  id              :integer(11)   not null, primary key
#  task_context_id :integer(11)   
#  parameter_id    :integer(11)   
#  data_uri        :string(255)   
#  is_external     :boolean(1)    
#  mime_type       :string(250)   
#  data_binary     :text          
#  lock_version    :integer(11)   default(0), not null
#  created_by      :string(32)    default(), not null
#  created_at      :datetime      not null
#  updated_by      :string(32)    default(), not null
#  updated_at      :datetime      not null
#  task_id         :integer(11)   
#  content_type    :string(255)   
#  parent_id       :integer(11)   
#  filename        :string(255)   
#  thumbnail       :string(255)   
#  size            :integer(11)   
#  width           :integer(11)   
#  height          :integer(11)   
#
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
# This TaskItem handles File and other external data sources. Basically assumes you have a URL for the 
# file and can either import it as part of the system of simply link to it as a external data source.
# 
# Main expect this to be used for raw data file and processing components like excel sheets!
# 
# WARNING: This is going away with V2.0 release moving to ProjectAsset for storage
# and TaskReference to link into model most like chaning to subtype of TaskReference
# 
class TaskFile < ActiveRecord::Base
  include TaskItem 
  validates_presence_of :task
  validates_presence_of :context
  validates_presence_of :parameter

  has_attachment :content_type => ['application/pdf', 'application/msword', 'text/plain','image'], 
                 :max_size => 5000.kilobytes,
				:storage => :file_system, 
                 :path_prefix => 'public/files',
                 :thumbnails => { :thumb => '100x100>' }

##
# The task this context belongs too
 belongs_to :task
##
# context is provides a logical grouping of TaskItems which need to be seen as a whole to get the true
# meaning of the data (eg. Inhib+Dose+Sample is useful result!)
 belongs_to :context, :class_name=>'TaskContext', :foreign_key => 'task_context_id'

##
# The parameter definition the Item is linked back to from the Process Instance
# Added IC50(Output) etc to the basic value and defines the validation rules like must be numeric!
#  
 belongs_to :parameter

 def value
    return data_uri
 end
end
