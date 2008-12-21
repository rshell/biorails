//---------------------------------------- Folders Document ----------------------------------------------------------

Ext.namespace("Biorails");

Ext.namespace("Biorails.Document");
/*
 * Panel for handling a biorails folder display. This is basically a grid with some custom D&D code.
 */

Biorails.Document = function(config){
    var toolbar = null;
    if (config.frozen) {
        toolbar = [{
            text:'Access',
            tooltip:'Change Access Control Rules',
            href: '/acl/edit/'+config.folder_id,
            handler : function(item){
                window.location = item.href;
            },
            iconCls:'icon-team'
        }, '-', {
            text:'Folder',
            tooltip:'Show as Folder',
            folder_id: config.folder_id,
            handler : function(item){
                window.location = '/folders/show/'+config.folder_id
            },
            iconCls:'icon-folder-view'
        },'-', {
            text:'Preview',
            tooltip:'Preview',
            href: '/folders/print/'+config.folder_id,
            handler : function(item){
                window.open(item.href);
            },
            iconCls:'icon-print-preview'
        },'-',{
            text:'Sign',
            tooltip:'Sign as the author',
            href: '/signatures/new/'+config.folder_id,
            handler : function(item){
                window.location = item.href;
            },
            iconCls:'icon-sign'
        },'-',{
            text:'Print',
            tooltip:'Print the folder as a report',
            href: '/folders/print/'+config.folder_id+'?format=pdf',
            handler : function(item){
                window.open(item.href);
            },
            iconCls:'icon-pdf'
        }];
    } else {
        toolbar = [{
            text:'Add File',
            tooltip:'Add a image or other file to the folder',
            href: '/asset/new/'+config.folder_id,
            handler: this.toolbarClick,
            iconCls:'icon-file-add'
        },'-', {
            text:'Add Article',
            tooltip:'Add some textual content to the folder',
            href: '/content/new/'+config.folder_id,
            handler: this.toolbarClick,
            iconCls:'icon-note-add'
        },'-', {
            text:'Add Sub-folder',
            tooltip:'Add a new sub folder',
            href: '/folders/new/'+config.folder_id,
            handler: this.toolbarClick,
            iconCls:'icon-folder-add'
        },'-', {
            text:'Access',
            tooltip:'Change Access Control Rules',
            href: '/acl/edit/'+config.folder_id,
            handler : function(item){
                window.location = item.href;
            },
            iconCls:'icon-team'
        }, '-', {
            text:'Folder',
            tooltip:'Show as Folder',
            folder_id: config.folder_id,
            handler : function(item){
                window.location = '/folders/show/'+config.folder_id
            },
            iconCls:'icon-folder-view'
        },'-', {
            text:'Preview',
            tooltip:'Preview',
            href: '/folders/print/'+config.folder_id,
            handler : function(item){
                window.open(item.href);
            },
            iconCls:'icon-print-preview'
        },'-',{
            text:'Sign',
            tooltip:'Sign as the author',
            href: '/signatures/new/'+config.folder_id,
            handler : function(item){
                window.location = item.href;
            },
            iconCls:'icon-sign'
        },'-',{
            text:'Print',
            tooltip:'Print the folder as a report',
            href: '/folders/print/'+config.folder_id+'?format=pdf',
            handler : function(item){
                window.open(item.href);
            },
            iconCls:'icon-pdf'
        }];
    };

    Biorails.Document.superclass.constructor.call(this, Ext.apply(config,{
        autoLoad: '/folders/document/'+config.folder_id+'?format=ext',
        id: 'folder-doc-'+config.folder_id,
        enableDragDrop: true,
        tbar: toolbar
    }));
};

