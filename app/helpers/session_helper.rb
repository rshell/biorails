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
  def breadcrumb_list(element, enabled=true)
    return "[No Folder]" unless element
    if enabled
      out = "[#{link_to element.state, folder_url(:action=>:status,:id=>element.id)}] &nbsp;"
    else
      out = "&nbsp;"
    end
    element.self_and_ancestors.each do |item|
      out << "/"
      if item.reference
        out << content_tag(:b,link_to(item.name, reference_to_url(item),:class=>'icon-#{item.class.to_s.underscore}'))
      else
        out << content_tag(:i,link_to(item.name, reference_to_url(item),:class=>'icon-#{item.class.to_s.underscore}'))
      end
    end
    content_tag(:div,out,:class=>'breadcrumb')
  end

  def breadcrumb_list_no_status (element)
    return "<No Folder>" unless element
    out = "&nbsp;"
    element.self_and_ancestors.each do |item|
      out << "/"
      if item.reference
        out << content_tag(:b,link_to(item.name, reference_to_url(item),:class=>'icon-#{item.class.to_s.underscore}'))
      else
        out << content_tag(:i,link_to(item.name, reference_to_url(item),:class=>'icon-#{item.class.to_s.underscore}'))
      end
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
    items = []
    if right?(:catalogue,:admin)
      items <<  menu_item(l(:Catalogue), 'icon-catalogue' ,catalogue_url())
      items << '"-"'
      items <<  menu_item(l(:Data_Formats),'icon-data_format' ,data_format_url() )
      items <<  menu_item(l(:Parameter_Types),'icon-parameter_type' ,parameter_type_url())
      items <<  menu_item(l(:Parameter_Roles),'icon-parameter_role' ,parameter_role_url())
      items << '"-"'
      items <<  menu_item(l(:States),'icon-status' ,state_url() )
      items <<  menu_item(l(:Assay_Stages),'icon-assay_stage' ,assay_stage_url() )
    end

    if right?(:system,:admin)
      items << '"-"'
      items << menu_item(l(:System_Reports), 'icon-report' ,system_report_url())
      items << menu_item(l(:System_Settings), 'icon-settings' ,system_setting_url() )
      items << menu_item(l(:Data_Identifiers), 'icon-settings' ,data_identifier_url() )
      items << menu_item(l(:Data_Sources),'icon-data_system' ,data_system_url() )
      items << menu_item(l(:Data_Types), 'icon-data_type' ,data_type_url() )
      items << menu_item(l(:Project_Types),'icon-project' ,project_type_url() )
      items << '"-"'
      items << menu_item(l(:Roles),'icon-role' ,role_url())
      items << menu_item(l(:Users),'icon-user' ,user_url())
    end

    toolbar_menu(l(:Administration),'icon-admin',catalogue_url(),items)
  end
  #
  # Json for home menu
  #
  def home_menu_items
    toolbar_menu("#{l(:Home)} [#{current_user.name}]",'icon-home',home_url(),
      [
        menu_item(l(:Dashboard)       , 'icon-home'       , home_url() ),
        menu_item(l(:Change_Password) , 'icon-password'   , home_url(:action=>:password)),
        menu_item(l(:Projects)        , 'icon-project'    , home_url(:action=>:domains)),
        menu_item(l(:News)            , 'icon-news'       , home_url(:action=>:news)),
        menu_item(l(:Queued_Items)    , 'icon-queue_item' , home_url(:action=>:todo)),
        menu_item(l(:Tasks)           , 'icon-task'       , home_url(:action=>:tasks)),
        menu_item(l(:Requests)        , 'icon-request'    , home_url(:action=>:requests)),
        menu_item(l(:Calendar)        , 'icon-calendar'   , home_url(:action=>:calendar)),
        menu_item(l(:Teams)           , 'icon-team'       , team_url()),
        menu_item(l(:Approved_Documents), 'icon-sign'     , home_url(:action=>:approved_documents)),
      ])
  end
  #
  # Json for home menu
  #
  def project_menu_items
    toolbar_menu("#{current_project.project_type.name} [#{current_project.name}]",'icon-project','/projects/show',
      [
        menu_item(l(:Dashboard)       , 'icon-home'       , project_url(:action=>:show,:id=>current_project.id)),
        menu_item(l(:Calendar)        , 'icon-calendar'   , calendar_url(:action=>:show,:id=>current_project.project_element_id)),
        menu_item(l(:Folders)         , 'icon-folder'     , folder_url(:action=>:show,:id=>current_project.project_element_id)),
        menu_item(l(:Assays)          , 'icon-assay'      , assay_url(:action=>:list,:id=>current_project.id)),
        menu_item(l(:Requests)        , 'icon-request'    , request_url(:action=>:list,:id=>current_project.id)),
        menu_item(l(:Experiments)     , 'icon-experiment' , experiment_url(:action=>:list,:id=>current_project.id)),
        menu_item(l(:Tasks)           , 'icon-task'       , task_url(:action=>:list,:id=>current_project.id)),
        menu_item(l(:Reports)         , 'icon-report'     , report_url(:action=>:list,:id=>current_project.id)),
        menu_item(l(:Cross_Tabs)      , 'icon-crosstab'   , cross_tab_url(:action=>:list,:id=>current_project.id))
      ])
  end
  #
  # Json for home menu
  #
  def design_menu_items
    toolbar_menu(l(:Organisation),'icon-assay',assay_url(:action=>'list',:id=>current_project.id),
      [
        menu_item(l(:Assays),         'icon-home'    ,assay_url(:action=>'list',:id=>current_project.id)),
        menu_item(l(:Service_Queues), 'icon-service' ,assay_queue_url(:action=>'list',:id=>nil)),
        menu_item(l(:Processes),     'icon-protocol' ,process_instance_url(:action=>'list',:id=>nil)),
        menu_item(l(:Recipes),       'icon-workflow' ,process_flow_url(:action=>'list',:id=>nil))
      ])
  end
  #
  # Json for home menu
  #
  def inventory_menu_items
    toolbar_menu(l(:Inventory),'icon-compound'    ,'/compounds',[
        menu_item(l(:Compounds), 'icon-compound'  ,'/compounds'),
        menu_item(l(:Batches), 'icon-batch'       ,'/batches'),
        menu_item(l(:Container), 'icon-plate'     ,'/containers'),
        menu_item(l(:Container_Type), 'icon-plate','/container_types'),
      ])
  end

  def toolbar_items
    if right?(:catalogue,:admin)
      <<DATA
     [#{home_menu_items},
      #{project_menu_items},
      #{design_menu_items},
      #{inventory_menu_items},
      #{admin_menu_items},
      {text: 'Help',menu: {items: [{text: "Help", iconCls: 'icon-help', href:'/help',   scope: this } ]}},'->'
      ]
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
