ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  map.connect '', :controller => "home", :action => "show"
  # map.connect '', :controller => 'roles', :action => 'list'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

##
# administration elements
# 
  map.catalogue 'admin/catalogue/:action/:id', :controller => 'admin/catalogue'
  map.database  'admin/database/:action/:id', :controller => 'admin/database'
  map.data_format 'admin/format/:action/:id', :controller => 'admin/data_formats'
  map.data_element 'admin/element/:action/:id', :controller => 'admin/data_elements'
  map.data_system 'admin/system/:action/:id', :controller => 'admin/data_systems'
  map.data_type  'admin/data/:action/:id', :controller => 'admin/data_types'
  map.parameter_type 'admin/parameters/:action/:id', :controller => 'admin/parameter_types'
  map.parameter_role 'admin/usage/:action/:id', :controller => 'admin/parameter_roles'
  map.study_stage 'admin/stage/:action/:id', :controller => 'admin/study_stages'

  map.role 'admin/role/:action/:id', :controller => 'admin/roles'
  map.user 'admin/users/:action/:id', :controller => 'admin/users'
  map.auth 'auth/:action/:id' , :controller => 'auth'
  map.audit 'audit/:action/:id' , :controller => 'audit'
  map.help 'help/:action/:id' , :controller => 'help'
  map.finder 'finder/:action/:id' , :controller => 'finder'
  map.dba  'dba/:action/:id' , :controller => 'admin/database'
  map.login 'login' , :controller => 'auth',:action=>'login'
  map.logoff 'logoff' , :controller => 'auth',:action=>'logout'
##
# Main Project elements
#
  map.project 'projects/:action/:id', :controller => 'project/projects'
  map.member  'members/:action/:id', :controller => 'project/memberships'
  map.folder  'folders/:action/:id', :controller => 'project/folders',:center=>'show'
  map.element  'element/:action/:id', :controller => 'project/folders',:center=>'layout'
  map.content 'content/:action/:id', :controller => 'project/content'
  map.asset   'asset/:action/:id', :controller => 'project/assets'
##
# Studies
#  
  map.study     'studies/:action/:id', :controller => 'organize/studies'
  map.protocol  'protocols/:action/:id', :controller => 'organize/study_protocols'
  map.parameter 'parameters/:action/:id', :controller => 'organize/study_parameters'  
  map.study_parameter 'parameters/:action/:id', :controller => 'organize/study_parameters'  
  map.protocol_parameter 'protocol_parameters/:action/:id', :controller => 'organize/parameters'  
  map.study_queue     'queues/:action/:id', :controller => 'organize/study_queues'
  map.queue     'queues/:action/:id', :controller => 'organize/study_queues'
  map.queue_item 'queue_items/:action/:id', :controller => 'organize/queue_items'
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
  map.experiment 'experiments/:action/:id', :controller => 'execute/experiments'
  map.task       'tasks/:action/:id',       :controller => 'execute/tasks'
  map.report     'reports/:action/:id',     :controller => 'execute/reports'
  map.request    'requests/:action/:id',    :controller => 'execute/requests'

  map.service    'services/:action/:id',    :controller => 'execute/request_services'
  map.request_service    'services/:action/:id',    :controller => 'execute/request_services'
  
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