Ext.extend(Biorails.Document,  Ext.Panel, {
    /*
     * Fire AJAX call for tool bar functions
     */    
    toolbarClick: function(item) {
        new Ajax.Request( item.href,  {
            asynchronous:true,
            evalScripts:true
        });
    },

    toolbarLink: function(item) {
        new Ajax.Request( item.href,  {
            asynchronous:true,
            evalScripts:true
        });
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
/**
 * Biorails.Folder.Store
 * @extends Ext.data.GroupingStore
 * This creates a local store for a folder
 */
Biorails.Folder.Store = function(config) {
    var config = config || {};
    Ext.applyIf(config, {
        remoteSort: true,
        reader: new Ext.data.JsonReader({
            root: 'items', 
            totalProperty: 'total'
        }, 
        [ { name: 'id',         type: 'int'},
          { name: 'icon'   },
          { name: 'position',   type: 'int' },
          { name: 'left_limit', type: 'int'  },
          { name: 'right_limit',type: 'int' },
          { name: 'name' },
          { name: 'preview_href'  },
          { name: 'html'},
          { name: 'path'},
          { name: 'href'},
          { name: 'summary' },        
          { name: 'reference_type'},        
          { name: 'owner' },        
          { name: 'state' },        
          { name: 'updated_by'  },
          { name: 'updated_at',   type: 'date',  dateFormat: 'Y-m-d H:i:s'},
          { name: 'actions' }]  )
    });
    // call the superclass's constructor 
    Biorails.Folder.Store.superclass.constructor.call(this, config);
};
Ext.extend(Biorails.Folder.Store, Ext.data.GroupingStore);


Biorails.Folder.GridPanel = function(config) {
    var config = config || {};
    Ext.applyIf(config, {
        folder_id: 1
    });
    // call the superclass's constructor 
    Biorails.Folder.GridPanel.superclass.constructor.call(this, config);

};
/**
 * Biorails.Folder.GridPanel
 * @extends Ext.grid.GridPanel
 * This is a custom grid which will display folder information. It is tied to 
 * a specific record definition by the dataIndex properties. 
 * 
 */
Biorails.Folder.GridPanel = Ext.extend(Ext.grid.GridPanel, {
    // override 
    initComponent : function() {
        Ext.apply(this, {
            cm: new Ext.grid.ColumnModel([
            {   header: "Pos",
                width: 50,
                sortable: true,
                renderer: this.renderNum,
                dataIndex: 'left_limit'
            },{ header: "Icon",
                width: 32,
                sortable: false,
                renderer: this.renderIcon,
                dataIndex: 'icon'
            },{ header: "Name",
                width: 100,
                sortable: true,
                renderer: this.renderName,
                dataIndex: 'name'
            },{ header: "Style",
                width: 75,
                sortable: true,
                dataIndex: 'reference_type'
            },{ header: "Summmary",
                width: 150,
                sortable: false,
                dataIndex: 'summary'
            },{ header: "State",
                width: 100,
                sortable: false,
                dataIndex: 'state'
            },{ header: "Updated By",
                width: 100,
                sortable: false,
                dataIndex: 'updated_by'
            },{ header: "Updated At",
                width: 85,
                sortable: true,
                renderer: Ext.util.Format.dateRenderer('d/m/Y'),
                dataIndex: 'updated_at'
            },{ header: "Actions",
                width: 200,
                dataIndex: 'actions'
            }]),
            loadMask: true,
            enableDragDrop: true,
            ddGroup : 'GridDD',
            view: new Ext.grid.GroupingView(),
            viewConfig: {
                forceFit:false
            },
            bbar: new Ext.PagingToolbar({
                pageSize: 15,
                store: this.store,
                autoWidth: true,
                displayInfo: true,
                displayMsg: 'Displaying {0} - {1} of {2}',
                emptyMsg: "No results to display"
            }),
            sm: new Ext.grid.RowSelectionModel({
                singleSelect: true
            }),
            // force the grid to fit the space which is available
            viewConfig: {
                forceFit: true
            }
        });
        // finally call the superclasses implementation
        Biorails.Folder.GridPanel.superclass.initComponent.call(this);		
        this.on('render',    function(grid){  
            grid.enableDD();
        });
    },
    renderIcon: function(val){
        if (val.match("^{.+}$")==null)
        {
            return '<img src="' + val + '"  />'
        }
        else 
        {
            it=eval('('+val+')');
            return "<img src='" + it.icon + "' onclick='showInPopup("+val+")'/>"
        }
		
    },
    renderName: function(item){
		
        if (item.match("^{.+}$")==null)
        {
            return(item);
        }
        else{
            it=eval('('+item+')');
            return "<a href='#' onclick='showInPopup(\""+it.url+"\")'/>"+it.title+"</a>"
        }
		
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
                    {
                        asynchronous:true,
                        onComplete: function(req) {
                            data.grid.store.load({
                                params:{sort: 'left_limit', dir:'ASC'}  });
                        } ,
                        parameters:'before='+dest_row.data.id+'&folder_id='+data.grid.folder_id
                    });
                         
            }
            // Test for case of a node from a folder tree 
            else if (data.node) {
                
                new Ajax.Request('/folders/add_element/'+data.node.id,
                {
                    asynchronous:true,
                    onComplete: this.grid.resync,
                    parameters:'folder_id='+this.folder_id
                });
            }  
        } catch (e) {
            console.log('Problem, cannot handle Dropped Item ');
            console.log(e);
        } 
        return true;  
    },
   
    /*
     * Custom Rendering function to add drop zone on grid after its rendered
     */    
    enableDD: function(){
        try {
            var dropzone = new Ext.dd.DropTarget(this.id, {
                ddGroup : 'GridDD',
                folder_id: this.folder_id,
                grid: this,
                notifyDrop : this.droppedItem
            });
            
            dropzone.addToGroup("ClipboardDD"); 
            dropzone.addToGroup("TreeDD"); 
        } catch (e) {
            console.log('Problem with setup drop zone on folder grid ');
            console.log(e);
        }        
    }
});
// This will associate an string representation of a class
// (called an xtype) with the Component Manager
// It allows you to support lazy instantiation of your components
Ext.reg('project_folder',Biorails.Folder.GridPanel);


