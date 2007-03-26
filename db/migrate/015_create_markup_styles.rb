##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class CreateMarkupStyles < ActiveRecord::Migration
  def self.up
    create_table "markup_styles", :force => true do |t|
      t.column "name", :string, :default => "", :null => false
    end
  end

  def self.down
    drop_table :markup_styles
  rescue
     nil
  end
end
