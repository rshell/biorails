##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddStudyIndexes < ActiveRecord::Migration
  def self.up
    add_index "studies", ["name"]
    add_index "studies", ["updated_by"]
    add_index "studies", ["updated_at"]
  end

  def self.down
    remove_index "studies", ["name"]
    remove_index "studies", ["updated_by"]
    remove_index "studies", ["updated_at"]
  end
end
