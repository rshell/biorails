//----------------------------------------  Biorails Report ---------------------------------------------

Ext.namespace('Biorails.Report');

Biorails.Report.DropTarget =function(el,config) {
    Biorails.Report.DropTarget.superclass.constructor.call(this,el,
        Ext.apply(config,{
            ddGroup:'ColumnDD',
            overClass: 'dd-over'
        }));
};

Ext.extend( Biorails.Report.DropTarget, Ext.dd.DropTarget, {

    notifyDrop: function (source,e,data) {
        new Ajax.Request('/reports/add_column/'+this.report_id,
        {
            asynchronous:true,
            evalScripts:true,
            parameters:'id='+encodeURIComponent(data.node.id)
        });
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
        root:  new Ext.tree.AsyncTreeNode({
            text: config.model,
            expanded: true,
            draggable:false,
            id: "."
        }),
        loader: new Ext.tree.TreeLoader({
            dataUrl: '/reports/columns/'+config.report_id
        })
    }));
                
    this.on('dblclick',function(node,e) {
        this.add_column(node)
    });
                      
}

Ext.extend(Biorails.ColumnTree,  Ext.tree.TreePanel, {
    
    add_column: function (node){
        if (node.leaf) {
            new Ajax.Request('/reports/add_column/'+this.report_id,
            {
                asynchronous:true,
                evalScripts:true,
                parameters:'id='+encodeURIComponent(node.id)
            });
        }
        return false;
    }
} );

//---------------------------------------- Report Definition ------------------------------------------------

Ext.namespace("Biorails.ReportDef");

/**
 * Biorails.Folder.GridPanel
 * @extends Ext.grid.GridPanel
 * This is a custom grid which will display folder information. It is tied to
 * a specific record definition by the dataIndex properties.
 *
 */
Biorails.ReportDef = Ext.extend( Ext.grid.EditorGridPanel, {

    initComponent : function() {
        column_record = Ext.data.Record.create([
        { name: 'id'  },
        { name: 'name'     },
        { name: 'label'  },
        { name: 'filter' },
        { name: 'is_filterible',type: 'boolean'  },
        { name: 'is_visible',type: 'boolean' },
        { name: 'is_sortable',type: 'boolean'  },
        { name: 'sort_num',type: 'int' },
        { name: 'sort_direction'  }]
        );

        column_store = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: '/reports/layout/'+this.report_id
            }),

            reader: new Ext.data.JsonReader({
                root: 'items',
                totalProperty: 'total',
                id: 'id'
            },column_record),
            remoteSort: true
        });
        column_store.load();

        // Column model for report definition with label,filter and sort changable

        column_model = new Ext.grid.ColumnModel([
        {
            header: "Name",
            width: 120,
            sortable: true,
            dataIndex: 'name'
        },
        {
            header:'Visible',
            width:32,
//            renderer: this. renderBoolean,
            editor: new Ext.form.Checkbox(),
            dataIndex:'is_visible'
        },
        {
            header: "Label",
            width: 120,
            sortable: true,
            editor: new Ext.form.TextField({
                allowBlank: false
            }),
            dataIndex: 'label'
        },
        {
            header:'Filterable',
            width:45,
//            renderer: this.renderBoolean,
            editor: new Ext.form.Checkbox(),
            dataIndex:'is_filterible'
        },
        {
            header: "Preset Filter",
            width: 120,
            sortable: true,
            editor: new Ext.form.TextField(),
            dataIndex: 'filter'
        },
        {
            header:'Sortable',
            width:40,
//            renderer: this.renderBoolean,
            editor: new Ext.form.Checkbox(),
            dataIndex:'is_sortable'
        },
        {
            header: "Dir",
            width: 50,
            editor: new Ext.form.ComboBox({
                typeAhead: true,
                triggerAction: 'all',
                transform:'sort_dir_select',
                lazyRender:true,
                listClass: 'x-combo-list-small'
            }),
            dataIndex: 'sort_direction'
        },

        {
            id:'Id',
            header: "Remove",
            width: 20,
            sortable: true,
            renderer: this.renderId,
            dataIndex: 'id'
        }

        ]);

        column_model.defaultSortable =true;
            
        Ext.apply(this,  {
            store: column_store ,
            cm: column_model ,
            viewConfig: {
                forceFit: true
            },
            sm: new Ext.grid.RowSelectionModel({
                singleSelect:true
            }),
            loadMask: true,
            enableDragDrop: true,
            ddGroup:'ColumnDD',
            ddText: 'drag and drop to change order',   
            width:'auto',
            autoWidth: true,
            autoScroll: false,
            autoHeight: true,
            clicksToEdit: 1,
            forceFit: true,
            frame:true,
            title:'Drag columns from tree to add to report',
            iconCls:'icon-grid'
        });
        if (Ext.isIE6) {
            this['width']= Biorails.getWidth()-10;
            this['autoWidth'] = false;
        } else {
            this['autoWidth'] = true;
        };

        Biorails.ReportDef.superclass.initComponent.call(this);
        this.on( 'cellclick', this.cellClicked)
        this.on( 'afteredit', this.updateRow)
        this.on('render',    function(grid){  
            grid.enableDD();
        });
    },

    /**
     * Red/Green Custom renderer function
     * renders red if <0 otherwise renders green
     * @param {Object} val
     */
    renderBoolean: function(v, p, record){
        var checkState = (+v) ? '-on' : '';
        p.css += ' x-biorails-check-col-td';
        return '<div class="x-biorails-check-col'+ checkState +' x-grid3-cc-'+this.id+'"> </div>';
    },
    /**
     * render id as a link  to
     */
    renderId: function(val){
        return '<img alt="remove" src="/images/enterprise/actions/cancel.png"/>';
    },

    cellClicked: function( grid, rowIndex,  columnIndex, event){
        if (columnIndex == 7){
            var record = column_store.getAt(rowIndex);
            this.deleteRow(record);
        }
    },
    /*
     * Custom Rendering function to add drop zone on grid after its rendered
     */
    enableDD: function(){
        try {
            var dropzone = new Ext.dd.DropTarget(this.id, {
                ddGroup : 'columnDD',
                report_id: this.report_id,
                grid: this,
                notifyDrop : this.droppedItem
            });
            dropzone.addToGroup("ClipboardDD");
            dropzone.addToGroup("ColumnDD");
            dropzone.addToGroup("TreeDD");

        } catch (e) {
            console.log('Problem with setup drop zone on folder grid ');
            console.log(e);
        }
    },
    addRow: function(data){
        new Ajax.Request('/reports/add_column/'+this.report_id,
        {
            asynchronous:true,
            evalScripts:true,
            parameters:'id='+encodeURIComponent(data.node.id)
        });
        return false;
    },
    moveRow:function(from_id, to_id){
        new Ajax.Request('/reports/move_column/'+from_id,
        {
            asynchronous:true,
            evalScripts:true,
            parameters:'to='+encodeURIComponent(to_id)
        });
        return false;
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
                this.grid.moveRow(source_row.data.id,dest_row.data.id);
            }
            // Test for case of a node from a folder tree
            else if (data.node) {
                this.grid.addRow(data)
            }
        } catch (e) {
            console.log('Problem, cannot handle Dropped Item ');
            console.log(e);
        }
        return true;
    },
    // Delete a Columns row from the report
    deleteRow: function(record) {
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
    },
    /**
     * Function for updating database
     * @param {Object} event
     */
    updateRow: function(event) {
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
                column: {
                    id: event.record.data.id
                },
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
    }
});

