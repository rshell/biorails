ActionController::Routing::Routes.draw do |map|


  map.resources :mooses
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect '', :controller => 'home', :action => 'show'
  map.connect '/', :controller => 'home', :action => 'show'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'

##
# administration elements
# 
  map.catalogue 'admin/catalogue/:action/:id', :controller => 'admin/catalogue'
  map.data_format 'admin/format/:action/:id', :controller => 'admin/data_formats'
  map.data_element 'admin/element/:action/:id', :controller => 'admin/data_elements'
  map.data_system 'admin/system/:action/:id', :controller => 'admin/data_systems'
  map.data_type  'admin/data/:action/:id', :controller => 'admin/data_types'
  map.parameter_type 'admin/parameters/:action/:id', :controller => 'admin/parameter_types'
  map.parameter_role 'admin/usage/:action/:id', :controller => 'admin/parameter_roles'
  map.assay_stage 'admin/stage/:action/:id', :controller => 'admin/assay_stages'
  map.system_setting 'admin/settings/:action/:id', :controller => 'admin/system_settings'

  map.project_type 'project_types/:action/:id', :controller => 'admin/project_types' 
  map.role 'admin/role/:action/:id', :controller => 'admin/roles'
  map.user 'admin/users/:action/:id', :controller => 'admin/users'
  map.team 'admin/teams/:action/:id', :controller => 'admin/teams'
  map.teams 'admin/teams/:action/:id', :controller => 'admin/teams'
  map.member  'admin/members/:action/:id', :controller => 'admin/memberships'

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
  map.folder  'folders/:action/:id', :controller => 'project/folders',:center=>'show'
  map.element  'element/:action/:id', :controller => 'project/folders',:center=>'layout'
  map.content 'content/:action/:id', :controller => 'project/content'
  map.asset   'asset/:action/:id', :controller => 'project/assets'
  map.signature   'signatures/:action/:id', :controller => 'project/signatures'
##
# Organization
#  
  map.assay     'assays/:action/:id',   :controller => 'organize/assays'
  map.workflow  'workflows/:action/:id',     :controller => 'organize/process_flows'
  map.process   'processes/:action/:id', :controller => 'organize/process_instances'
  map.process_instance   'processes/:action/:id', :controller => 'organize/process_instances'
  map.protocol  'protocols/:action/:id', :controller => 'organize/process_instances'
  map.parameter 'parameters/:action/:id', :controller => 'organize/assay_parameters'  
  map.assay_parameter 'parameters/:action/:id', :controller => 'organize/assay_parameters'  
  map.protocol_parameter 'protocol_parameters/:action/:id', :controller => 'organize/parameters'  
  map.assay_queue     'queues/:action/:id', :controller => 'organize/assay_queues'
  map.queue     'queues/:action/:id', :controller => 'organize/assay_queues'
  map.queue_item 'queue_items/:action/:id', :controller => 'organize/queue_items'
##
# Inventory
#  
  map.compound  'compound/:action/:id',:controller => 'inventory/compounds'  
  map.batch     'batch/:action/:id',:controller => 'inventory/batches'  
  map.plate     'plate/:action/:id',:controller => 'inventory/plates'  

##
# Execution
#
  map.experiment 'experiments/:action/:id', :controller => 'execute/experiments'
  map.task       'tasks/:action/:id',       :controller => 'execute/tasks'
  map.report     'reports/:action/:id',     :controller => 'execute/reports'
  map.request    'requests/:action/:id',    :controller => 'execute/requests'
  map.cross_tab  'sar/:action/:id',         :controller => 'execute/cross_tab'

  map.service    'services/:action/:id',    :controller => 'execute/request_services'
  map.request_service    'services/:action/:id',    :controller => 'execute/request_services'
  

##
# Public Pages
# /help/path
# /project_name/path  This will return publish / user readable rendered views of pages
# /asset/permilink    This is a content addressable file (permilink == md5 of file)
# /content/permilink  This is a content addressable html element  (permilink == md5 of record)
# 
  map.home    'home/:action/:id' , :controller => 'home'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  # Normal controller/action route.
  map.connect ':controller/:action/:id'
end
