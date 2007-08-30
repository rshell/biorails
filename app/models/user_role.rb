
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 



class UserRole < Role

  def self.subjects
    Permission.subjects(:current_user)
  end

end
