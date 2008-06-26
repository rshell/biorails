##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

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
     toolbar_menu('Administration','icon-catalogue','/admin/catalogue',[
        menu_item("Catalogue", 'icon-catalogue' ,'/admin/catalogue',current_user.allows?(:edit,:catalogue)),
        menu_item("System Reports", 'icon-report' ,'/execute/reports/internal',current_user.allows?(:edit,:dba) ),
        menu_item("System Settings", 'icon-settings' ,'/admin/system_settings/list',current_user.allows?(:edit,:dba) ),
        menu_item("Data Sources",'icon-data_system' ,'/admin/system',current_user.allows?(:edit,:dba) ),
        menu_item("Data Types", 'icon-data_type' ,'/admin/data',current_user.allows?(:edit,:dba) ),
        menu_item("Data Formats",'icon-data_format' ,'/admin/format',current_user.allows?(:edit,:catalogue) ),
        menu_item("Project Types",'icon-project' ,'/admin/project_types',current_user.allows?(:edit,:dba) ),
        menu_item("Assay Stage",'icon-assay_stage' ,'/admin/stage',current_user.allows?(:edit,:dba) ),
        menu_item("Parameter Types",'icon-parameter_type' ,'/admin/parameters',current_user.allows?(:edit,:catalogue)),
        menu_item("Parameter Roles",'icon-parameter_role' ,'/admin/usage',current_user.allows?(:edit,:catalogue)),
        menu_item("Teams",'icon-team' ,'/admin/teams',current_team.allows?(:edit,:teams)),
        menu_item("Roles",'icon-role' ,'/admin/role',current_user.allows?(:edit,:dba)),
        menu_item("Users",'icon-user' ,'/admin/users',current_user.allows?(:edit,:users))
       ])
   end   
   #
# Json for home menu 
#
   def home_menu_items
     toolbar_menu("Home [#{current_user.name}]",'icon-home','/home',[
        menu_item("Dashboard",   'icon-home' ,'/home',current_user.allows?(:show,:home)),
        change_project_menu,
        menu_item("Recent News", 'icon-news' ,'/home/news',current_user.allows?(:news,:home)),
        menu_item("Projects", 'icon-project' ,'/projects/list',current_user.allows?(:projects,:home)),
        menu_item("Todo",     'icon-todo'    ,'/home/todo',current_user.allows?(:todo,:home)),
        menu_item("Tasks",    'icon-task'    ,'/home/tasks',current_user.allows?(:tasks,:home)),
        menu_item("Requests", 'icon-request' ,'/home/requests',current_user.allows?(:requests,:home)),
        menu_item("Calendar", 'icon-calendar','/home/calendar',current_user.allows?(:calendar,:home)),
        menu_item("Timeline", 'icon-timeline','/home/gantt',current_user.allows?(:calendar,:home))
     ])
   end
#
# Json for home menu 
#
   def project_menu_items
     toolbar_menu("#{current_project.project_type.name} [#{current_project.name}]",'icon-project','/projects/show',[
        menu_item("Dashboard", 'icon-home' ,'/projects/show',current_project.allows?(:show,:project)),
        menu_item("Calendar",  'icon-calendar' ,'/projects/calendar',current_project.allows?(:calendar,:project)),
        menu_item("Timeline",  'icon-timeline' ,'/projects/gantt',current_project.allows?(:calendar,:project)),
        menu_item("Folders",   'icon-folder' ,'/folders',current_project.allows?(:show,:project)),
        menu_item("Assay Definitions", 'icon-assay' ,'/assays',current_project.allows?(:show,:assays)),
        menu_item("Experiments",  'icon-experiment' ,'/experiments',current_project.allows?(:show,:experiments)),
        menu_item("Queries",          'icon-report' ,'/reports',current_project.allows?(:show,:reports)),
        menu_item("Signed Documents",   'icon-sign' ,'/signatures/list',current_project.allows?(:show,:project)),
     ])
   end
#
# Json for home menu 
#
   def design_menu_items
     toolbar_menu('Design','icon-assay','assays',[
        menu_item("Assays",    'icon-home' ,'/assays',current_project.allows?(:show,:assays)),
        menu_item("Services",  'icon-service' ,'/queues',current_project.allows?(:show,:assay_queues)),
        menu_item("Processes", 'icon-protocol' ,'/processes',current_project.allows?(:show,:assay_protocols)),
        menu_item("Recipes", 'icon-workflow' ,'/workflows',current_project.allows?(:show,:assay_protocols))
      ])
   end
