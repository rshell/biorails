Ext.BLANK_IMAGE_URL = '/images/s.gif';
Ext.ux.grid.filter.StringFilter.prototype.icon = 'img/find.png';
Ext.ux.menu.RangeMenu.prototype.icons = {
          gt: '/images/greater_then.png', 
          lt: '/images/less_then.png',
          eq: '/images/equals.png'
};

Ext.namespace("Biorails", "Biorails.Report",  "Biorails.GridPanel",  "Biorails.FolderPanel",  "Biorails.TreePanel");	
//
// Main biorails client application code.
// Licence GNU 2.0 see biorails.org project site for details
//
Biorails = function(){
//
// Internal State of the Client Application
//    
   var _instance = null;
   var _version = '0.1';
   var _model = 'Compound';
   var _controller = 'compounds';
   var _columns = [];
   var _fields = [];
   var _filters = [];
   
   var _folder_tree =null;
   var _folder_root =null;
  
   var _toolbar = null;
   var _base_url = null;
   var _viewport = null;
/*
 * Read the configuration
 */   
   var ReadConfig = function(config){ 
         _columns = config.columns;
         _fields = config.fields;
         _model = config.model;
         _controller = config.controller;           
         _filters = {paramPrefix: 'where',filters: config.filters};           
    };

  var searchField = new Ext.form.TextField({
                    fieldLabel: 'search',
                    name: 'first',
                    width:175,
                    allowBlank:false});

//
// Manage Free Text Search Click
//					
  function onSearchClick(btn){
		layout.getRegion('east').showPanel('status');   
		Ext.get("status").load({
		        url: "/finder/search?text="+searchField.getValue(),
		        text: "Searching..."
		   });
   };	   

//
// Chick on a Menu
//		
  function clickMenu(e) {
  	 this.base_url = e.url;
     new Ajax.Request(e.url,{
            method: 'get',
			evalScripts: true
        });
    };

// 
// Private Rendering functions for the Grid
//    
    function renderIcon(val){
        return '<img src="' + val + '" />';
    };

    function renderIndex(val,cell,record,row,col,ds){
        return row;
    };


    
//------------------ Main Layout ------------------------------------------------------------------------
// West: Navigation with project tree and actions for current controller
// East: Extras with help, work brench and current status messages
// North: Simple toolbar
// South: Audting and history information
// Centre: Main tab + accessaries tabs for grids etc.
//
// West
   var _tree_panel = new Ext.tree.TreePanel({
			el:'tree-panel',
            title:'Folder Tree',
			autoScroll:true,
            autoShow: true,            
			animate:true,
			enableDD:true,
			containerScroll: true,
            iconCls:'nav', 
			loader: new Ext.tree.TreeLoader({ dataUrl:'/home/tree'	})
		});
    _tree_panel.setRootNode( new Ext.tree.AsyncTreeNode({   text: 'Projects',  draggable:false, id: 'root' }) );
    
   var _actions_panel = new Ext.Panel({
		            title:'Menu Actions',
		            contentEl: 'actions-panel',
		            border:false,
          		    autoDestroy: true,  
                    autoScroll: true,
		            iconCls:'settings'
		        } );
// East                        
   var _work_panel = new Ext.Panel({
					xtype:"panel",
					autoDestroy: true,  
					autoScroll: true,
					contentEl: 'work-tab',
					id: 'work-id',
					title:"Work"
				  }  );
   
   var _status_panel = new Ext.Panel({
					xtype:"panel",
					contentEl: 'status-tab',
					autoDestroy: true,  
					autoScroll: true,
					id: 'status-id',
					title:"Status"
				  } );

                        
   var _help_panel = new Ext.Panel({
					xtype:"panel",
					autoDestroy: true,  
					autoScroll: true,
					id: 'help-id',
					contentEl:'help-tab',
					title:"Help"
				  });
// South                                  
   var _footer_panel = new Ext.Panel({
					contentEl:'footer-panel',
					border:false,
					autoDestroy: true,  
					autoScroll: true,
					iconCls:'nav'
				});
// center
   var _main_panel = new Ext.Panel({
					title: 'Main',
					id: 'main-id',
                    xtype:"panel", 
                    layout: 'fit',
					autoScroll:true, 
					contentEl:'center-panel',
					autoDestroy: true,  
                    autoShow: true,
                    frame: false
			       });
                               
   var _center_panel = new Ext.TabPanel( {
					region:"center",
					border: false,
                	xtype:"tabpanel",
					border: true,
					id:'center-id',
					border:false,
					activeTab:0,
					tabPosition: 'top',
					 items: [ _main_panel ]
				   } );
 

// 
// Default Toolbar
// 
   var _toolbar =  new Ext.Toolbar({
		 items: [{text: 'Home',menu: { items: [
								{text: "Dashboard",    url:'/home',handler: clickMenu ,scope: this },
								'-',
								{text: "Recent",       url:'/home/news',handler: clickMenu ,scope: this },
								{text: "Projects",     url:'/home/projects',handler: clickMenu ,scope: this },
								{text: "Todo",         url:'/home/todo',handler: clickMenu ,scope: this  },
								{text: "Tasks",        url:'/home/tasks',handler: clickMenu ,scope: this  },
								{text: "Requests",     url:'/home/requests',handler: clickMenu ,scope: this  }
							]}},
				 {text: 'Project',menu : {items: [
								{text: "Dashboard",    url:'/projects/show',handler: clickMenu ,scope: this },
								'-',
								{text: "Calender",     url:'/projects/calendar',handler: clickMenu ,  scope: this },
								{text: 'Timeline',     url:'/projects/gantt',handler: clickMenu,  scope: this },
								{text: 'Folders',      url:'/folders',handler: clickMenu,  scope: this },
								{text: 'Study Designs',url:'/studies',handler: clickMenu,  scope: this },
								{text: 'Experiments',  url:'/experiments',handler: clickMenu,  scope: this },
								{text: "Reports",      url:'/reports',handler: clickMenu, scope: this }
							]}},
				 {text: 'Design',menu : {items: [
								{text: "Studies",     url:'/studies',handler: clickMenu ,  scope: this },
								{text: "Services",    url:'/queues',handler: clickMenu ,scope: this },
								{text: "Protocols",   url:'/protocols',handler: clickMenu , scope: this }
							]}},' ',
				 {text: 'Inventory',menu : {items: [
								{text: "Molecules",   url:'/molecules',handler: clickMenu ,  scope: this },
								{text: "Compounds",   url:'/compounds',handler: clickMenu ,  scope: this },
								{text: "Batches",     url:'/batches',handler: clickMenu ,  scope: this },
								{text: "Mixtures",    url:'/mixtures',handler: clickMenu ,  scope: this },
								{text: "Samples",     url:'/samples',handler: clickMenu ,  scope: this },
								{text: "Containers",  url:'/containers',handler: clickMenu ,  scope: this }
							]}},' ',
				 {text: 'Administration',menu : {items: [
								{text: "Catalogue",   url:'/admin/catalogue',handler: clickMenu , scope: this },
								'-',
								{text: "Data Sources",url:'/admin/system',handler: clickMenu ,   scope: this },
								{text: "Data Types",  url:'/admin/data',handler: clickMenu ,   scope: this },
								{text: "Data Lookups",  url:'/admin/element',handler: clickMenu ,   scope: this },
								{text: "Data Formats",  url:'/admin/format',handler: clickMenu ,   scope: this },
								'-',
								{text: "Study Stage", url:'/admin/stage',handler: clickMenu ,   scope: this },
								{text: "Parameter types", url:'/admin/parameters',handler: clickMenu ,   scope: this },
								{text: "Parameter Roles", url:'/admin/usage',handler: clickMenu ,   scope: this },
								'-',
								{text: "Roles", url:'/admin/role',handler: clickMenu ,   scope: this },
								{text: "Users", url:'/admin/user',handler: clickMenu ,   scope: this },
								{text: "Audit Log", url:'/audit',handler: clickMenu ,   scope: this }
							]}},
				 {text: 'Help',menu : {items: [
								{text: "Help",  scope: this }			            
							]}},
				  '->',
				  searchField,
				  {text: 'search',handler: onSearchClick},							
				  {text: 'logout', href:'/logoff'}							
				]});

   var _layout = {
		layout:"border",
	    autoHeight: true,
 	   	autoWidth : true,
		autoScroll: true,
		items:[{
			 region:"north",
			 height: 32,
             autoShow: true,            
			 el: 'toolbar-panel',
			 tbar: _toolbar	   		
			  },{
			    region:"south",
			    title:"History",
			    id:'footer-id',	
			    height:75,
			    split:true,
			    splitTip: "Mesages and Audit information",
			    useSplitTips: true,
			    collapsible:true,
			    titleCollapse:true,
			    floatable: true,
		            items: [ _footer_panel ]
			 },{
			    region:"west",
			    title:"Navigation",
			    id:'nav-id',	
			    split:true,
			    collapsible:true,
			    useSplitTips: true,
			    titleCollapse:true,
		        width: 250,
		        minSize: 175,
		        maxSize: 400,
		        layout:'accordion',
		        layoutConfig:{
		            animate:true
		        },
		        items: [ _actions_panel, _tree_panel]
			  },{
			    region:"east",
			    title:"Extras",
			    id:'extra-id',	
			    width: 225,
				minSize: 175,
                maxSize: 400,
			    split:true,
			    useSplitTips: true,
			    collapsible:true,
			    titleCollapse:true,
			    items: [{
			        xtype:"tabpanel",
			        activeTab:0,
				    tabPosition: 'top',
			        items:[ _status_panel, _help_panel, _work_panel  ]
                               
			      }]
			  },_center_panel
			  ]
		};
//------------------Public Methods ------------------------------------------------------------------------
  
   return {      
/*
 * Get the current client code version
 * @return {float} version
 */                    
      version : function(){ 
            return _version;
        },
/*
 * Get the model in the current context
 * @return {string} model
 */                    
      model : function(){ 
            return _model;
        },
/*
 * Get the controller in the current context
 * @return {array} controller
 */                    
      controller : function(){ 
            return _controller;
        },
/*
 * Get the List of columns in the current context
 * @return {array} columns
 */                    
      getColumns : function(){ 
            return _columns;
        },
/*
 * Get the List of fields in the current context
 * @return {array} fields
 */                    
      getFields : function(){ 
            return _fields;
        },
 /*
  * Set the current Context for the client in terms of model/controller
  */       
      setContext : function(config){
          ReadConfig(config);
      },
        
/*
 * Get the List of fields in the current context
 * @return {array} fields
 */                    
      getColumnView : function(){ 
            return new Ext.grid.ColumnModel(_columns);
        },
/*
 * Get the current model data store
 * @return {Ext.data.GroupingStore} the data store
 */
      getModelStore : function(){ 
            return new Ext.data.GroupingStore({
                   remoteSort: true,
                   lastOptions: {params:{start: 0, limit: 25}},
                   sortInfo: {field: 'id', direction: 'ASC'},
                   proxy: new Ext.data.HttpProxy({ url: '/ext/'+_controller, method: 'get' }),
                   reader: new Ext.data.JsonReader({
                                   root: 'items', totalProperty: 'total'}, _fields  )
                    })},
/*
 * Get the current folder data store
 * @return {Ext.data.GroupingStore} the data store
 */
      getFolderStore : function(folder_id){ 
            return new Ext.data.GroupingStore({
                   remoteSort: true,
                   lastOptions: {params:{start: 0, limit: 25}},
                   sortInfo: {field: 'id', direction: 'ASC'},
                   proxy: new Ext.data.HttpProxy({ url: '/folders/grid/'+folder_id, method: 'get' }),
                   reader: new Ext.data.JsonReader({
                     root: 'items', totalProperty: 'total'}, [
						   {name: 'id', type: 'int'},
						   {name: 'icon'},
						   {name: 'name'},
						   {name: 'summary'},
						   {name: 'reference_type'},
						   {name: 'updated_by'},
						   {name: 'updated_at', type: 'date', dateFormat: 'Y-m-d H:i:s'},
						   {name: 'actions'}]  )
                    })},
/*
 * Setup the Project tree on the navigation panel
 */        
      projectTree : function(config){

      var tree = new Ext.tree.TreePanel('project-tree', {
                                      animate:true,
                                      enableDD:false,
                                      loader: new Ext.tree.TreeLoader(), 
                                      lines: true,
                                      selModel: new Ext.tree.MultiSelectionModel(),
                                      containerScroll: false });

      var root = new Ext.tree.AsyncTreeNode(config);
      tree.setRootNode(root);
      tree.render();
      root.expand()
        },  
/*
 * Add a new Tab to the central panel
 * @param {hash} configuration
 * @return {Ext.Panel} Panel added
 */      
	  add_tab: function(config) {
	  	  if (config.id) {
			  tab = Ext.ComponentMgr.get('#{config.id}');
			  if (tab) {
			     tab.body.update(config.html);
			     panel.activate('#{id}');
			  } else {
			    panel.add( new Ext.Panel({
			          title: '#{id}', 
			          id: '#{id}',
			          html: content, 
			          autoDestroy: true,  
			          autoScroll: true,
			          closable:true,
			          html: content })
			    );  
			   panel.activate('#{id}');
			  }
		  };
	  },
/*
 * Get the grid_id
 */          
      grid_id: function(){ 
	  	return  _controller+'-grid' 
	  },
/*
 * Get a new grid Panel to the current config
 */          
      grid: function(){
         _store =  this.getModelStore();
         _grid = new Ext.grid.GridPanel({
                                 border:false,
                                 autoscroll: true,
						         autoDestroy: true,  
						         closable:true,
                                 title: this.model()+' List',
                                 id: this.grid_id(),
                                 ds:  _store,
                                 cm: this.getColumnView(),
                                 view: new Ext.grid.GroupingView(),
                                 viewConfig: {forceFit:true},
                                 plugins: new Ext.ux.grid.GridFilters( _filters ),
 		                 bbar: new Ext.PagingToolbar({
				            pageSize: 25,
				            store: _store,
				            displayInfo: true,
				            displayMsg: 'Displaying {0} - {1} of {2}',
				            emptyMsg: "No results to display"
				        })
                                });    
          _store.load({params:{start: 0, limit: 25}});
         return _grid;                        
      },      
/*
 * show a datagrid to the passed current config
 *
 * @param config of the model grid
 *
 */      
      showGrid: function(config) {
          ReadConfig(config);
          
          if (_center_panel){
                tab = Ext.ComponentMgr.get(this.grid_id());
                if (tab) {
                   _center_panel.remove(tab);
                };
			    _center_panel.add( this.grid() );                
                _center_panel.doLayout();
          }  
      },
      
/*
 * Get a new grid Panel to the current config
 *
 * @param id {int} Identifier to the folder
 * @param name {string} 
 * @return {Ext.grid.GridPanel} Folder grid
 *
 */          
      folder: function(id,title){
         _folder_store =  this.getFolderStore(id);
         _folder_grid = new Ext.grid.GridPanel({
                                 border:false,
                                 autoscroll: true,
						         autoDestroy: true,  
						         closable:true,
                                 title: title,
                                 id: 'folder-grid-'+id,
                                 ds:  _folder_store,
                                 cm: new Ext.grid.ColumnModel([
										{header: "Icon", width: 32, sortable: false,renderer: renderIcon,  dataIndex: 'icon'},
										{header: "Name", width: 100, sortable: true,  dataIndex: 'name'},
										{header: "Style", width: 100, sortable: true,  dataIndex: 'reference_type'},
										{header: "Summmary", width: 300, sortable: false,   dataIndex: 'summary'},
										{header: "Updated By", width: 85, sortable: false,  dataIndex: 'updated_by'},
										{header: "Updated At", width: 85, sortable: true,
                                                  renderer: Ext.util.Format.dateRenderer('d/m/Y'), dataIndex: 'updated_at'},
										{header: "Actions", width: 75,   dataIndex: 'actions'}
									]),
                                 view: new Ext.grid.GroupingView(),
                                 viewConfig: {forceFit:true},
                        tbar:[{
								text:'Add File',
								tooltip:'Add a image or other file to the folder',
                                href: '/asset/new?folder_id='+id,                                
								iconCls:'add'
							}, {
								text:'Add Article',
								tooltip:'Add some textual content to the folder',
                                href: '/content/new?folder_id='+id,                              
								iconCls:'add'
							}, {
								text:'Add Sub-folder',
								tooltip:'Add a new sub folder',
                                href: '/folders/new?folder_id='+id,                                
								iconCls:'add'
							}, '-', {
								text:'Preview',
								tooltip:'Preview',
                                href: '/folders/print?folder_id='+id,                                
								iconCls:'print'
							},'-',{
								text:'Print',
								tooltip:'Print the folder as a report',
                                href: '/folders/print?format=pdf&folder_id='+id,                                
								iconCls:'print'
							}]
               });    
           _folder_store.load({params:{start: 0, limit: 50}});
           if (_center_panel){
              tab = Ext.ComponentMgr.get('folder-grid-'+id);
              if (tab) {
                   _center_panel.remove(tab);
                   _center_panel.doLayout();
              };
			  _center_panel.add( _folder_grid );  
              _center_panel.setActiveTab( _folder_grid );
              _center_panel.doLayout();
                                           
          }  
         return _folder_grid;                        
      },      

            
      init : function(){ 
          if (!_viewport){    
            Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
            _viewport = new Ext.Viewport(_layout ); // End Viewport
          }
        }
   };
}();

