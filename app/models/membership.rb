class Membership < ActiveRecord::Base
 belongs_to :user
 belongs_to :project
 belongs_to :role
 
##
# Test if this role allows this action to this subject eg.
# 
#  allows?('study','new')
 def allows?(subject,action)   
   return true
 end
 
end
