/////////////////////////////////////////////////////////////////////////////////////
// Biorails Application Javascript Support codde
//
//
// Created by: 
//      Robert Shell - http://biorails.com
//
// License:
//      GNU General Public License version 2.0 
//      http://www.gnu.org/licenses/gpl.html
//
// Bugs:
//      Please submit bug reports to http://biorails.org
//
/////////////////////////////////////////////////////////////////////////////////////



Ext.BLANK_IMAGE_URL = '/images/s.gif';
Ext.ux.grid.filter.StringFilter.prototype.icon = 'img/find.png';
Ext.ux.menu.RangeMenu.prototype.icons = {
          gt: '/images/greater_then.png', 
          lt: '/images/less_then.png',
          eq: '/images/equals.png'
};

Ext.namespace("Biorails");
//---------------------------------------- Core Biorails ----------------------------------------------------------
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

   var _toolbar = null;
   var _base_url = null;
   var _viewport = null;
   var _folder_panel = null;
   var _document_panel = null;
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
          new Ajax.Request('/finder/search',
                {asynchronous:true,
                 evalScripts:true,
                 parameters:'text='+encodeURIComponent(searchField.getValue()) }); 
          return false;

   };	   

//
// Chick on a Menu
//		
  function clickMenu(e) {
     if (e.ajax) {
		 this.base_url = e.url;
		 new Ajax.Request(e.url,{
				method: 'get',
				evalScripts: true
			});
     } else {
        
     };
    };

/*
 * Handling a element dropped onto the clipboard work brench
 *
 */
    function dropOnClipboard(dd,e,data) {
       try{ 
            // Test for case of a row from a grid
            if (data.grid) {
                source_row = data.grid.store.getAt(data.rowIndex);
                new Ajax.Request("/finder/add_clipboard/"+source_row.data.id, 
                    {asynchronous:true, evalScripts:true});
            }
            // Test for case of a node from a folder tree 
            else if (data.node) {
                new Ajax.Request("/finder/add_clipboard/"+data.node.id, 
                    {asynchronous:true, evalScripts:true});
            }  
        } catch (e) {
              console.log('Problem with drop ');
              console.log(e);
        } 
        return true;                
    };
    

    
    
//------------------ Main Layout ------------------------------------------------------------------------
// West: Navigation with project tree and actions for current controller
// East: Extras with help, work brench and current status messages
// North: Simple toolbar
// South: Audting and history information
// Centre: Main tab + accessaries tabs for grids etc.
//
// 
// Default Toolbar
// 
   var _toolbar =  new Ext.Toolbar({
        items: [{text: 'Home', menu: { items: [
                    {text: "Dashboard",iconCls:'icon-home',    href:'/home',scope: this },
                    '-',
                    {text: "Recent",  iconCls:'icon-news' ,      href:'/home/news',scope: this },
                    {text: "Projects",iconCls:'icon-project' ,      href:'/home/projects',scope: this },
                    {text: "Todo",    iconCls:'icon-todo' ,      href:'/home/todo',scope: this  },
                    {text: "Tasks",   iconCls:'icon-task' ,      href:'/home/tasks' ,scope: this  },
                    {text: "Requests",iconCls:'icon-request' ,      href:'/home/requests' ,scope: this  },
                    '-',
                    {text: "Logout",  iconCls:'icon-logout' ,      href:'/logoff' ,scope: this  }
                ]}},
             {text: 'Project', menu : {items: [
                    {text: "Dashboard", iconCls:'icon-project',   href:'/projects/show',scope: this },
                    '-',
                    {text: "Calender",    iconCls:'icon-calendar' ,   href:'/projects/calendar',  scope: this },
                    {text: 'Timeline',    iconCls:'icon-timeline' ,   href:'/projects/gantt' , scope: this },
                    {text: 'Folders',     iconCls:'icon-folder' , href:'/folders',  scope: this },
                    {text: 'Study Designs',iconCls:'icon-study' ,href:'/studies',  scope: this },
                    {text: 'Experiments', iconCls:'icon-experiment' , href:'/experiments',  scope: this },
                    {text: "Reports",     iconCls:'icon-report' , href:'/reports', scope: this }
                ]}},
             {text: 'Design',menu : {items: [
                    {text: "Studies", iconCls:'icon-study' ,     href:'/studies',  scope: this },
                    {text: "Services", iconCls:'icon-service' ,  href:'/queues' ,scope: this },
                    {text: "Protocols",iconCls:'icon-protocol' , href:'/protocols' , scope: this }
                ]}},' ',
             {text: 'Inventory',menu : {items: [
                    {text: "Compounds", iconCls:'icon-compound' , href:'/inventory/compounds',  scope: this },
                    {text: "Batches",   iconCls:'icon-batch' ,    href:'/inventory/batches' ,  scope: this }
                ]}},' ',
             {text: 'Administration',menu : {items: [
                    {text: "Catalogue", iconCls:'icon-catalogue' , href:'/admin/catalogue', scope: this },
                    '-',
                    {text: "Data Sources",iconCls:'icon-data-system' ,href:'/admin/system',  scope: this },
                    {text: "Data Types",  iconCls:'icon-data-type' ,href:'/admin/data',  scope: this },
                    {text: "Data Lookups",iconCls:'icon-data-element' ,  href:'/admin/element',  scope: this },
                    {text: "Data Formats",iconCls:'icon-data-format' ,  href:'/admin/format',   scope: this },
                    '-',
                    {text: "Study Stage",iconCls:'icon-study-stage' ,  href:'/admin/stage', scope: this },
                    {text: "Parameter types",iconCls:'icon-parameter-type' , href:'/admin/parameters',  scope: this },
                    {text: "Parameter Roles",iconCls:'icon-parameter-role' , href:'/admin/usage', scope: this },
                    '-',
                    {text: "Roles",iconCls:'icon-role' , href:'/admin/role', scope: this },
                    {text: "Users",iconCls:'icon-user' , href:'/admin/users',  scope: this }
                ]}},
             {text: 'Help',menu : {items: [{text: "Help",href:'/help',   scope: this } ]}},
              '->',
              searchField,
              {text: 'Search',handler: onSearchClick}				
            ]});