Biorails.ReportView = Ext.extend( Ext.grid.GridPanel, {

    initComponent : function() {
        data_record = Ext.data.Record.create(this.data_record );

        data_store = new Ext.data.GroupingStore({
            proxy: new Ext.data.HttpProxy({
                url: this.data_url,
                method: 'post'
            }),

            reader: new Ext.data.JsonReader({
                root: 'items',
                totalProperty: 'total',
                id: 'id'
            },data_record),
            remoteSort: true
        });
        data_model = new Ext.grid.ColumnModel(this.data_model);
        data_model.defaultSortable =true;

        // Column model for report definition with label,filter and sort changable

        Ext.apply(this,  {
            store: data_store ,
            cm: data_model ,
            view: new Ext.grid.GroupingView({
                forceFit : true,
                autoFill:true
            }),
            sm: new Ext.grid.RowSelectionModel({
                singleSelect:true
            }),
            loadMask: true,
            enableDragDrop: true,
            ddGroup:'ColumnDD',
            width:'auto',
            autoWidth: true,
            autoScroll: false,
            autoHeight: true,
            clicksToEdit: 1,
            forceFit: true,
            frame:true,
            iconCls:'icon-grid',
            bbar: new Ext.PagingToolbar({
                pageSize: this.limit,
                store: data_store,
                autoWidth: true,
                displayInfo: true,
                displayMsg: 'Displaying {0} - {1} of {2}',
                emptyMsg: "No results to display"
            })
        });
        if (Ext.isIE6) {
            this['width']= Biorails.getWidth()-10;
            this['autoWidth'] = false;
        } else {
            this['autoWidth'] = true;
        };

        Biorails.ReportView.superclass.initComponent.call(this);
        this.on('rowclick', function(grid, rowIndex, e){
                  var rec = grid.store.getAt(rowIndex);
                  window.location = rec.get('url');
                  grid.getView().focusEl.focus();
                });
        data_store.load({
            params: {
                start: this.start,
                limit: this.limit
            }
        });

    },

    /**
     * render id as a link  to
     */
    renderId: function(val){
        return '<img alt="remove" src="/images/enterprise/actions/cancel.png"/>';
    }

});

// register an xtype with this class
Ext.reg('report_view', Biorails.ReportView);
