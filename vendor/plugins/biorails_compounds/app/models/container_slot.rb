
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class ContainerSlot < ActiveRecord::Base

 belongs_to :container_type

 def label
   "#{self.level_name}#{self.column_name}#{self.row_name}"
 end

end