// region -----------------------North------------------------------
                                
   var _north_panel = new Ext.Panel({
			 region:"north",
			 autoHeight: true,
                         autoShow:  true,                  
			 el: 'toolbar-panel',
			 tbar: _toolbar	   		
			  });                            
// region -----------------------West------------------------------
   var _actions_panel = new Ext.Panel({
		            title:'Menu Actions',
		            contentEl: 'actions-panel',
		            border:false,
                            autoScroll: true,
		            iconCls:'settings'
		        } );

   var _work_panel = new Ext.Panel({
                                xtype:"panel",
                                autoScroll: true,
                                contentEl: 'work-tab',
            //autoLoad: {url:'/finder/clipboard?format=html',method:'get',scripts:true},                    
                                id: 'work-id',
                                title:"Clipboard"
                      }  );


   var _west_panel = new Ext.Panel( {
                        region:"west",
                        title:"Navigation",
                        id:'nav-id',	
                        split:true,
                        collapsible:true,
                        useSplitTips: true,
                        titleCollapse:true,
		        width: 140,
                        minHeight: 600,                       
		        minSize: 100,
		        maxSize: 400,
		        layout:'accordion',
		        layoutConfig:{     animate:true   },
		        items: [ _actions_panel, _work_panel]
			  });
                          
   
// region -----------------------East------------------------------
   var _status_panel = new Ext.Panel({
                    xtype:"panel",
                    layout:'fit',                    
                    contentEl: 'status-tab',
                    autoDestroy: true,  
                    autoScroll: true,
                    id: 'status-id',
                    iconCls:'icon-help',                                         
                    title:"Info."
              } );

   var _tree_panel = new Ext.tree.TreePanel({
			el:'tree-panel',
            title:'Folders',
            minHeight: 400,
            autoShow: true,
            autoScroll: true,            
         	autoDestroy: true,  
			animate:true,
			enableDD:true,
            iconCls:'icon-folder', 
			loader: new Ext.tree.TreeLoader({ dataUrl:'/home/tree'	})
		});
    _tree_panel.setRootNode( new Ext.tree.AsyncTreeNode({   text: 'Projects',expanded: true,    draggable:false, id: 'root' }) );
    
   var _east_panel = new Ext.TabPanel( {
			    region:"east",
			    title:"Extras",
		        xtype:"tabpanel",
			    id:'extra-id',	
			    width: 170,
                minHeight: 600,                       
				minSize: 100,
                maxSize: 400,
			    split:true,
			    useSplitTips: true,
			    collapsible:true,
			    titleCollapse:true,
		        activeTab:0,
			    tabPosition: 'bottom',
		        items:[ _status_panel, _tree_panel ]
			  });