Biorails.Folder.ElementPanel = function(config) {
    var config = config || {};
    Ext.applyIf(config, {
        folder_id: 1
    });
    // call the superclass's constructor 
    Biorails.Folder.ElementPanel.superclass.constructor.call(this, config);
};
/**
 * App.BookDetail
 * @extends Ext.Panel
 * This is a specialized Panel which is used to show information about
 * a book. 
 * 
 * This demonstrates adding 2 custom properties (tplMarkup and 
 * startingMarkup) to the class. It also overrides the initComponent
 * method and adds a new method called updateDetail.
 * 
 * The class will be registered with an xtype of 'bookdetail'
 */
Biorails.Folder.ElementPanel = Ext.extend(Ext.Panel, {
    // add tplMarkup as a new property
    detailMarkup: [
    '<a href="{href}" target="_blank">{path}</a>   {state_name}<br/>',
    'Summary: {summary}<br/>',
    'Update by {updated_by} on {updated_at}<br/>',
    '<div class="panel box"> {html} </div>'
    ],
    previewMarkup: [
    '<a href="{href}" target="_blank">{path}</a>   {state_name}<br/>',
    '{html}'
    ],

    // startingMarup as a new property
    startingMarkup: 'Please select a element to see additional details',
    // override initComponent to create and compile the template
    // apply styles to the body of the panel and initialize
    // html to startingMarkup
    initComponent: function() {
        this.detail = new Ext.Template(this.detailMarkup);
        this.preview = new Ext.Template(this.previewMarkup);
        Ext.apply(this, {
            bodyStyle: {
                background: '#ffffff',
                padding: '7px'
            },
            html: this.startingMarkup
        });
        // call the superclass's initComponent implementation
        Biorails.Folder.ElementPanel.superclass.initComponent.call(this);
    },
    // add a method which updates the details
    updateDetail: function(data) {
        this.detail.overwrite(this.body, data);
    //       var previewPanel = Ext.getCmp('status-id');
    //        this.preview.overwrite( previewPanel.body, data);
    }    
});
// register the App.BookDetail class with an xtype of bookdetail
Ext.reg('project_element',Biorails.Folder.ElementPanel);


/**
 * App.BookMasterDetail
 * @extends Ext.Panel
 * 
 * This is a specialized panel which is composed of both a bookgrid
 * and a bookdetail panel. It provides the glue between the two 
 * components to allow them to communicate. You could consider this
 * the actual application.
 * 
 */
Biorails.Folder.Panel = function(config) {
    var config = config || {};
    Ext.applyIf(config, {
        folder_id: 1
    });
    // call the superclass's constructor 
    Biorails.Folder.Panel.superclass.constructor.call(this, config);
};

