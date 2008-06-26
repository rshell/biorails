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
    Dir[File.join(RAILS_ROOT,'app','views','project','projects','*')].each do |item| 
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
    File.join(RAILS_ROOT,'app','views','project','projects',self.dashboard,name.to_s)
  end
  #
  # Get the root directory of deshboard views
  #
  def view_file(name)
    File.join('project','projects',self.dashboard,name.to_s)    
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
