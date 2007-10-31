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
                    //autoLoad: {url:'/finder/clipboard?format=html',method:'get',scripts:true},                    
					id: 'work-id',
					title:"Clipboard"
				  }  );
   
   var _status_panel = new Ext.Panel({
					xtype:"panel",
					contentEl: 'status-tab',
					autoDestroy: true,  
					autoScroll: true,
					id: 'status-id',
                    iconCls:'icon-help',                                         
					title:"Info."
				  } );

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
								{text: "Dashboard",iconCls:'icon-home',    href:'/home',scope: this },
								'-',
								{text: "Recent",  iconCls:'icon-news' ,      href:'/home/news',scope: this },
								{text: "Projects",iconCls:'icon-project' ,      href:'/home/projects',scope: this },
								{text: "Todo",    iconCls:'icon-todo' ,      href:'/home/todo',scope: this  },
								{text: "Tasks",   iconCls:'icon-task' ,      href:'/home/tasks' ,scope: this  },
								{text: "Requests",iconCls:'icon-request' ,      href:'/home/requests' ,scope: this  }
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
								{text: "Molecules", iconCls:'icon-molecule' , href:'/inventory/molecules' ,  scope: this },
								{text: "Compounds", iconCls:'icon-compound' , href:'/inventory/compounds',  scope: this },
								{text: "Batches",   iconCls:'icon-batch' ,    href:'/inventory/batches' ,  scope: this },
								{text: "Mixtures",  iconCls:'icon-mixture' ,  href:'/inventory/mixtures',  scope: this },
								{text: "Samples",   iconCls:'icon-sample' ,   href:'/inventory/samples' ,  scope: this },
								{text: "Containers",iconCls:'icon-container' ,href:'/inventory/containers' ,  scope: this }
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
				    tabPosition: 'bottom',
			        items:[ _status_panel, _tree_panel  ]
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
        _folder_grid = new Biorails.Folder(id,title);
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


//---------------------------------------- Date Field Widget--------------------------------------------------------
Ext.namespace("Biorails.DateField");
/**
 *  Biorails.DateField 
 *  
 *  Based on "A better way of entering dates"  
 *       http://simonwillison.net/2003/Oct/6/betterDateInput/
 *  and Datablocks engine http://dev.toolbocks.com
 *
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
         try {
            var value = Biorails.DateField.superclass.parseDate.call(this, raw);
		
            if(!value) {
                value = Biorails.MagicDate.parse(raw);
            }
            return value;
            } catch (e) {
          return "";    
        }
	}
});
//Ext.reg('datefield', Biorails.DateField); // Register as default datefield in Ext


//---------------------------------------- Select Field Widget--------------------------------------------------------

/**
 *  Biorails.SelectField 
 *
 * Custom Select field for a defined list of values
 */



Biorails.SelectField = function(id){    
    Biorails.SelectField.superclass.constructor.call(this,{
		typeAhead: true,
        triggerAction: 'all',
        transform: id,
        forceSelection:true        
        }); 
};

Ext.extend(Biorails.SelectField,  Ext.form.ComboBox, {});

//---------------------------------------- Conbo Field Widget--------------------------------------------------------
Ext.namespace("Biorails.ComboField");
/**
 * Custom Select field for a remote data element field
 */
