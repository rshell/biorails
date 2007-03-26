##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class ModifyTaskFileUri < ActiveRecord::Migration

  def self.up
    change_column  :task_files, "data_uri", :string, :null => true
  end

  def self.down
    change_column  :task_files, "data_uri", :double, :null => true
  end

end
