# == Schema Information
# Schema version: 123
#
# Table name: containers
#
#  id              :integer(11)   not null, primary key
#  name            :string(128)   default(), not null
#  description     :text          
#  plate_format_id :integer(11)   
#  lock_version    :integer(11)   default(0), not null
#  created_by      :string(32)    default(), not null
#  created_at      :datetime      not null
#  updated_by      :string(32)    default(), not null
#  updated_at      :datetime      not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Container < ActiveRecord::Base
  included Named
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  
  belongs_to :plate_format
 
  has_many :items, :order => 'slot_no asc'

##
# get a plate layout for the container
#   
  def layout
    if self.plate_format
      return Layout.new(self)
    end
  end

##
# Get a list of all the items in the container  
# 
  def list
    return self.items.collect{|i|i.subject}
  end
##
# get a specific subject from the container
#  
  def subject(id)
    return self.items[id]
  end
  
end

##
# This is a simple to use 2D structure help with plate type containers
#
class Layout 
  attr_accessor :wells
  
  def initialize(container)
     @wells = [][]
     for well in container.plate_format.wells
        @wells[well.row_no][well.column_no] = [well,container.subject(well.slot_no)]
     end
  end
  
  def contains(row,col)
    return @wells[row][col][1]
  end
  
  def well(row,col)
    return @wells[row][col]
  end

  def format(row,col)
    return @wells[row][col][0]
  end

end

