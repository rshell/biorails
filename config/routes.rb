ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  map.connect '', :controller => "home", :action => "index"
  # map.connect '', :controller => 'roles', :action => 'list'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

##
# administration elements
# 
  map.catalogue 'admin/catalogue/:action/:id', :controller => 'admin/catalogue'
  map.data_format 'admin/format/:action/:id', :controller => 'admin/data_formats'
  map.data_system 'admin/system/:action/:id', :controller => 'admin/data_systems'
  map.data_type  'admin/data/:action/:id', :controller => 'admin/data_types'
  map.parameter_type 'admin/parameters/:action/:id', :controller => 'admin/parameter_types'
  map.parameter_role 'admin/usage/:action/:id', :controller => 'admin/parameter_roles'
  map.study_stage 'admin/stage/:action/:id', :controller => 'admin/study_stages'

  map.role 'admin/role/:action/:id', :controller => 'admin/roles'
  map.user 'admin/users/:action/:id', :controller => 'admin/users'
  map.auth 'auth/:action/:id' , :controller => 'auth'
##
# Main Project elements
#
  map.project 'app/project/:action/:id', :controller => 'project/projects'
  map.section 'app/folder/:action/:id', :controller => 'project/folders'
  map.folder  'app/folder/:action/:id', :controller => 'project/folders'
  map.article 'app/doc/:action/:id', :controller => 'project/articles'
  map.asset   'app/file/:action/:id', :controller => 'project/assets'
  map.comment 'app/comment/:action/:id', :controller => 'project/comments'
##
# Studies
#  
  map.study     'app/study/:action/:id', :controller => 'study/studies'
  map.protocol  'app/protocol/:action/:id', :controller => 'study/study_protocols'
  map.parameter 'app/parameters/:action/:id', :controller => 'study/study_parameters'  
  map.study_parameter 'app/parameters/:action/:id', :controller => 'study/study_parameters'  
  map.queue     'app/queue/:action/:id', :controller => 'study/study_queues'
  map.queue_item 'app/queue_item/:action/:id', :controller => 'study/queue_items'
##
# Inventory
#  
  map.compound  'compound/:action/:id',:controller => 'inventory/compounds'  
  map.batch     'batch/:action/:id',:controller => 'inventory/batches'  
  map.sample    'sample/:action/:id',:controller => 'inventory/samples'  
  map.plate     'plate/:action/:id',:controller => 'inventory/plates'  
  map.container 'container/:action/:id',:controller => 'inventory/containers'  
  map.specimen  'specimen/:action/:id',:controller => 'inventory/specimens'  
  map.treatment_group 'treatment_group/:action/:id',:controller => 'inventory/treatment_groups'  
##
# Execution
#
  map.experiment 'app/experiment/:action/:id', :controller => 'execute/experiments'
  map.task 'app/task/:action/:id', :controller => 'execute/tasks'
  map.report 'app/report/:action/:id', :controller => 'execute/reports'
  map.request 'app/request/:action/:id', :controller => 'execute/requests'
  map.service 'app/service/:action/:id', :controller => 'execute/request_services'
  
  # Normal controller/action route.
  map.connect ':controller/:action/:id'

##
# Public Pages
# /help/path
# /project_name/path  This will return publish / user readable rendered views of pages
# /asset/permilink    This is a content addressable file (permilink == md5 of file)
# /content/permilink  This is a content addressable html element  (permilink == md5 of record)
# 
  map.home    'home/:action/:id' , :controller => 'home'
  map.connect ':*path', :controller => "page", :action => "locate"
  
end
