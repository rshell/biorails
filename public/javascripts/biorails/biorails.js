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
     if (e.ajax) {
		 this.base_url = e.url;
		 new Ajax.Request(e.url,{
				method: 'get',
				evalScripts: true
			});
     } else {
        
     };
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
            title:'Folders',
            minHeight: 400,
            autoShow: true,            
			animate:true,
			enableDD:true,
			containerScroll: true,
            iconCls:'icon-folder', 
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
					title:"Workbench"
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
                    iconCls:'icon-help', 
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
		 items: [{text: 'Home', menu: { items: [
								{text: "Dashboard",iconCls:'icon-home',    url:'/home',handler: clickMenu ,scope: this },
								'-',
								{text: "Recent",  iconCls:'icon-news' ,      url:'/home/news',handler: clickMenu ,scope: this },
								{text: "Projects",iconCls:'icon-project' ,      url:'/home/projects',handler: clickMenu ,scope: this },
								{text: "Todo",    iconCls:'icon-todo' ,      url:'/home/todo',handler: clickMenu ,scope: this  },
								{text: "Tasks",   iconCls:'icon-task' ,      url:'/home/tasks',handler: clickMenu ,scope: this  },
								{text: "Requests",iconCls:'icon-request' ,      url:'/home/requests',handler: clickMenu ,scope: this  }
							]}},
				 {text: 'Project', menu : {items: [
								{text: "Dashboard", iconCls:'icon-project',   url:'/projects/show',handler: clickMenu ,scope: this },
								'-',
								{text: "Calender",    iconCls:'icon-calendar' ,   url:'/projects/calendar',handler: clickMenu ,  scope: this },
								{text: 'Timeline',    iconCls:'icon-timeline' ,   url:'/projects/gantt',handler: clickMenu,  scope: this },
								{text: 'Folders',      url:'/folders',handler: clickMenu,  scope: this },
								{text: 'Study Designs',url:'/studies',handler: clickMenu,  scope: this },
								{text: 'Experiments',  url:'/experiments',handler: clickMenu,  scope: this },
								{text: "Reports",      url:'/reports',handler: clickMenu, scope: this }
							]}},
				 {text: 'Design',menu : {items: [
								{text: "Studies", iconCls:'icon-study' ,     href:'/studies',  scope: this },
								{text: "Services", iconCls:'icon-service' ,  href:'/queues' ,scope: this },
								{text: "Protocols",iconCls:'icon-protocol' , href:'/protocols' , scope: this }
							]}},' ',
				 {text: 'Inventory',menu : {items: [
								{text: "Molecules", iconCls:'icon-molecule' , href:'/molecules' ,  scope: this },
								{text: "Compounds", iconCls:'icon-compound' , href:'/compounds',  scope: this },
								{text: "Batches",   iconCls:'icon-batch' ,    href:'/batches' ,  scope: this },
								{text: "Mixtures",  iconCls:'icon-mixture' ,  href:'/mixtures',  scope: this },
								{text: "Samples",   iconCls:'icon-sample' ,   href:'/samples' ,  scope: this },
								{text: "Containers",iconCls:'icon-container' ,href:'/containers' ,  scope: this }
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
				 {text: 'Help',menu : {items: [
								{text: "Help",  scope: this }			            
							]}},
				  '->',
				  searchField,
				  {text: 'search',handler: onSearchClick},							
				  {text: 'logout', iconCls:'icon-logout', href:'/logoff'}							
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
		        width: 170,
                minHeight: 600,                       
		        minSize: 170,
		        maxSize: 400,
		        layout:'accordion',
		        layoutConfig:{
		            animate:true
		        },
		        items: [ _actions_panel, _work_panel]
			  },{
			    region:"east",
			    title:"Extras",
                layout: 'fit',                       
			    id:'extra-id',	
			    width: 225,
                minHeight: 600,                       
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
			        items:[ _status_panel, _help_panel, _tree_panel  ]
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

//------------------ Biorails Form controls --------------------------------------------------------

/*
 * Do some intelligent parsing of date to like like's  of next tues
 */
Biorails.MagicDate = function(){
	// arrays for month and weekday names
	var monthNames = "January February March April May June July August September October November December".split(" ");
	var weekdayNames = "Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split(" ");

	/* Takes a string, returns the index of the month matching that string, throws
	   an error if 0 or more than 1 matches
	*/
	function parseMonth(month) {
		var matches = monthNames.filter(function(item) { 
			return new RegExp("^" + month, "i").test(item);
		});
		if (matches.length == 0) {
			throw new Error("Invalid month string");
		}
		if (matches.length < 1) {
			throw new Error("Ambiguous month");
		}
		return monthNames.indexOf(matches[0]);
	}

	/* Same as parseMonth but for days of the week */
	function parseWeekday(weekday) {
		var matches = weekdayNames.filter(function(item) {
			return new RegExp("^" + weekday, "i").test(item);
		});
		if (matches.length == 0) {
			throw new Error("Invalid day string");
		}
		if (matches.length < 1) {
			throw new Error("Ambiguous weekday");
		}
		return weekdayNames.indexOf(matches[0]);
	}

	function DateInRange( yyyy, mm, dd )
	   {
	   // if month out of range
	   if ( mm < 0 || mm > 11 )
		  throw new Error('Invalid month value.  Valid months values are 1 to 12');

	   if (!configAutoRollOver) {
		   // get last day in month
		   var d = (11 == mm) ? new Date(yyyy + 1, 0, 0) : new Date(yyyy, mm + 1, 0);

		   // if date out of range
		   if ( dd < 1 || dd > d.getDate() )
			  throw new Error('Invalid date value.  Valid date values for ' + monthNames[mm] + ' are 1 to ' + d.getDate().toString());
	   }
	   return true;
	   }

	function getDateObj(yyyy, mm, dd) {
		var obj = new Date();

		obj.setDate(1);
		obj.setYear(yyyy);
		obj.setMonth(mm);
		obj.setDate(dd);

		return obj;
	}

	/* Array of objects, each has 're', a regular expression and 'handler', a 
	   function for creating a date from something that matches the regular 
	   expression. Handlers may throw errors if string is unparseable. 
	*/
	var dateParsePatterns = [
		// Today
		{   re: /^tod|now/i,
			handler: function() { 
				return new Date();
			} 
		},
		// Tomorrow
		{   re: /^tom/i,
			handler: function() {
				var d = new Date(); 
				d.setDate(d.getDate() + 1); 
				return d;
			}
		},
		// Yesterday
		{   re: /^yes/i,
			handler: function() {
				var d = new Date();
				d.setDate(d.getDate() - 1);
				return d;
			}
		},
		// 4th
		{   re: /^(\d{1,2})(st|nd|rd|th)?$/i, 
			handler: function(bits) {

				var d = new Date();
				var yyyy = d.getFullYear();
				var dd = parseInt(bits[1], 10);
				var mm = d.getMonth();

				if ( DateInRange( yyyy, mm, dd ) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// 4th Jan
		{   re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of\s)?(\w+)$/i, 
			handler: function(bits) {

				var d = new Date();
				var yyyy = d.getFullYear();
				var dd = parseInt(bits[1], 10);
				var mm = parseMonth(bits[2]);

				if ( DateInRange( yyyy, mm, dd ) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// 4th Jan 2003
		{   re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of )?(\w+),? (\d{4})$/i,
			handler: function(bits) {
				var d = new Date();
				d.setDate(parseInt(bits[1], 10));
				d.setMonth(parseMonth(bits[2]));
				d.setYear(bits[3]);
				return d;
			}
		},
		// Jan 4th
		{   re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?$/i, 
			handler: function(bits) {

				var d = new Date();
				var yyyy = d.getFullYear(); 
				var dd = parseInt(bits[2], 10);
				var mm = parseMonth(bits[1]);

				if ( DateInRange( yyyy, mm, dd ) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// Jan 4th 2003
		{   re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?,? (\d{4})$/i,
			handler: function(bits) {

				var yyyy = parseInt(bits[3], 10); 
				var dd = parseInt(bits[2], 10);
				var mm = parseMonth(bits[1]);

				if ( DateInRange( yyyy, mm, dd ) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// Next Week, Last Week, Next Month, Last Month, Next Year, Last Year
		{   re: /((next|last)\s(week|month|year))/i,
			handler: function(bits) {
				var objDate = new Date();

				var dd = objDate.getDate();
				var mm = objDate.getMonth();
				var yyyy = objDate.getFullYear();

				switch (bits[3]) {
				  case 'week':
					var newDay = (bits[2] == 'next') ? (dd + 7) : (dd - 7);

					objDate.setDate(newDay);

					break;
				  case 'month':
					var newMonth = (bits[2] == 'next') ? (mm + 1) : (mm - 1);

					objDate.setMonth(newMonth);

					break;
				  case 'year':
					var newYear = (bits[2] == 'next') ? (yyyy + 1) : (yyyy - 1);

					objDate.setYear(newYear);

					break;
				}

				return objDate;
			}
		},
		// next Tuesday - this is suspect due to weird meaning of "next"
		{   re: /^next (\w+)$/i,
			handler: function(bits) {

				var d = new Date();
				var day = d.getDay();
				var newDay = parseWeekday(bits[1]);
				var addDays = newDay - day;
				if (newDay <= day) {
					addDays += 7;
				}
				d.setDate(d.getDate() + addDays);
				return d;

			}
		},
		// last Tuesday
		{   re: /^last (\w+)$/i,
			handler: function(bits) {

				var d = new Date();
				var wd = d.getDay();
				var nwd = parseWeekday(bits[1]);

				// determine the number of days to subtract to get last weekday
				var addDays = (-1 * (wd + 7 - nwd)) % 7;

				// above calculate 0 if weekdays are the same so we have to change this to 7
				if (0 == addDays)
				   addDays = -7;

				// adjust date and return
				d.setDate(d.getDate() + addDays);
				return d;

			}
		},
		// mm/dd/yyyy (American style)
		{   re: /(\d{1,2})\/(\d{1,2})\/(\d{4})/,
			handler: function(bits) {
				// if config date type is set to another format, use that instead
				if (configDateType == 'dd/mm/yyyy') {
				  var yyyy = parseInt(bits[3], 10);
				  var dd = parseInt(bits[1], 10);
				  var mm = parseInt(bits[2], 10) - 1;
				} else {
				  var yyyy = parseInt(bits[3], 10);
				  var dd = parseInt(bits[2], 10);
				  var mm = parseInt(bits[1], 10) - 1;
				}

				if ( DateInRange( yyyy, mm, dd ) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// mm/dd/yy (American style) short year
		{   re: /(\d{1,2})\/(\d{1,2})\/(\d{1,2})/,
			handler: function(bits) {

				var d = new Date();
				var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[3], 10);
				var dd = parseInt(bits[2], 10);
				var mm = parseInt(bits[1], 10) - 1;

				if ( DateInRange(yyyy, mm, dd) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// mm/dd (American style) omitted year
		{   re: /(\d{1,2})\/(\d{1,2})/,
			handler: function(bits) {

				var d = new Date();
				var yyyy = d.getFullYear();
				var dd = parseInt(bits[2], 10);
				var mm = parseInt(bits[1], 10) - 1;

				if ( DateInRange(yyyy, mm, dd) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// mm-dd-yyyy
		{   re: /(\d{1,2})-(\d{1,2})-(\d{4})/,
			handler: function(bits) {
				if (configDateType == 'dd-mm-yyyy') {
				  // if the config is set to use a different schema, then use that instead
				  var yyyy = parseInt(bits[3], 10);
				  var dd = parseInt(bits[1], 10);
				  var mm = parseInt(bits[2], 10) - 1;
				} else {
				  var yyyy = parseInt(bits[3], 10);
				  var dd = parseInt(bits[2], 10);
				  var mm = parseInt(bits[1], 10) - 1;
				}

				if ( DateInRange( yyyy, mm, dd ) ) {
				   return getDateObj(yyyy, mm, dd);
				}

			}
		},
		// dd.mm.yyyy
		{   re: /(\d{1,2})\.(\d{1,2})\.(\d{4})/,
			handler: function(bits) {
				var dd = parseInt(bits[1], 10);
				var mm = parseInt(bits[2], 10) - 1;
				var yyyy = parseInt(bits[3], 10);

				if ( DateInRange( yyyy, mm, dd ) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// yyyy-mm-dd (ISO style)
		{   re: /(\d{4})-(\d{1,2})-(\d{1,2})/,
			handler: function(bits) {

				var yyyy = parseInt(bits[1], 10);
				var dd = parseInt(bits[3], 10);
				var mm = parseInt(bits[2], 10) - 1;

				if ( DateInRange( yyyy, mm, dd ) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// yy-mm-dd (ISO style) short year
		{   re: /(\d{1,2})-(\d{1,2})-(\d{1,2})/,
			handler: function(bits) {

				var d = new Date();
				var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[1], 10);
				var dd = parseInt(bits[3], 10);
				var mm = parseInt(bits[2], 10) - 1;

				if ( DateInRange( yyyy, mm, dd ) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// mm-dd (ISO style) omitted year
		{   re: /(\d{1,2})-(\d{1,2})/,
			handler: function(bits) {

				var d = new Date();
				var yyyy = d.getFullYear();
				var dd = parseInt(bits[2], 10);
				var mm = parseInt(bits[1], 10) - 1;

				if ( DateInRange( yyyy, mm, dd ) )
				   return getDateObj(yyyy, mm, dd);

			}
		},
		// mon, tue, wed, thr, fri, sat, sun
		{   re: /(^mon.*|^tue.*|^wed.*|^thu.*|^fri.*|^sat.*|^sun.*)/i,
			handler: function(bits) {
				var d = new Date();
				var day = d.getDay();
				var newDay = parseWeekday(bits[1]);
				var addDays = newDay - day;
				if (newDay <= day) {
					addDays += 7;
				}
				d.setDate(d.getDate() + addDays);
				return d;
			}
		},
	];
return {
    parse: function(s) {
		for (var i = 0; i < dateParsePatterns.length; i++) {
			var re = dateParsePatterns[i].re;
			var handler = dateParsePatterns[i].handler;
			var bits = re.exec(s);
			if (bits) {
				return handler(bits);
			}
		}
                
		//throw new Error("Invalid date string");
        return "";        
	}
}      
}();


/**
 *  Biorails.DateField 
 *  
 *  Based on "A better way of entering dates"  
 *       http://simonwillison.net/2003/Oct/6/betterDateInput/
 *  and Datablocks engine http://dev.toolbocks.com
 *
 */

Ext.namespace("Biorails.DateField");

/**
 * Date field that allows user to enter shortcuts (ie 't' for today's date)
 * and plain english like '5 days ago'.
 * 
 * @class Biorails.DateFieldField
 * @extends Ext.form.DateField
 * @see Biorails.DateField
 * @constructor   Create a new  Date Field
 * @param {Object} config The config object
 */
Biorails.DateField = function(config){    
    Biorails.DateField.superclass.constructor.call(this,config); 
};

Ext.extend(Biorails.DateField,  Ext.form.DateField, {
	parseDate : function(raw) {
		var value = Biorails.DateField.superclass.parseDate.call(this, raw);
		
        if(!value) {
			value = Biorails.MagicDate.parse(raw);
		}

		return value;
	}
});
//Ext.reg('datefield', Biorails.DateField); // Register as default datefield in Ext


/**
 *  Biorails.SelectField 
 *
 * Custom Select field for a defined list of values
 */


Ext.namespace("Biorails.SelectField");

Biorails.SelectField = function(id){    
    Biorails.SelectField .superclass.constructor.call(this,{
		typeAhead: true,
        triggerAction: 'all',
        transform: id,
        forceSelection:true        
        }); 
};

Ext.extend(Biorails.SelectField,  Ext.form.ComboBox, {});
/**
 * Custom Select field for a remote data element field
 */
Biorails.ComboField = function(id, element_id){    
    Biorails.DateField.superclass.constructor.call(this,{
		 mode:'remote',
         applyTo: id,
         store: new Ext.data.Store({
                   proxy: new Ext.data.HttpProxy({
                            url: '/admin/element/select/'+element_id, method: 'get' 
                          }),
         reader: new Ext.data.JsonReader({
								root: 'items', 
								totalProperty: 'total'},
								 [ {name: 'id', type: 'int'},
								   {name: 'name'},
								   {name: 'description'}]  )
                    }),
         triggerAction: 'all',
		 forceSelection: true,
		 editable: true,
         loadingText: 'Searching...',
		 valueField: 'id',
		 displayField: 'name'
         }); 
};

Ext.extend(Biorails.ComboField,  Ext.form.ComboBox, {});
//Ext.reg('datefield', Biorails.DateField); // Register as default datefield in Ext



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
