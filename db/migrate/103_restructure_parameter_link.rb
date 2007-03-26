##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class RestructureParameterLink < ActiveRecord::Migration

  def self.up
    add_column  :parameters, "study_parameter_id", :integer
  end

  def self.down
    remove_column  :parameters, "study_parameter_id"
  end
  
end
