##
# This is the basic unit of context of a project
#  * Article
#  * Comment
#  * Event
# 
# 
class Content < ActiveRecord::Base
  filtered_column :body, :excerpt
  belongs_to :user, :with_deleted => true
  belongs_to :project
  [:year, :month, :day].each { |m| delegate m, :to => :published_at }
end