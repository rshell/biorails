##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreateStudyParameters < ActiveRecord::Migration
  def self.up
    create_table :study_parameters do |t|
    t.column "parameter_type_id", :integer
    t.column "parameter_role_id", :integer
  end
  end

  def self.down
    drop_table :study_parameters
  end
end
