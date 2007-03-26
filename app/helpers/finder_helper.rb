##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
module FinderHelper

  def close_button
   link_to_function(subject_icon("close.png"), " new Element.hide('left_panel')")
  end
  
end
