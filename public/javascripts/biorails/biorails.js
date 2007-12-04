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
             {text: 'Help',menu : {items: [{text: "Help",  scope: this } ]}},
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
         
    this.on('blur',function(field){
              field.save();
        });
    this.on('focus',function(field){
              field.entry();
        });
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
	},

   save: function(){
            if ( this.url && (_original_value != this.getValue() ) ) {
              var element=this.getEl().dom;
              new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
              var save_url = this.url+'?element='+element.id;
              new Ajax.Request(save_url,
                  {asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
            }
          },
          
    entry: function(){
         var element=this.getEl().dom;
         _original_background = element.style.background;
         _original_value = this.getValue();
         }              
                 
});
//Ext.reg('datefield', Biorails.DateField); // Register as default datefield in Ext


//---------------------------------------- Select Field Widget--------------------------------------------------------

/**
 *  Biorails.SelectField 
 *
 * Custom Select field for a defined list of values
 */



Biorails.SelectField = function(config){   
     
    Biorails.SelectField.superclass.constructor.call(this,Ext.apply(config,{
		typeAhead: true,
        triggerAction: 'all',
        forceSelection:true        
        }));
         
    this.on('change',function(field){
              field.save();
        });
    this.on('focus',function(field){
              field.entry();
        });     
};

