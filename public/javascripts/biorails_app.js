/**
 * @author rshell
 */
 Ext.namespace('Biorails');
 
 Biorails = function(){
    var layout;
    var toolbar;
    var folder_data;
    var folder_ds;
    var root;	
    var grid;
    
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
        {header: "Elements", width: 700, sortable: true, renderer: renderDocument, locked: false,  dataIndex: 'id'}
    ]);

    var cmOutline = new Ext.grid.ColumnModel([
        {header: "Icon", width: 75, sortable: true, renderer: renderIcon,   dataIndex: 'icon'},
        {header: "Element", width: 500, sortable: true, renderer: renderOutline , locked: false,  dataIndex: 'id'},
        {header: "Actions", width: 75, sortable: true,  dataIndex: 'actions'}
    ]);

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
// Builder the standard toolbar with menus and search functions
//    
    function buildToolbar(container,title,home_items,project_items,admin_items){
       toolbar = new Ext.Toolbar(container);

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

       toolbar.addField(
                   new Ext.form.TextField({
                    fieldLabel: 'search',
                    name: 'first',
                    width:175,
                    allowBlank:false
                }));
       toolbar.addButton({text: 'search'})          
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
                titlebar: true,
                collapsible: true,
                animate: true,
                autoScroll:false,
                useShim:true,
                collapsed:true,
                cmargins: {top:0,bottom:2,right:2,left:2},
                collapsedTitle: 'Menu'
                
            },
            east: {
                split:true,
                initialSize: 200,
                minSize: 100,
                maxSize: 400,
                titlebar: true,
                collapsed: true,
                collapsible: true,
                autoScroll: true,
                animate: true
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
                autoScroll:true,
                closeOnTab: true
            }
        });

        layout.beginUpdate();
        layout.add('north', new Ext.ContentPanel('header', 'North'));
        layout.add('south', new Ext.ContentPanel('footer', {title: 'Message', closable: false}));

        layout.add('west', new Ext.ContentPanel('left', {title: 'Menu', closable: false}));

        layout.add('east', new Ext.ContentPanel('right', {title: 'Help', collapsedTitle: 'Help', closable: false}));

        layout.add('center', new Ext.ContentPanel('center', {title: title, closable: false}));

        layout.getRegion('center').show();
        layout.getRegion('west').show();
        layout.restoreState();
        layout.endUpdate();        
    };
return {
    getLayout: function() { return layout},
    
    getToolbar: function() { return toolbar},
    
    init: function(container,title,home_items,project_items,admin_items) { 
        buildLayout(title);
        buildToolbar(container,title,home_items,project_items,admin_items);
    },
    
    resync: function(data){
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
    
    // Setup a folder Data source
    // data = json for folder
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
            autoExpandColumn: 'id',
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
                         onComplete: function(req){Biorails.resync(eval(req.responseText))} }); 
                      
                   } else if (data.node) {
                     console.log("src node="+data.node.id);
					 var dest = folder_ds.getAt( 0 )
					 if (rows[0]) { dest = rows[0]; };
                     console.log("dest node="+dest.id );
                     new Ajax.Request("/folders/add_element/"+
                          data.node.id+"?before="+ dest.id+'&format=json',
                        {asynchronous:true, 
                         onComplete: function(req){Biorails.resync(eval(req.responseText))} }); 
                   };
				   } catch (e) {
				   	  console.log('Problem with drop ')
					  console.log(e);
				   };
                   return true;
                }
         });
        dropZone.addToGroup("ColumnDD"); 
        
        var tabs = new Ext.TabPanel('tabs1');
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
