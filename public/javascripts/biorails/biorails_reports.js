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
      return '<img alt="remove" src="/images/enterprise/actions/cancel.png"/>';
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
              {name: 'is_filterible'},
              {name: 'is_visible'},
              {name: 'is_sortable'},
              {name: 'sort_num'},
              {name: 'sort_direction'}]
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
                dataIndex:'is_filterible'
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
                dataIndex: 'sort_direction'},
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
         options = {
            renderTo: 'column-grid',
            store: column_store,        
            cm:    column_model ,
            viewConfig: {  forceFit: true  },
            sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
            width:'auto',
            autoWidth: true,
            autoscroll: false,
            autoHeight: true,
            clicksToEdit: 1,
	    forceFit: true,
            frame:true,
            title:'Drag columns from tree to add to report',
            iconCls:'icon-grid'		 	
         };
         grid = new Ext.grid.EditorGridPanel(options);
         grid.store.load();
         grid.addListener('afteredit', updateRow);
         grid.addListener('cellclick', cellClicked);
    };

     setupRecord();
     setupStore(report_id);
     setupColumns();
     setupGrid();       
};  
