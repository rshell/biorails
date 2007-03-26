##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class AddCompoundIupacname < ActiveRecord::Migration
  def self.up
    add_column  :compounds, "iupacname", :string, :default => ""
  end

  def self.down
    remove_column   :compounds, "iupacname"
  end
end