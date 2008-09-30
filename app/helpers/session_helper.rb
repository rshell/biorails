# == Session Helper
# This is used to display the main menu are the top of the screen
#
# == Copyright
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
module SessionHelper
#
# toolbar menu
#
  def toolbar_menu(title,icon,url,items=[])
<<DATA    
 {iconCls: '#{icon}',handler: function(){window.location='#{url}' },scope: this },
 {text: '#{title}', menu: { items: [#{items.join(',')}] } }
DATA
  end
#
# create breadcrumbs as a list of links styled with model based icons
#  
  def breadcrumb_list(element)
    out = ""
    element.self_and_ancestors.each do |item|
       out << "/"
       out << link_to(item.name, reference_to_url(item),:class=>'icon-#{item.class.to_s.underscore}')
   end
   content_tag(:div,out,:class=>'breadcrumb')
  end

  def menu(title,items=[])
    return "{text: '#{title}', menu: { items: [#{items.join(',')}] } }"
  end
#
# Simple menu item
#
  def menu_item(title,icon,url,enable=true)   
    if enable
      " {text: '#{title}', iconCls: '#{icon}',    href:'#{url}',scope: this }\n"
    else
      " {text: '#{title}', cls:'x-item-disabled'  ,scope: this }\n"
    end
  end  
#
# Json for home menu 
#
   def admin_menu_items
     toolbar_menu(l(:label_administration),'icon-admin',catalogue_url(),[
        menu_item(l(:label_catalogue), 'icon-catalogue' ,catalogue_url()),
        menu_item(l(:label_system_reports), 'icon-report' ,report_url(:action=>:internal) ),
        menu_item(l(:label_system_settings), 'icon-settings' ,system_setting_url() ),
        menu_item(l(:label_data_sources),'icon-data_system' ,data_system_url() ),
        menu_item(l(:label_data_types), 'icon-data_type' ,data_type_url() ),
        menu_item(l(:label_data_formats),'icon-data_format' ,data_format_url() ),
        menu_item(l(:label_project_types),'icon-project' ,project_type_url() ),
        menu_item(l(:label_assay_stages),'icon-assay_stage' ,assay_stage_url() ),
        menu_item(l(:label_states),'icon-status' ,state_url() ),
        menu_item(l(:label_parameter_types),'icon-parameter_type' ,parameter_type_url()),
        menu_item(l(:label_parameter_roles),'icon-parameter_role' ,parameter_role_url()),
        menu_item(l(:label_teams),'icon-team' ,team_url()),
        menu_item(l(:label_roles),'icon-role' ,role_url()),
        menu_item(l(:label_users),'icon-user' ,user_url())
       ])
   end   
   #
# Json for home menu 
#
   def home_menu_items
     toolbar_menu("#{l(:label_home)} [#{current_user.name}]",'icon-home',home_url(),
       [
        menu_item(l(:label_dashboard),   'icon-home' ,home_url() ),
        menu_item(l(:label_change_password),   'icon-password' ,home_url(:action=>:password)),
        menu_item(l(:label_projects), 'icon-project' ,project_url(:action=>:list)),
        change_project_menu,
        menu_item(l(:label_news),     'icon-news' ,home_url(:action=>:news)),
        menu_item(l(:label_queued_items),     'icon-queue_item'    ,home_url(:action=>:todo)),
        menu_item(l(:label_tasks),    'icon-task'    ,home_url(:action=>:tasks)),
        menu_item(l(:label_requests), 'icon-request' ,home_url(:action=>:requests)),
        menu_item(l(:label_calendar), 'icon-calendar',home_url(:action=>:calendar)),
        menu_item(l(:label_timeline), 'icon-timeline',home_url(:action=>:gantt))
     ])
   end
#
# Json for home menu 
#
   def project_menu_items
     toolbar_menu("#{current_project.project_type.name} [#{current_project.name}]",'icon-project','/projects/show',
       [
        menu_item(l(:label_dashboard), 'icon-home' ,    project_url(:action=>:show,:id=>current_project.id)),
        menu_item(l(:label_calendar),  'icon-calendar' ,calendar_url(:action=>:show,:id=>current_project.project_element_id)),
        menu_item(l(:label_timeline),  'icon-timeline' ,calendar_url(:action=>:gantt,:id=>current_project.project_element_id)),
        menu_item(l(:label_folders),   'icon-folder' ,  folder_url(:action=>:show,:id=>current_project.project_element_id)),
        menu_item(l(:label_assays),    'icon-assay' ,   assay_url(:action=>:list,:id=>current_project.id)),
        menu_item(l(:label_requests),'icon-request' ,request_url(:action=>:list,:id=>current_project.id)),
        menu_item(l(:label_experiments),'icon-experiment' ,experiment_url(:action=>:list,:id=>current_project.id)),
        menu_item(l(:label_reports), 'icon-report' ,    report_url(:action=>:list,:id=>current_project.id)),
     ])
   end
#
# Json for home menu 
#
   def design_menu_items
     toolbar_menu(l(:label_design),'icon-assay',assay_url(:action=>'list',:id=>current_project.id),
       [
        menu_item(l(:label_assays),         'icon-home'    ,assay_url(:action=>'list',:id=>current_project.id)),
        menu_item(l(:label_service_queues), 'icon-service' ,assay_queue_url(:action=>'list')),
        menu_item(l(:label_processes),     'icon-protocol' ,process_instance_url(:action=>'list')),
        menu_item(l(:label_recipes),       'icon-workflow' ,process_flow_url(:action=>'list'))
      ])
   end
#
# Json for home menu 
#
   def inventory_menu_items
     toolbar_menu(l(:label_inventory),'icon-compound','/compounds',[
        menu_item(l(:label_compounds), 'icon-compound' ,'/compounds'),
        menu_item(l(:label_batches), 'icon-batch'    ,'/batches'),
        menu_item(l(:label_plates), 'icon-plate'    ,'/plates'),
     ])
   end   

#
# Json for home menu 
#
   def change_project_menu
     menu(l(:label_project_open),
       current_user.projects(20).collect do |project|
          menu_item( project.name , "icon-project-#{project.style.downcase}"    ,project_url(:action=>'show',:id=>project.id))
       end)
   end   

   
  def toolbar_items
    if current_user.admin?
     <<DATA
     [#{home_menu_items},
      #{project_menu_items},
      #{design_menu_items},
      #{inventory_menu_items},
      #{admin_menu_items},
      {text: 'Help',menu: {items: [{text: "Help", iconCls: 'icon-help', href:'/help',   scope: this } ]}} ]
DATA
    else
     <<DATA
     [#{home_menu_items},
      #{project_menu_items},
      #{design_menu_items},
      #{inventory_menu_items},
      {text: 'Help',menu: {items: [{text: "Help", iconCls: 'icon-help', href:'/help',   scope: this } ]}} ]
DATA
    end
   end

end
