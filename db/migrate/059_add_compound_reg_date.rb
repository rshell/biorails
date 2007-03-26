##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddCompoundRegDate < ActiveRecord::Migration
  def self.up
    add_column  :compounds, "registration_date", :datetime
  end

  def self.down
    remove_column   :compounds, "registration_date"
  end
end
