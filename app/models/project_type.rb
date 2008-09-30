# == Schema Information
# Schema version: 359
#
# Table name: project_types
#
#  id                 :integer(4)      not null, primary key
#  name               :string(30)      not null
#  description        :string(255)     not null
#  dashboard          :string(255)     not null
#  publish_to_team_id :integer(4)      default(1), not null
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  created_by_user_id :integer(4)      default(1), not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#

# == Description
# This replements a type of project with a set dashboard governing the UI
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class ProjectType < ActiveRecord::Base
  
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :dashboard

  has_many :projects

  def path
    return self.name
  end
  #
  # List of suitable dashboard directories
  # Heeds basic show 
  #
  def self.dashboard_list
    list =[]
    Dir[File.join(RAILS_ROOT,'app','views','projects','*')].each do |item| 
      if File.directory?(item)
         dir = Dir.open(item)
         if dir.entries.include?("show.rhtml") &&
            dir.entries.include?("_actions.rhtml") &&
            dir.entries.include?("_show.rhtml") &&
            dir.entries.include?("_status.rhtml") &&
            dir.entries.include?("_help.rhtml")
           list << File.split(item).last
         end
      end
    end  
    return list    
  end
  #
  # Full directory for the deskboard
  #
  def full_file_path(name)
    File.join(RAILS_ROOT,'app','views','projects',self.dashboard,name.to_s)
  end
  #
  # Get the root directory of deshboard views
  #
  def view_file(name)
    File.join('projects',self.dashboard,name.to_s)    
  end
  
#
# Get the current dashboard style to use with this project
#
  def partial_template(name)
    filename = view_file(name.to_s)
    if File.exist?(full_file_path("_#{name}.rhtml"))
      filename  
    else
      name.to_s
    end      
  end
#
# Get the current dashboard style to use with this project
#
  def action_template(name)
    filename = view_file(name.to_s)
    if File.exist?(full_file_path("#{name}.rhtml"))
      filename  
    else
      name.to_s
    end      
  end

end