Biorails.Folder.Panel = Ext.extend(Ext.Panel, {
    // override initComponent
    initComponent: function() {
        var toolbar= null;
        if (this.frozen) {
            toolbar =[{
                    text:'Access',
                    tooltip:'Change Access Control Rules',
                    href: '/acl/edit/'+this.folder_id,
                    handler : function(item){
                        window.location = item.href;
                    },
                    iconCls:'icon-team'
                },'-', {
                    text:'Document',
                    tooltip:'Show as Document',
                    xtype:'tbbutton',
                    folder_id: this.folder_id,
                    handler : function(item){
                        window.location = '/folders/document/'+this.folder_id
                    },
                    iconCls: 'icon-document-view'
                }, '-', {
                    text:'Preview',
                    tooltip:'Preview',
                    xtype:'tbbutton',
                    href: '/folders/print/'+this.folder_id,
                    handler : function(item){
                        window.open(item.href);
                    },
                    iconCls: 'icon-print-preview'
                },'-',{
                    text:'Sign',
                    tooltip:'Sign as the author',
                    href: '/signatures/new/'+this.folder_id,
                    handler : function(item){
                        window.location = item.href;
                    },
                    iconCls:'icon-sign'
                },'-',{
                    text:'Print',
                    xtype:'tbbutton',
                    tooltip:'Print the folder as a report',
                    href: '/folders/print/'+this.folder_id+'?format=pdf',
                    handler : function(item){
                        window.open(item.href);
                    },
                    iconCls:'icon-pdf'
                }]
        } else {
            toolbar = [{
                    text:'Add File',
                    xtype:'tbbutton',
                    tooltip:'Add a image or other file to the folder',
                    href: '/asset/new/'+this.folder_id,
                    handler: this.toolbarClick,
                    iconCls: 'icon-file-add'
                },'-', {
                    text:'Add Article',
                    tooltip:'Add some textual content to the folder',
                    xtype:'tbbutton',
                    href: '/content/new/'+this.folder_id,
                    handler: this.toolbarClick,
                    iconCls: 'icon-note-add'
                },'-', {
                    text:'Add Sub-folder',
                    tooltip:'Add a new sub folder',
                    xtype:'tbbutton',
                    href: '/folders/new/'+this.folder_id,
                    handler: this.toolbarClick,
                    iconCls: 'icon-folder-add'
                },'-', {
                    text:'Access',
                    tooltip:'Change Access Control Rules',
                    href: '/acl/edit/'+this.folder_id,
                    handler : function(item){
                        window.location = item.href;
                    },
                    iconCls:'icon-team'
                },'-', {
                    text:'Document',
                    tooltip:'Show as Document',
                    xtype:'tbbutton',
                    folder_id: this.folder_id,
                    handler : function(item){
                        window.location = '/folders/document/'+this.folder_id
                    },
                    iconCls: 'icon-document-view'
                }, '-', {
                    text:'Preview',
                    tooltip:'Preview',
                    xtype:'tbbutton',
                    href: '/folders/print/'+this.folder_id,
                    handler : function(item){
                        window.open(item.href);
                    },
                    iconCls: 'icon-print-preview'
                },'-',{
                    text:'Sign',
                    tooltip:'Sign as the author',
                    href: '/signatures/new/'+this.folder_id,
                    handler : function(item){
                        window.location = item.href;
                    },
                    iconCls:'icon-sign'
                },'-',{
                    text:'Print',
                    xtype:'tbbutton',
                    tooltip:'Print the folder as a report',
                    href: '/folders/print/'+this.folder_id+'?format=pdf',
                    handler : function(item){
                        window.open(item.href);
                    },
                    iconCls:'icon-pdf'
                }]
        };
        _store = new Biorails.Folder.Store({ 
            folder_id: this.folder_id,
            sortInfo: {
                params:{
                    sort: 'left_limit',
                    dir:'ASC'
                }
            },
            lastOptions: {
                params:{
                    sort: 'left_limit',
                    dir:'ASC',  
                    start: 0, 
                    limit: 15
                }
            },
            proxy: new Ext.data.HttpProxy({
                url: '/folders/grid/'+this.folder_id,
                method: 'post'
            }),
            storeId:'folderStore'
        }),
        // used applyIf rather than apply so user could
        // override the defaults
        Ext.applyIf(this, {
            frame: true,
            title: 'Folder',
            width: 700,
            height: 500,
            layout: 'border',
            store: _store,
            tbar:  new Ext.Toolbar({ autoWidth: true, items: toolbar }),
            items: [{
                xtype: 'project_folder',
                itemId: 'gridPanel',
                folder_id: this.folder_id,
                store: _store,
                region: 'north',
                autoWidth: true,
                height: 400,
                split: true
            },{
                xtype: 'project_element',
                store: _store,
                autoWidth: true,
                itemId: 'detailPanel',
                region: 'center'
            }]
        })
        // call the superclass's initComponent implementation		
        Biorails.Folder.Panel.superclass.initComponent.call(this);
    },
    /*
     * Fire AJAX call for tool bar functions
     */  
    toolbarClick: function(item) {
        new Ajax.Request( item.href,
        {
            asynchronous:true,
            evalScripts:true
        });

    },
    // override initEvents
    initEvents: function() {
        Biorails.Folder.Panel.superclass.initEvents.call(this);
		
        var folderGridSm = this.getComponent('gridPanel').getSelectionModel();		
        folderGridSm.on('rowselect', this.onRowSelect, this);		
    },
    onRowSelect: function(sm, rowIdx, r) {

        var detailPanel = this.getComponent('detailPanel');
        detailPanel.updateDetail(r.data);
    }
});
// register an xtype with this class
Ext.reg('folder', Biorails.Folder.Panel);