#
# Json for home menu 
#
   def inventory_menu_items
     toolbar_menu('Inventory','icon-compound','/inventory/compounds',[
        menu_item("Compounds", 'icon-compound' ,'/inventory/compounds',current_user.allows?(:show,:inventory)),
        menu_item("Batches"  , 'icon-batch'    ,'/inventory/batches',current_user.allows?(:show,:inventory)),
        menu_item("Plates"  , 'icon-batch'    ,'/inventory/plates',current_user.allows?(:show,:inventory)),
     ])
   end   

#
# Json for home menu 
#
   def change_project_menu
     menu('Open Project',
       current_user.projects.collect do |project|
          menu_item( "#{project.name} [#{project.project_type.name}]"  , 'icon-project'    ,project_url(:action=>'show',:id=>project.id))
       end)
   end   

   
  def toolbar_items
    if current_user.allows?(:edit,:catalogue)
     <<DATA
     [#{home_menu_items},
      #{project_menu_items},#{design_menu_items},
      #{inventory_menu_items},#{admin_menu_items},
      {text: 'Help',menu: {items: [{text: "Help", iconCls: 'icon-help', href:'/help',   scope: this } ]}} ]
DATA
    else
     <<DATA
     [#{home_menu_items},
      #{project_menu_items},#{design_menu_items},
      #{inventory_menu_items},
      {text: 'Help',menu: {items: [{text: "Help", iconCls: 'icon-help', href:'/help',   scope: this } ]}} ]
DATA
    end
   end
##
# Convert a type/id reference into a url to the correct controlelr
#    
  def link_to_object( element, link_name=nil ,options = {:action=>'show'})
    name = link_name
    name ||= element.name if element.respond_to?(:name)
    if element
      case  element
      when ProjectAsset then    link_to name , asset_url( options.merge({ :id=>element.id ,:folder_id=>element.parent_id}) )
      when ProjectContent then  link_to name , content_url( options.merge({ :id=>element.id ,:folder_id=>element.parent_id}) )
      when ProjectElement then  link_to name , folder_url( options.merge({ :id=>element.id ,:folder_id=>element.parent_id}) )
      when QueueItem then       link_to element.data_name, queue_item_url( options.merge({ :id=> element.id}) )
      when ProtocolVersion then link_to name , protocol_url(   options.merge({ :id=> element.protocol.id}) )
      when RequestService then  link_to name , request_service_url(options.merge({:id=>element.request.id}) )
      else
          link_to_model(element.class,element.id,name,options)
      end
    end
  end   

##
# Convert a type/id reference into a url to the correct controlelr
#    
  def link_to_model( model,id, link_name=nil ,options = {:action=>'show'})
    name = link_name || model.to_s 
    if model and id
      case  model.to_s.camelcase
      when 'Project' then        link_to  name, project_url( options.merge({ :id=>id} ) )
      when 'ProjectElement' then  link_to  name, folder_url( options.merge({ :id=>id} ) )
      when 'ProjectFolder'then   link_to  name, folder_url( options.merge({ :id=>id} ) )
      
      when 'Assay' then          link_to name , assay_url(      options.merge({ :id=>id}) )
      when 'AssayProtocol' then   link_to name , protocol_url(   options.merge({ :id=>id})  )
      when 'AssayQueue'then      link_to name , queue_url(      options.merge({ :id=>id})  )
      when 'QueueItem' then       link_to name , queue_item_url( options.merge({ :id=> id}) )
      when 'AssayParameter' then link_to name , assay_parameter_url( options.merge({:id=>id}) )
  
      when 'Experiment' then      link_to name , experiment_url(   options.merge({:id=>id})  )
      when 'Task' then            link_to name , task_url(         options.merge({:id=>id})  )
      when 'Report' then          link_to name , report_url(       options.merge({:id=>id})  )
      when 'Request' then         link_to name , request_url(      options.merge({:id=>id})  )
      when 'RequestService' then  link_to name , request_service_url(options.merge({:id=>id}) )

      when 'Compound' then        link_to name , compound_url(       options.merge({:id=>id})  )
      when 'Batch' then           link_to name , batch_url(          options.merge({:id=>id})  )
      when 'Plate' then           link_to name , plate_url(          options.merge({:id=>id}) )
      when 'Container' then       link_to name , container_url(      options.merge({:id=>id})  )
      when 'Specimen' then        link_to name , specimen_url(       options.merge({:id=>id})  )
      when 'TreatmentGroup'then  link_to name , treatment_group_url(options.merge({:id=>id})  )
      else
         name
      end
    end
  end   

end

