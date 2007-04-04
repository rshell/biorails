# == Schema Information
# Schema version: 233
#
# Table name: project_elements
#
#  id                :integer(11)   not null, primary key
#  type              :string(20)    
#  project_id        :integer(11)   not null
#  project_folder_id :integer(11)   not null
#  position          :integer(11)   default(1)
#  reference_id      :integer(11)   not null
#  reference_type    :string(20)    
#

##
# This represents a item in a folder. This could be a reference to a textual context, 
# a model or a file asset. The content and asset links are special sub types of the
# polymophic general model reference.
# 
# 
class ProjectElement < ActiveRecord::Base
## Owner
  belongs_to :folder , :class_name =>'ProjectFolder', 
                       :foreign_key => 'project_folder_id'
##
#All references 
  belongs_to :reference, :polymorphic => true
##
# Textual content  
  belongs_to :content, :class_name =>'ProjectContent', 
                       :foreign_key => 'reference_id'
##
# File assets  
  belongs_to :asset,   :class_name =>'ProjectAsset', 
                       :foreign_key => 'reference_id'

###
# reference back to the owning project
# 
  def project
    self.folder.project if self.folder
  end   

end
