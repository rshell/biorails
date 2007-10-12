/**
 * Core Javascript Application Framework for Biorails 3.0
 * 
 * This is licenced on the same GNU 2.0 licence as the rest of biorails.
 * It manages the overall border layout of frames and the folder grid, and folder tree.
 * Other call return data into the centre panel
 * 
 * @author rshell@biorails.org
 */
 Ext.namespace('Biorails');
 
 Biorails = function(){
// 
// Private state values
//    
    var layout;
	var tree_panel;
	var help_panel;
	var context_panel;
	var centre_panel;
	
    var toolbar;

    var folder_data;
    var folder_ds;

    var root;	
    var grid;
	var tree;

    var folderRecord = Ext.data.Record.create([
               {name: 'id', type: 'int'},
               {name: 'icon'},
               {name: 'name'},
               {name: 'description'},
               {name: 'updated_by'},
               {name: 'updated_at', type: 'date', dateFormat: 'Y-m-d H:i:s'},
               {name: 'actions'},
               {name: 'html'}]);
// 
// Key search field from the toolbar
//    	
	var searchField = new Ext.form.TextField({
                    fieldLabel: 'search',
                    name: 'first',
                    width:175,
                    allowBlank:false});
// 
// Private Rendering functions for the Grid
//    
    function renderIcon(val){
        return '<img src="' + val + '" />';
    };

    function renderIndex(val,cell,record,row,col,ds){
        return row;
    };

    function renderOutline(val,cell,record,row,col,ds){
        return record.get('name')+'<br />'+record.get('description');
    };

    function renderDocument(val,cell,record,row,col,ds){
        return record.get('html');
    };

    function onSearchClick(btn){
		layout.getRegion('east').showPanel('context');   
		Ext.get("context").load({
		        url: "/finder/search?text="+searchField.getValue(),
		        text: "Searching..."
		   });
    }
//
// Column formats for the Grid display
//	
    var cmFolder = new Ext.grid.ColumnModel([
        {header: "Icon", width: 32, sortable: true, renderer: renderIcon,   dataIndex: 'icon'},
        {header: "Name", width: 100, sortable: true,  dataIndex: 'name'},
        {header: "Description", width: 300, sortable: true,   dataIndex: 'description'},
        {header: "Updated By", width: 85, sortable: true,  dataIndex: 'updated_by'},
        {header: "Updated At", width: 85, sortable: true, renderer: Ext.util.Format.dateRenderer('d/m/Y'), 
         dataIndex: 'updated_at'},
        {header: "Actions", width: 75,   dataIndex: 'actions'}
    ]);
    var cm = cmFolder;

    var cmDocument = new Ext.grid.ColumnModel([
        {header: "Elements", width: 700, sortable: true, renderer: renderDocument, locked: false,  dataIndex: 'description'}
    ]);

    var cmOutline = new Ext.grid.ColumnModel([
        {header: "Icon", width: 75, sortable: true, renderer: renderIcon,   dataIndex: 'icon'},
        {header: "Element", width: 500, sortable: true, renderer: renderOutline , locked: false,  dataIndex: 'description'},
        {header: "Actions", width: 75, sortable: true,  dataIndex: 'actions'}
    ]);

//
// Private builder functions to create UI
//
// Builder the standard toolbar with menus and search functions
//    
    function buildToolbar(container,title,home_items,project_items,admin_items){
       toolbar = new Ext.Toolbar(container);
       toolbar.addText("<a href='http:/auth/logout'><image src='/images/icon_exit.png'/></a>")          

       toolbar.addButton({
               cls: 'x-btn-text-icon bmenu', 
  	       text:'Home',
               menu: new Ext.menu.Menu({
                             id: 'menuHome',
                             items: home_items })
                         });

       toolbar.addButton({
               cls: 'x-btn-text-icon bmenu', 
  	       text:'Project ['+title+']',
               menu: new Ext.menu.Menu({
                             id: 'menuProject',
                             items: project_items })
                         });

       toolbar.addButton({
               cls: 'x-btn-text-icon bmenu', 
  	       text:'Administration',
               menu: new Ext.menu.Menu({
                             id: 'menuAdmin',
                             items: admin_items })
                         });
    
       toolbar.addFill();

       toolbar.addField(searchField);
       toolbar.addButton({text: 'search',handler: onSearchClick})          
     }; 
//
// Builder the Layout
//        
    function buildLayout(title){
       Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
       
       layout = new Ext.BorderLayout(document.body, {
            north: {
                split:false,
                initialSize: 32,
                titlebar: false
            },
            west: {
                split:true,
                initialSize: 150,
                minSize: 100,
                maxSize: 400,
                autoScroll:false,
				titlebar: true,
                collapsible: true,
                animate: true,
                useShim:true,
                cmargins: {top:2,bottom:2,right:2,left:2}           
            },
            east: {
                split:true,
                initialSize: 220,
                minSize: 100,
                maxSize: 400,
                titlebar: true,
                collapsed: true,
                collapsible: true,
                autoScroll: true,
                animate: true,
				tabPosition: 'bottom',
                alwaysShowTabs: true,
                resizeTabs: true
            },
            south: {
                split:true,
                initialSize: 100,
                minSize: 50,
                maxSize: 400,
                titlebar: true,
                collapsible: true,
                animate: true
            },
            center: {
                titlebar: true,
                autoScroll:true
            }
        });

        layout.beginUpdate();
        layout.add('north', new Ext.ContentPanel('header'));
        layout.add('south', new Ext.ContentPanel('footer', {title: 'Message', fitToFrame:true, closable: false}));

        layout.add('west', new Ext.ContentPanel('left', {title: 'Menu',fitToFrame:true, closable: false}));
        
		tree_panel   = new Ext.ContentPanel('tree',{  autoCreate:true, title: 'Tree', closable: true});
	    help_panel   = new Ext.ContentPanel('right', {title: 'Info',fitToFrame:true, closable: false});
	    context_panel= new Ext.ContentPanel('context',{autoCreate:true, title: 'Work', closable: true});
	    centre_panel = new Ext.ContentPanel('center', {title: title,fitToFrame:true, closable: false});
        
		//tree_panel.on('activate', function(){
		//	new Ajax.Request("/projects/tree?format=json",
        //        {asynchronous:true, 
        //         onComplete: function(req){
		//		 	console.log("got data");
		//			console.log(req.responseText);
		//		 	Biorails.resyncTree(eval(req.responseText));
		//	     } }); 
		//      });
		
		layout.add('east', tree_panel);
        layout.add('east', context_panel);
        layout.add('east', help_panel);
        layout.add('center', centre_panel);

        layout.restoreState();
        layout.endUpdate();        
    };
//
// Public functions for the module
//	
return {
//
// Get the overall arrangement of the application
//	
    getLayout: function() { return layout},	
//
// Get the right hand tree control of the application
//	
    getTree: function() { return tree},
//
// Get the top toolbar of the application
//	
    getToolbar: function() { return toolbar},
//
// Initialize the Application
//    
    init: function(container,title,home_items,project_items,admin_items) { 
	  try {
        buildLayout(title);
        buildToolbar(container,title,home_items,project_items,admin_items);
	} catch (e) {
   	  console.log('Problem with initialization ');
	  console.log(e);
	};

    },
//
// Resync the current grid data 
//    
    resyncGrid: function(data){
		try {
        folder_ds = new Ext.data.Store({
            proxy: new Ext.data.MemoryProxy(data),

            reader: new Ext.data.ArrayReader( {id:0}, folderRecord)
        });
        folder_ds.load();
        grid.reconfigure(folder_ds, cm);
	   } catch (e) {
	   	  console.log('Problem with resync ')
		  console.log(e);
	   };
    },
//
// Builder a Tree from the given json data
//	 
    resyncTree: function(json){
		try {
		  	
		  if (tree == null)
		  {
             tree = new Ext.tree.TreePanel('tree-root', {
                  animate:true,
                  enableDD:false,
                  loader: new Ext.tree.TreeLoader(), 
                  lines: true,
                  selModel: new Ext.tree.MultiSelectionModel(),
                  containerScroll: false });
		  };
	      var root = new Ext.tree.AsyncTreeNode(json);		  
	      tree.setRootNode(root);
	      tree.render();
	      root.expand();		  	
	   } catch (e) {
	   	  console.log('Problem with resync ')
		  console.log(e);
	   };
    },	
//
// Setup a folder Data source
// data = json for folder
//
    folder: function(data) {
        folder_ds = new Ext.data.Store({
            proxy: new Ext.data.MemoryProxy(data),

            reader: new Ext.data.ArrayReader( {id:0}, folderRecord)
        });
        folder_ds.load();
                       
        var mySelectionModel= new Ext.grid.RowSelectionModel({singleSelect:true});
        
        grid = new Ext.grid.Grid('grid-folder', {
            ds: folder_ds,
            cm: cm,
            selModel: mySelectionModel,
            autoSizeColumns: true,
            autoWidth: false,
	    	enableDragDrop: true,
            ddGroup:"GridDD"
        });

          var dropZone = new Ext.dd.DropTarget(grid.container, {
             ddGroup:"GridDD",
             copy:false,
             notifyDrop : function(dd, e, data){
			   try {
                   console.log('notifyDrop');
                   var sm=grid.getSelectionModel();
                   var rows=sm.getSelections();

                   if (data.rowIndex)   {
                     var source = folder_ds.getAt( data.rowIndex );
                     var dest = folder_ds.getAt( dd.getDragData(e).rowIndex );
                     console.log("src  id="+source.id);
                     console.log("dest id="+dest.id);
                     new Ajax.Request("/folders/reorder_element/"+
                          source.id+"?before="+ dest.id+'&format=json',
                        {asynchronous:true, 
                         onComplete: function(req){Biorails.resyncGrid(eval(req.responseText))} }); 
                      
                   } else if (data.node) {
                     console.log("src node="+data.node.id);
					 var dest = folder_ds.getAt( 0 )
					 if (rows[0]) { dest = rows[0]; };
                     console.log("dest node="+dest.id );
                     new Ajax.Request("/folders/add_element/"+
                          data.node.id+"?before="+ dest.id+'&format=json',
                        {asynchronous:true, 
                         onComplete: function(req){Biorails.resyncGrid(eval(req.responseText))} }); 
                   };
				} catch (e) {
				   	  console.log('Problem with drop ');
					  console.log(e);
				};
                return true;
             }
         });
        dropZone.addToGroup("ColumnDD"); 
        
        var tabs = new Ext.TabPanel('tabs-folders');
        var tab1 = tabs.addTab('tab-show', "Folder");        
        var tab2 = tabs.addTab('tab-layout', "Outline");
        var tab3 = tabs.addTab('tab-document', "Preview");

        tabs.activate('tab-show');
        tab1.on('activate', function(){  cm = cmFolder; grid.reconfigure(folder_ds,cm)    });
        tab2.on('activate', function(){  cm = cmOutline; grid.reconfigure(folder_ds,cmOutline)    });
        tab3.on('activate', function(){  cm = cmDocument; grid.reconfigure(folder_ds,cmDocument)    });
        grid.render();
        var dragZone = new Ext.grid.GridDragZone(grid, {containerScroll:true, ddGroup: 'GridDD'});        
    }
 };       
}();
