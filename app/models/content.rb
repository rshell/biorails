##
# This is the basic unit of context of a project
#  * Article
#  * Comment
#  * Event
# 
class Content < ActiveRecord::Base   
  belongs_to :user
  belongs_to :project    
end