Ext.extend(Biorails.SelectField,  Ext.form.ComboBox, {

     save: function(){
            if ( this.url && (_original_value != this.getValue() ) ) {
              var element=this.getEl().dom;
              new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
              var save_url = this.url+'?element='+element.id;
              new Ajax.Request(save_url,
                  {asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
            }
          },
          
     entry: function(){
         var element=this.getEl().dom;
         _original_background = element.style.background;
         _original_value = this.getValue();
         }              
                 
});

//---------------------------------------- Conbo Field Widget--------------------------------------------------------
Ext.namespace("Biorails.ComboField");
/**
 * Custom Select field for a remote data element field
 */
Biorails.ComboField = function(config){    
    Biorails.ComboField.superclass.constructor.call(this,Ext.apply(config,{
		 mode:'remote',
         store: new Ext.data.Store({
                   proxy: new Ext.data.HttpProxy({
                            url: '/admin/element/select/'+config.root_id, method: 'get' 
                          }),
         reader: new Ext.data.JsonReader({
								root: 'items', 
								totalProperty: 'total'},
								 [ {name: 'id', type: 'int'},
								   {name: 'name'},
								   {name: 'description'}]  )
                    }),
         triggerAction: 'all',
		 forceSelection: false,
		 editable: true,
         loadingText: 'Looking Up Name...',
         selectOnFocus: false,
		 valueField: 'name',
		 displayField: 'name'
         })); 
         
        this.on('blur',function(field){
              field.save();
        });
        this.on('focus',function(field){
              field.entry();
        });
      
};

Ext.extend(Biorails.ComboField,  Ext.form.ComboBox, {

     save: function(){
            if ( this.url && (_original_value != this.getValue() ) ) {
              var element=this.getEl().dom;
              new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
              var save_url = this.url+'?element='+element.id;
              new Ajax.Request(save_url,
                  {asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
            }
          },
          
     entry: function(){
         var element=this.getEl().dom;
         _original_background = element.style.background;
         _original_value = this.getValue();
         }              
                 
});

//Ext.reg('datefield', Biorails.DateField); // Register as default datefield in Ext

//---------------------------------------- Conbo Field Widget--------------------------------------------------------
Ext.namespace("Biorails.FileComboField");
/**
 * Custom Select field for a remote data element field
 */
Biorails.FileComboField = function(config){ 
    var _original_value = null;
    var _original_background = null;   
    Biorails.FileComboField.superclass.constructor.call(this,Ext.apply(config,{
		 mode:'remote',
         store: new Ext.data.Store({
                   proxy: new Ext.data.HttpProxy({
                            url: '/folders/select/'+config.folder_id, method: 'get' 
                          }),
                   reader: new Ext.data.JsonReader({
                                            root: 'items', 
                                            totalProperty: 'total'},
                                             [ {name: 'id', type: 'int'},
                                               {name: 'name'},
                                               {name: 'path'},
                                               {name: 'icon'}]  )
                    }),
         triggerAction: 'all',
		 forceSelection: false,
		 editable: true,               
         loadingText: 'Searching...',
		 valueField: 'id',
		 displayField: 'name',
         tpl: new Ext.XTemplate(
                '<tpl for="."><div class="x-combo-list-item">',
                '<image src="{icon}"/>',
                '<em>{name}</em>:   <strong>{path}</strong>',
                '<div class="x-clear"></div>',
                '</div></tpl>')       
         })); 
        this.on('blur',function(field,newValue,oldValue){
              field.save();
        });
        this.on('focus',function(field){
                 field.entry();
        });
      
};

Ext.extend(Biorails.FileComboField,  Ext.form.ComboBox, {


     save: function(){
            if ( this.url && (_original_value != this.getValue() ) ) {
              var element=this.getEl().dom;
              new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
              var save_url = this.url+'?element='+element.id;
              new Ajax.Request(save_url,
                  {asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
            }
          },
          
     entry: function(){
         var element=this.getEl().dom;
         _original_background = element.style.background;
         _original_value = this.getValue();
         }                        
        
    });

//---------------------------------------- Simple  HTML Editor -------------------------------------------------
Ext.namespace("Biorails.HtmlField");

Biorails.HtmlField = function(id){
    Biorails.HtmlField.superclass.constructor.call(this,{
         id: id,
         applyTo: id,
         autoWidth : true,
         height: 300,
         enableFormat: true,
         enableLists: true,
         enableFontSize: false,
         enableLinks:  false,
         enableSourceEdit: false,
         enableColours: false
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
         enableLinks: true,
         minHeight: 400,
         height: 600,
         autoWidth : true,
         enableSourceEdit: true,
         enableColours:true
    });
}

Ext.extend(Biorails.DocumentField,  Ext.form.HtmlEditor, {});

//----------------------------------------  Biorails Conceptural Tree ---------------------------------------------
Ext.namespace("Biorails.ConceptTree");

Biorails.ConceptTree = function(el){
    
    Biorails.ConceptTree.superclass.constructor.call(this,{
			el: el,
            title:'Namespace (Concepts)',
            minHeight: 400,
            autoShow: true, 
            autoHeight:true,
            autoScroll:true,
            layout: 'fit',           
			animate:true,
			enableDD:false,
            iconCls:'icon-catalogue', 
            root:  new Ext.tree.AsyncTreeNode({   text: 'Biorails',
                                                  expanded: true,  
                                                  draggable:false, id: '1' }),
			loader: new Ext.tree.TreeLoader({ dataUrl:'/admin/catalogue/tree'	})
		});
                
        this.on('click',function(node){
               try{ 
                    new Ajax.Request(node.attributes.url,{asynchronous:true, evalScripts:true});  
                } catch (e) {
                      Ext.log('Problem with click on tree node ');
                      Ext.log(e);
                } 
        });                     
}

Ext.extend(Biorails.ConceptTree,  Ext.tree.TreePanel, {} );


//---------------------------------------- Report Definition ------------------------------------------------

Ext.namespace("Biorails.ReportDef");

Biorails.ReportDef = function(report_id){
    var grid = null;  
    var column_record;
    var column_store;
    var column_model;
    var report_form;

    /** 
     * Red/Green Custom renderer function
     * renders red if <0 otherwise renders green 
     * @param {Object} val
     */
    function renderBoolean(v, p, record){
      var checkState = (+v) ? '-on' : '';
      p.css += ' x-grid3-check-col-td'; 
      return '<div class="x-grid3-check-col'+ checkState +' x-grid3-cc-'+this.id+'"> </div>';
    };
    function renderId(val){
      return '<img alt="remove" src="/images/action/cancel.png"/>';
    };
  
    function cellClicked( grid, rowIndex,  columnIndex, event){
      if (columnIndex == 7){
         var record = column_store.getAt(rowIndex);
         deleteRow(record);
      }
    };
    // Delete a Columns row from the report
    function deleteRow(record) {
      Ext.Ajax.request( {  
            waitMsg: 'Deleting row...',
            url: '/reports/remove_column',
            method: 'POST',
            params: {
                  id: record.data.id
              },
            failure: function(response, options){
                  Ext.MessageBox.alert('Warning','Failed to remove column from report...');
              },                                  
            success: function(response, options){
                  column_store.remove(record);
              }                             
           }
      ); 
    };
    /**
     * Function for updating database
     * @param {Object} event
     */
    function updateRow(event) {
        if (event.value instanceof Date)
        {   //format the value for easy insertion into MySQL
           var fieldValue = event.value.format('Y-m-d H:i:s');
        } else
        {
           var fieldValue = event.value;
        }	
        Ext.Ajax.request( {  
              waitMsg: 'Saving changes...',
                url: '/reports/update_column',
                //method: 'POST', //if specify params default is 'POST' instead of 'GET'
                params: { //these will be available via $_POST or $_REQUEST:
                    id: event.record.data.id,
                    column: {id: event.record.data.id},
                    field: event.field,
                    value: event.value,
                    originalValue: event.record.modified                                                                                                                              //when the response comes back from the server can we make an undo array?                         
                },//end params
                failure: function(response, options){
                    Ext.MessageBox.alert('Warning','Failed to update report...');
                    column_store.rejectChanges();
                },//end failure block                                      
                success: function(response, options){
                    column_store.commitChanges();
                }//end success block                                      
             }//end request config
        ); //end request  
    };

    function setupRecord(){
        if (!column_record)
        {
            column_record = Ext.data.Record.create([
              {name: 'id'},
              {name: 'name'},
              {name: 'label'},
              {name: 'filter'},
              {name: 'is_filterable'},
              {name: 'is_visible'},
              {name: 'is_sortable'},
              {name: 'sort_num'},
              {name: 'sort_dir'}]
           );
        }
    };

    function setupStore(report_id){
        if (!column_store) {
            column_store = new Ext.data.Store({
              proxy: new Ext.data.HttpProxy({url: '/reports/layout/'+report_id}),

              reader: new Ext.data.JsonReader({
                  root: 'items',
                  totalProperty: 'total',
                  id: 'id'
                 },column_record),        
              remoteSort: true	
            })
        }
    };

    function setupColumns(){
        if (!column_model)
        {
           // Column model for report definition with label,filter and sort changable

           column_model = new Ext.grid.ColumnModel([
              { header: "Name",  
                width: 120, 
                sortable: true,
                dataIndex: 'name'
              },        
              { header:'Visible',  
                width:32, 
                renderer: renderBoolean,
                editor: new Ext.form.Checkbox(),
                dataIndex:'is_visible'
              },
              { header: "Label",  
                width: 120, 
                sortable: true,
                editor: new Ext.form.TextField({
                  allowBlank: false
                }),
                dataIndex: 'label'
              },
              { header:'Filterable',  
                width:45, 
                renderer: renderBoolean,
                editor: new Ext.form.Checkbox(),
                dataIndex:'is_filterable'
              },
              { header: "Filter",    
                width: 120, 
                sortable: true, 
                editor: new Ext.form.TextField(),
                dataIndex: 'filter'
              },
              { header:'Sortable',  
                width:40, 
                renderer: renderBoolean,
                editor: new Ext.form.Checkbox(),
                dataIndex:'is_sortable'
              },
              { header: "Dir",   
                width: 50, 
                editor: new Ext.form.ComboBox({
                  typeAhead: true,
                  triggerAction: 'all',
                  transform:'sort_dir_select',
                  lazyRender:true,
                  listClass: 'x-combo-list-small' }), 
                dataIndex: 'sort_dir'},
              { id:'Id', 
                header: "Remove", 
                width: 20, 
                sortable: true, 
                renderer: renderId,
                dataIndex: 'id'
              }

            ]);

            column_model.defaultSortable =true;
       };
    };

    function setupGrid(){
         grid = new Ext.grid.EditorGridPanel({
            renderTo: 'column-grid',
            store: column_store,        
            cm:    column_model ,
            viewConfig: {  forceFit: true  },
            sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
            width:'auto',
            height:300,
            frame:true,
            title:'Drag columns from tree to add to report',
            iconCls:'icon-grid'
         });
         grid.store.load();
         grid.addListener('afteredit', updateRow);
         grid.addListener('cellclick', cellClicked);
    };

     setupRecord();
     setupStore(report_id);
     setupColumns();
     setupGrid();       
};  


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
       try{ 
            var dropzone = new Ext.dd.DropTarget(this.id, {
                ddGroup : 'GridDD',
                folder_id: this.folder_id,
                grid: this,
                notifyDrop : this.droppedItem  });
             dropzone.addToGroup("ClipboardDD"); 
             dropzone.addToGroup("TreeDD"); 
        } catch (e) {
              Ext.log('Problem with setup drop zone on folder grid ');
              Ext.log(e);
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
