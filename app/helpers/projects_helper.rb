##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
module ProjectsHelper

   def study_director_name
     return "[none]" unless ProjectSetting.study_director
     item = User.find(ProjectSetting.study_director)
     item.name
   rescue Exception => ex
     logger.warn "error #{ex.message}"
     return "[na]"
   end

   def study_director?
     (study_director_name == current_user.name)
   end
   
   def default_witness_name
     return "[none]" unless ProjectSetting.default_witness
     item = User.find(ProjectSetting.default_witness)
     item.name
   rescue Exception => ex
     logger.warn "error #{ex.message}"
     return "[na]"
   end
   #
   # Custom field for project settings
   # * name of settings
   # * options type of control :date,:element,:lookup
   #
   def project_settings_field(name,options)
    if options[:element]
        select_data_element_tag( "setting_#{name}" ,options[:element], ProjectSetting[name])
    elsif options[:lookup]
       select_named_tag( "setting_#{name}" ,options[:lookup], ProjectSetting[name])
    elsif options[:date] 
       my_date_field("setting_#{name}" , "setting_#{name}",  Chronic.parse(ProjectSetting[name]))
    else
       text_field_tag("setting_#{name}" ,  ProjectSetting[name])
    end
   end

   def select_study_director
    if @project.new_record?
       select_named_tag( "setting_study_director" ,User, current_user.id)
    else  
       select_named_tag( "setting_study_director" ,User, ProjectSetting['study_director'])
    end       
   end

   def select_default_witness_name
      users = current_project.folder.access_control_list.users(:document,:witness)
      options = options_for_select(users, ProjectSetting.default_witness.to_i)
      select_tag( :setting_default_witness,options)
   rescue Exception => ex
     logger.warn "error #{ex.message}"
     return "[Failed to find witness]"
   end

   def default_witness?
     (ProjectSetting.default_witness == current_user.id)
   end

   def study_sponsor
     return "[none]" unless ProjectSetting.study_sponsor
     ProjectSetting.study_sponsor
   rescue Exception => ex
     logger.warn "error #{ex.message}"
     return "[na]"
   end

   def discovery_project_name
     return "[none]" if ProjectSetting.discovery_project.blank?
     item = Project.find(ProjectSetting.discovery_project)
     item.name
   rescue Exception => ex
     logger.warn "error #{ex.message}"
     return "[na]"
   end

   def new_project_url(dashboard=nil,parent=nil)
     type = nil
     case dashboard
     when Fixnum then type = ProjectType.find(dashboard)
     when ProjectType then type = dashboard
     when String then type = ProjectType.find_by_dashboard(dashboard)
     end
     type ||= ProjectType.find(:first)
     if parent.nil?
        project_url(:action=>:new,:project_type_id=>type.id)
     else
        project_url(:action=>:new,:project_type_id=>type.id,:id=>parent.id)
     end

   rescue Exception => ex
     logger.warn "error #{ex.message}"
     project_url(:action=>:new)
   end

   def study?
     (current_project.project_type.study? )
   end
   
end