Biorails.ComboField = function(id, element_id){    
    Biorails.ComboField.superclass.constructor.call(this,{
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

//---------------------------------------- Simple  HTML Editor -------------------------------------------------
Ext.namespace("Biorails.HtmlField");

Biorails.HtmlField = function(id){
    Biorails.HtmlField.superclass.constructor.call(this,{
         applyTo: id,
         enableFontSize: true,
         enableFormat: true,
         enableLists: true,
         enableColours:true
    });
}

Ext.extend(Biorails.HtmlField,  Ext.form.HtmlEditor, {});
//----------------------------------------  HTML Word processor -------------------------------------------------
Ext.namespace("Biorails.DocumentField");

Biorails.DocumentField = function(id){
    Biorails.DocumentField.superclass.constructor.call(this,{
         applyTo: id,
         enableFontSize: true,
         enableFormat: true,
         enableLists: true,
         enableColours:true
    });
}

Ext.extend(Biorails.DocumentField,  Ext.form.HtmlEditor, {});
//---------------------------------------- Model Grid ----------------------------------------------------------
Ext.namespace("Biorails.DataGrid");
/**
Ext.namespace("Biorails.DataGrid");
 * Dynamic DataGrid linked back to a rails controller driven query
 *
 * id: Grid id
 * title: Panel title
 * url: Name of controller url call
 * fields: 
 * filters:
 * columns: 
 */
Biorails.DataGrid.Folder = function(config){
      
     var _model_store = 
                    
     Biorails.DataGrid.Folder.superclass.constructor.call(this,{
                         border:false,
                         autoscroll: true,
                         autoDestroy: true,  
                         closable:true,
                         title: config.title,
                         id: config.id,
                         ds: new  Ext.data.GroupingStore({
                               remoteSort: true,
                               lastOptions: {params:{start: 0, limit: 25}},
                               sortInfo: {field: 'id', direction: 'ASC'},
                               proxy: new Ext.data.HttpProxy({ url: '/ext/'+config.controller, method: 'get' }),
                               reader: new Ext.data.JsonReader({
                                               root: 'items', totalProperty: 'total'}, 
                                               config.fields  )
                         }),
                         cm: new Ext.grid.ColumnModel(config.columns),
                         view: new Ext.grid.GroupingView(),
                         viewConfig: {forceFit:true},
                         plugins: new Ext.ux.grid.GridFilters( config.filters ),
 		                 bbar: new Ext.PagingToolbar({
				            pageSize: 25,
				            store: this.store,
				            displayInfo: true,
				            displayMsg: 'Displaying {0} - {1} of {2}',
				            emptyMsg: "No results to display"
				        })
     });
};

Ext.extend(Biorails.DataGrid,  Ext.grid.GridPanel);
//---------------------------------------- Folders Grid ----------------------------------------------------------
Ext.namespace("Biorails.Folder");
/*
 * Panel for handling a biorails folder display. This is basically a grid with some custom D&D code.
 * 
 */
Biorails.Folder = function(folder_id, title){  
       
     Biorails.Folder.superclass.constructor.call(this,{
           border:false,
           autoscroll: true,
           autoDestroy: true,  
           closable:true,
           folder_id: folder_id,
           title: title,
           id: 'folder-grid-'+folder_id,
           ds:  new Ext.data.GroupingStore({
               remoteSort: true,
               sortInfo: {field: 'left_limit', direction: 'ASC'},
               proxy: new Ext.data.HttpProxy({ url: '/folders/grid/'+folder_id, method: 'get' }),
               reader: new Ext.data.JsonReader({
                             root: 'items', totalProperty: 'total'}, [
                                   {name: 'id', type: 'int'},
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
                        }),
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
           viewConfig: {forceFit:true},
           tbar:[{
                    text:'Add File',
                    tooltip:'Add a image or other file to the folder',
                    href: '/asset/new/'+folder_id, 
                    handler: this.toolbarClick,                               
                    iconCls:'icon-file'
                }, {
                    text:'Add Article',
                    tooltip:'Add some textual content to the folder',
                    href: '/content/new/'+folder_id,                              
                    handler: this.toolbarClick,                               
                    iconCls:'icon-note'
                }, {
                    text:'Add Sub-folder',
                    tooltip:'Add a new sub folder',
                    href: '/folders/new/'+folder_id,                                
                    handler: this.toolbarClick,                               
                    iconCls:'icon-folder'
                }, '-', {
                    text:'Preview',
                    tooltip:'Preview',
                    href: '/folders/print/'+folder_id,                                
                    handler : function(item){
                        window.open(item.href);
                    }, 
                    iconCls:'icon-print'
                },'-',{
                    text:'Print',
                    tooltip:'Print the folder as a report',
                    href: '/folders/print/'+folder_id+'?format=pdf',                                
                    handler : function(item){
                        window.open(item.href);
                    },                               
                    iconCls:'icon-pdf'
                }]
         });
        this.store.load({params:{start: 0, limit: 50}});
 
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
    resync: function(request){
       this.store.load();
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
   onRender: function(){
            Biorails.Folder.superclass.onRender.apply(this, arguments);
       try{ 
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

//------------------ Report Definition -------------------------------------------------------------------
Ext.namespace('Biorails.Report');

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