//------------------ Folder Tree Panel------------------------------------------------------------------
Biorails.Tree = function(){
  var _tree =null;
  var _root =null;
return {
/*
 * Initialize Folder Tree display
 */
   init: function() {
   
    _tree = new Ext.Tree.TreePanel({
        el:'tree-div',
        autoScroll:true,
        animate:true,
        enableDD:true,
        containerScroll: true, 
        loader: new Ext.Tree.TreeLoader({
            dataUrl:'/projects/show'
        })
    });

    // set the root node
    _root = new Ext.Tree.AsyncTreeNode({
        text: 'Ext JS',
        draggable:false,
        id:'source'
    });
    _tree.setRootNode(root);

    // render the tree
    _tree.render();
    _root.expand();
    }  
  }      
}();

//------------------ Report Definition -------------------------------------------------------------------
Biorails.Report = function() {
 var _tree = null;
 var _root = null;
 var columnDropZone;

    // public space
return {
        // public methods
   init: function(pk) {
	columnDropZone = new Biorails.Report.DropTarget( pk, 'report-definition', {
            ddGroup:'ColumnDD',
            overClass: 'dd-over'
        });
      
     },
/*
 * Generate a column tree in the status panel for the colunns which can be added to the tree
 
 */     
    columnTree: function(config){  
      
      _tree = new Ext.tree.TreePanel({
					  id: 'column-tree-id',
                      applyTo: 'column-tree',                    
					  animate:true,
					  autoScroll:true,
					  loader: new Ext.tree.TreeLoader(), 
					  lines: true,
					  enableDrag: true,
					  containerScroll: true,
					  singleExpand: true,
					  ddGroup: 'ColumnDD',
					  selModel: new Ext.tree.MultiSelectionModel(),
					  containerScroll: false  });

      _root = new Ext.tree.AsyncTreeNode(config);
	 
      _tree.setRootNode(_root);
	  _tree.render();
	  _root.expand();
	  _tree.on('dblclick',function(node,e){
				new Ajax.Request('/reports/add_column/#{report.id}',
						{asynchronous:true,
						 evalScripts:true,
						 parameters:'id='+encodeURIComponent(node.id) }); 
				return false;
			});
	} 
   };
}(); // end of app

Biorails.Report.DropTarget =function(id,el,config) {
   var _id = id;
   Biorails.Report.DropTarget.superclass.constructor.call(this,el,config);   
};

Ext.extend( Biorails.Report.DropTarget, Ext.dd.DropTarget, {

  notifyDrop: function (source,e,data) {
    new Ajax.Request('/reports/add_column/'+_id,
                {asynchronous:true,
                 evalScripts:true,
                 parameters:'id='+encodeURIComponent(data.node.id) }); 
    return false;

     }
});      





//------------------ Main App ------------------------------------------------------------------------

try {
 Ext.onReady( function() 
    { 
        Biorails.init();        
    }, 
    Biorails);
} catch (e) {
	if (Ext.isGecko) {
 	  console.log('Problem with main javascript ');
	  console.log(e);		
	}
};