// region -----------------------Center------------------------------
  var _center_panel = new Ext.Panel({
			        region:"center",
					id: 'center-id',			
					contentEl:'center-panel',
					autoScroll: true,
                    frame: true
			       });    
                               
                                                          
  var _main_panel = new Ext.Panel({
			        region:"center",
					id: 'main-id',
		            layout:'border',
                    autoWidth:false,        
                    autoHeight:false,        
                    items:[_center_panel]
			       });  
                                  
  

// South                                  
   var _footer_panel = new Ext.Panel({
					contentEl:'footer-panel',
					border:false,
					autoDestroy: true,  
					autoScroll: true,
					iconCls:'nav'
				});
                                                             
   var _south_panel = new Ext.Panel({
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
			 });                                
 
                          


   var _layout = {
		layout:"border",
	    autoHeight: true,
 	   	autoWidth : true,
		autoScroll: true,
		items:[ _north_panel , _south_panel  , _west_panel , _east_panel , _center_panel  ]
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
      centerPanel: function(){ return _center_panel;}, 
      statusPanel: function(){ return _status_panel;}, 
      actionPanel: function(){ return _actions_panel;}, 
      clipboardPanel: function(){ return _work_panel;}, 
        
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
 * Setup the Project tree on the navigation panel
 */        
      projectTree : function(config){

      var tree = new Ext.tree.TreePanel('project-tree', {
                                      animate: true,
                                      enableDrag: true,
                                      ddGroup: "GridDD",
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
 * Set the active panel in the UI
 */          
    focus: function(id){
        if ('main'==id) {  _center_panel.activate(_main_panel); }  
        else if ('clipboard'==id) { _work_panel.focus(); }  
        else if ('status'==id) { _east_panel.activate(_status_panel); }  
        else if ('tree'==id) { _east_panel.activate(_tree_panel); };  
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
                                 id: 'model-folder-id',
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
 * Hide Folder
 *
 * @param config of the model grid
 *
 */      
      hideDocument: function(){
            if( _document_panel){
                _document_panel.hide();
            };    
      },
      hideFolder: function(){
            if( _folder_panel){
                _folder_panel.hide();
            };    
      },          
/*
 * show a datagrid to the passed current config
 *
 * @param config of the model grid
 *
 */      
      showDocument: function(folder_id){
                this.hideFolder();
                this.hideDocument();
                
                if (Ext.isIE6) {
                _document_panel = new Biorails.Document({
                               folder_id: folder_id,
                               layout: 'fit',
                               border:true,
                               width: _center_panel.getSize().width-20,
                               height: _center_panel.getSize().height-20,
                               autoShow: true,
                               position: 'static',
                               autoScroll: true,            
                               autoDestroy: true,  
                               shim: true,
                               monitorResize: true
                        });                    
                } else { // Working browser
                _document_panel = new Biorails.Document({
                               folder_id: folder_id,
                               border:true,
                               autoHeight: true,
                               autoShow: true,
                               autoScroll: true,            
                               autoDestroy: true,  
                               shim: true,
                               monitorResize: true,
                               layout: 'fit'         	
                        });
                        }
	        _center_panel.add(_document_panel);                
                _viewport.doLayout();         
      },  
          
/*
 * show a datagrid to the passed current config
 *
 * @param config of the model grid
 *
 */      
      showFolder: function(folder_id){
                this.hideFolder();
                this.hideDocument();
                    
                if (Ext.isIE6) {
                _folder_panel = new Biorails.Folder({
                               folder_id: folder_id,
                               layout: 'fit',
                               border:true,
                               width: _center_panel.getSize().width-20,
                               height: _center_panel.getSize().height-20,
                               autoShow: true,
                               autoScroll: true,            
                               autoDestroy: true,  
                               shim: true,
                               monitorResize: true
                        });                    
                } else { // Working browser
                _folder_panel = new Biorails.Folder({
                               folder_id: folder_id,
                               layout: 'fit',
                               border:true,
                               autoHeight: true,
                               autoShow: true,
                               autoDestroy: true,  
                               shim: true,
                               monitorResize: true
                        });
               }                             
                        

			    _center_panel.add(_folder_panel);                
                _center_panel.doLayout();
      },
      refresh: function(){
        if( _folder_panel && _folder_panel.store){            
            _folder_panel.store.load();
        };                 
      },
          
/*
 * show a datagrid to the passed current config
 *
 * @param config of the model grid
 *
 */      
      showGrid: function(config) {
            ReadConfig(config);
            if( _folder_panel){
                _folder_panel.destroy();
            };    
            _center_panel.add( this.grid() );                
            _center_panel.doLayout();
      }, 
            
      init : function(){ 
         Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
         Ext.QuickTips.init();
         if (!_viewport){    
            _viewport = new Ext.Viewport(_layout ); // End Viewport
            
            var dropZone = new Ext.dd.DropTarget(_work_panel.id, {
             ddGroup:"GridDD",
             copy:false,
             notifyDrop : dropOnClipboard});   

             dropZone.addToGroup("ClipboardDD"); 
             dropZone.addToGroup("TreeDD"); 
           } 
        }
   };
}();

//---------------------------------------- Folders Document ----------------------------------------------------------
Ext.namespace("Biorails.Document");
/*
 * Panel for handling a biorails folder display. This is basically a grid with some custom D&D code.
 * 
 */
Biorails.Document = function(config){  
    
     Biorails.Document.superclass.constructor.call(this, Ext.apply(config,{
           autoLoad: '/folders/document/'+config.folder_id,
           id: 'folder-doc-'+config.folder_id,
           enableDragDrop: true,
           tbar:[{
                    text:'Add File',
                    tooltip:'Add a image or other file to the folder',
                    href: '/asset/new/'+config.folder_id, 
                    handler: this.toolbarClick,                               
                    iconCls:'icon-file'
                },'-', {
                    text:'Add Article',
                    tooltip:'Add some textual content to the folder',
                    href: '/content/new/'+config.folder_id,                              
                    handler: this.toolbarClick,                               
                    iconCls:'icon-note'
                },'-', {
                    text:'Add Sub-folder',
                    tooltip:'Add a new sub folder',
                    href: '/folders/new/'+config.folder_id,                                
                    handler: this.toolbarClick,                               
                    iconCls:'icon-folder'
                }, '-', {
                    text:'Folder',
                    tooltip:'Show as Folder',
                    folder_id: config.folder_id,                                
                    handler : function(item){
                        Biorails.showFolder(item.folder_id);
                    }, 
                    iconCls:'icon-print'
                },'-', {
                    text:'Preview',
                    tooltip:'Preview',
                    href: '/folders/print/'+config.folder_id,                                
                    handler : function(item){
                        window.open(item.href);
                    }, 
                    iconCls:'icon-print'
                },'-',{
                    text:'Print',
                    tooltip:'Print the folder as a report',
                    href: '/folders/print/'+config.folder_id+'?format=pdf',                                
                    handler : function(item){
                        window.open(item.href);
                    },                               
                    iconCls:'icon-pdf'
                }]   
         }));
};

Ext.extend(Biorails.Document,  Ext.Panel, {
/*
 * Fire AJAX call for tool bar functions
 */    
    toolbarClick: function(item) {
         new Ajax.Request( item.href,
                            {asynchronous:true,
                             evalScripts:true });         
       
    },
    resync: function(){
    }

   });	
//---------------------------------------- Folders Grid ----------------------------------------------------------

Ext.namespace("Biorails.Folder");
/*
 * Panel for handling a biorails folder display. This is basically a grid with some custom D&D code.
 * 
 */
Biorails.Folder = function(config){  
    
     var _store = new Ext.data.GroupingStore({
               remoteSort: true,
               sortInfo: {params:{sort: 'left_limit',dir:'ASC'}},
               lastOptions: {params:{sort: 'left_limit',dir:'ASC',start: 0, limit: 25}},
               proxy: new Ext.data.HttpProxy({ url: '/folders/grid/'+config.folder_id, method: 'get' }),
               reader: new Ext.data.JsonReader({
                             root: 'items', totalProperty: 'total'}, [
                                   {name: 'id', type: 'int' },
                                   {name: 'icon'},
                                   {name: 'position', type: 'int'},
                                   {name: 'left_limit', type: 'int'},
                                   {name: 'right_limit', type: 'int'},
                                   {name: 'name'},
                                   {name: 'summary'},
                                   {name: 'reference_type'},
                                   {name: 'updated_by'},
                                   {name: 'updated_at', type: 'date', dateFormat: 'Y-m-d H:i:s'},
                                   {name: 'actions'}]  )
                        });
                       
                         
     Biorails.Folder.superclass.constructor.call(this, Ext.apply(config,{
           id: 'folder-grid-'+config.folder_id,
           ds:  _store ,
           sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
           loadMask: true,
           enableDragDrop: true,
           cm: new Ext.grid.ColumnModel([
                {header: "Pos", width: 50, sortable: true, renderer: this.renderNum,  dataIndex: 'left_limit'},
                {header: "Icon", width: 32, sortable: false,renderer: this.renderIcon,  dataIndex: 'icon'},
                {header: "Name", width: 150, sortable: true,  dataIndex: 'name'},
                {header: "Style", width: 100, sortable: true,  dataIndex: 'reference_type'},
                {header: "Summmary", width: 300, sortable: false,   dataIndex: 'summary'},
                {header: "Updated By", width: 55, sortable: false,  dataIndex: 'updated_by'},
                {header: "Updated At", width: 85, sortable: true,
                          renderer: Ext.util.Format.dateRenderer('d/m/Y'), dataIndex: 'updated_at'},
                {header: "Actions", width: 75,   dataIndex: 'actions'}
                ]),
           view: new Ext.grid.GroupingView(),
           viewConfig: {
                 forceFit:false
               },
           tbar:[{
                    text:'Add File',
                    xtype:'tbbutton',
                    tooltip:'Add a image or other file to the folder',
                    href: '/asset/new/'+config.folder_id, 
                    handler: this.toolbarClick,                               
                    iconCls: 'icon-file'
                },'-', {
                    text:'Add Article',
                    tooltip:'Add some textual content to the folder',
                    xtype:'tbbutton',
                    href: '/content/new/'+config.folder_id,                              
                    handler: this.toolbarClick,                               
                    iconCls: 'icon-note'
                },'-', {
                    text:'Add Sub-folder',
                    tooltip:'Add a new sub folder',
                    xtype:'tbbutton',
                    href: '/folders/new/'+config.folder_id,                                
                    handler: this.toolbarClick,                               
                    iconCls: 'icon-folder'
                },'-', {
                    text:'Document',
                    tooltip:'Show as Document',
                    xtype:'tbbutton',
                    folder_id: config.folder_id,                                
                    handler : function(item){
                        Biorails.showDocument(item.folder_id);
                    }, 
                    iconCls: 'icon-print'
                }, '-', {
                    text:'Preview',
                    tooltip:'Preview',
                    xtype:'tbbutton',
                    href: '/folders/print/'+config.folder_id,                                
                    handler : function(item){
                        window.open(item.href);
                    }, 
                    iconCls: 'icon-print'
                },'-',{
                    text:'Print',
                    xtype:'tbbutton',
                    tooltip:'Print the folder as a report',
                    href: '/folders/print/'+config.folder_id+'?format=pdf',                                
                    handler : function(item){
                        window.open(item.href);
                    },                               
                    iconCls:'icon-pdf'
                }],
                bbar: new Ext.PagingToolbar({
				            pageSize: 25,
				            store: _store,
				            displayInfo: true,
				            displayMsg: 'Displaying {0} - {1} of {2}',
				            emptyMsg: "No results to display"
				        })
   
         }));
         if (_store.getCount() < 1){
             _store.load();             
         }
         
         this.on('render',    function(grid){
             grid.enableDD();
         });
};

Ext.extend(Biorails.Folder,  Ext.grid.GridPanel, {
/*
 * Fire AJAX call for tool bar functions
 */    
    toolbarClick: function(item) {
         new Ajax.Request( item.href,
                            {asynchronous:true,
                             evalScripts:true });         
       
    },
    renderIcon: function(val){
        return '<img src="' + val + '" />';
    },
    renderNum: function(val,cell,record,row,col,ds){
        return '1.'+record.get('position');
    },
    
 /*
  * dropped Item Handler to update the layout 
  * with new row added via clipboard or tree
  */      
   droppedItem: function(source,event,data){
       try{ 
           // Get selection for default row
            var sm=this.grid.getSelectionModel();
            var rows=sm.getSelections();

            // Test for case of a row from a grid
            if (data.rowIndex) {
                var source_row = data.grid.store.getAt(data.rowIndex);
                var  dest_row  = this.grid.store.getAt( source.getDragData(event).rowIndex );
                
                 new Ajax.Request("/folders/reorder_element/"+
                          source_row.data.id,
                        {asynchronous:true, 
                         onComplete: function(req) {
                             data.grid.store.load();
                             } ,
                         parameters:'before='+dest_row.data.id+'&folder_id='+data.grid.folder_id });  
                         
            }
            // Test for case of a node from a folder tree 
            else if (data.node) {
                
                new Ajax.Request('/folders/add_element/'+data.node.id,
                            {asynchronous:true,
                             onComplete: this.grid.resync,
                             parameters:'folder_id='+this.folder_id });  
            }  
        } catch (e) {
              console.log('Problem cant handle Dropped Item ');
              console.log(e);
        } 
        return true;  
   },
   
/*
 * Custom Rendering function to add drop zone on grid after its rendered
 */    
   enableDD: function(){
       try{       if (config.parent_id>0) {
          new Biorails.Protocol.ContextForm(config);
      } else {  
          new Biorails.Protocol.Preview(config);
      };
       
            var dropzone = new Ext.dd.DropTarget(this.id, {
                ddGroup : 'GridDD',
                folder_id: this.folder_id,
                grid: this,
                notifyDrop : this.droppedItem  });
             dropzone.addToGroup("ClipboardDD"); 
             dropzone.addToGroup("TreeDD"); 
        } catch (e) {
              console.log('Problem with setup drop zone on folder grid ');
              console.log(e);
        }        
   }

   });	

//----------------------------------------  Biorails Report ---------------------------------------------
Ext.namespace('Biorails.Report');

Biorails.Report.DropTarget =function(el,config) {
   Biorails.Report.DropTarget.superclass.constructor.call(this,el, 
       Ext.apply(config,{
            ddGroup:'ColumnDD',
            overClass: 'dd-over'}));   
};

Ext.extend( Biorails.Report.DropTarget, Ext.dd.DropTarget, {

  notifyDrop: function (source,e,data) {
    new Ajax.Request('/reports/add_column/'+this.report_id,
                {asynchronous:true,
                 evalScripts:true,
                 parameters:'id='+encodeURIComponent(data.node.id) }); 
    return false;

     }
});      

//----------------------------------------  Biorails Column Tree ---------------------------------------------
Ext.namespace("Biorails.ColumnTree");

Biorails.ColumnTree = function(config){
    
    Biorails.ColumnTree.superclass.constructor.call(this,Ext.apply(config,{
            title:'Model Columns',
            minHeight: 400,
            autoShow: true, 
            autoHeight:true,
            autoScroll:true,
            layout: 'fit',           
			animate:true,
			enableDD:true,
            ddGroup:'ColumnDD',
            iconCls:'icon-model', 
            root:  new Ext.tree.AsyncTreeNode({   text: config.model,
                                                  expanded: true,  
                                                  draggable:false, 
                                                  id: "."}),
			loader: new Ext.tree.TreeLoader({ dataUrl: '/reports/columns/'+config.report_id	})
		}));
                
        this.on('dblclick',function(node,e) { 
            this.add_column(node) 
        });
                      
}

Ext.extend(Biorails.ColumnTree,  Ext.tree.TreePanel, {
    
  add_column: function (node){
      if (node.leaf) {
        new Ajax.Request('/reports/add_column/'+this.report_id,
                {asynchronous:true,
                 evalScripts:true,
                 parameters:'id='+encodeURIComponent(node.id) }); 
        }
        return false;
  }  
} );

//------------------ Main App ------------------------------------------------------------------------

 Ext.onReady( function() { 
try {
        Biorails.init();        
} catch (e) {
	if (Ext.isGecko) {
 	  console.log('Problem with main javascript ');
	  console.log(e);		
	}
};    }, Biorails);
