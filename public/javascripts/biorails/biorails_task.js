
Ext.namespace("Biorails");
Ext.namespace('Biorails.Task');
//----------------------------------------  Protocol Preview Context Table ------------------------------------
Biorails.Task = function() {
    
    return {
        //
        // Add a Row to the pass context_id block
        //
        addRow: function (row_group,context_id) {
            try{ 
                Ext.MessageBox.confirm('Add row', 'Add row under '+row_group, function(btn){
                    if (btn =='yes'){
                        new Ajax.Request('/tasks/add_row/'+context_id, 
                        {asynchronous:true, evalScripts:true }); 
                    }
                });
            } catch (e) {
                console.log('Problem cant handle add rows '+e.message);
                console.log(e);
            } 
        },
        //
        // Add a new Column based on a assay parameter to the pass context block
        //
        addColumn: function(context_id){      
            try{ 
                var paramField = new Ext.form.ComboBox({
                    fieldLabel: 'Parameter',
                    displayField: 'name',
                    typeAhead: true,
                    triggerAction: 'all',
                    emptyText:'Select a parameter...',
                    selectOnFocus:true,
                    mode:'remote',
                    store: new Ext.data.Store({
                        proxy: new Ext.data.HttpProxy({
                            url: '/tasks/list_columns/'+context_id, 
                            method: 'get' 
                        }),
                        reader: new Ext.data.JsonReader({
                            root: 'items', 
                            totalProperty: 'total'},
                        [ {name: 'id', type: 'int'},
                            {name: 'name'},
                            {name: 'description'}]  )
                    })
                });
                var  form = new Ext.FormPanel({
                    bodyStyle:'padding:5px 5px 0',
                    labelWidth: 75,
                    title: 'Add Parameter to Context',
                    url: '/auth/login',
                    items : [paramField]  
                });
            
                var add_button = new Ext.Button({
                    text:'Add',
                    handler: function(item){ 
                        if(form.getForm().isValid() ){
                        
                            new Ajax.Request('/tasks/add_column/'+context_id, 
                            {asynchronous:true, evalScripts:true,
                                parameters:'name='+encodeURIComponent( paramField.value ) }); 
                            win.close(); 
                        } 
                    }			
                });
                var cancel_button = new Ext.Button({
                    text: 'Cancel', 
                    handler: function(){ win.close();
                        win.destroy();
                    }
                });
                
                var win = new Ext.Window({
                    closable: false,
                    layout:'fit',
                    width: 350,
                    height:150,
                    modal: !Ext.isIE6,
                    resizable: false,
                    frame: true,
                    border: false,
                    bodyBorder: false,
                    plain: true,                
                    items: [form],
                    buttons: [add_button, cancel_button]
                });
                win.show();
                
            } catch (e) {
                console.log('Add Column exception '+e.message);
                console.log(e);
            }   	
        }   
    }  
}();	

Biorails.Task.ContextTable = function(config) {
    var grid;  
    var record;
    var store;
    var model; 
    
    /**
     * Function for updating database
     * @param {Object} event
     */
    function saveCell(event) {
        fieldValue = event.value;
        if (event.value instanceof Date)  {   
            fieldValue = event.value.format('Y-m-d');
        }	
        var cell = Ext.get(grid.getView().getCell(event.row,event.column));  
        //store.commitChange();         					
        cell.removeClass('x-cell-saved')
        cell.removeClass('x-cell-invalid')      										
        cell.addClass('x-cell-pending');					
        Ext.Ajax.request( {  
            waitMsg: 'Saving changes...',
            url: '/tasks/cell_value/'+event.record.data.context_id,
            method: 'POST',
            params: { 
                label: event.record.data.row_label,
                field: event.field,
                row: event.row,
                column: event.column,
                value: fieldValue,
                originalValue: event.originalValue                                                                                                                        //when the response comes back from the server can we make an undo array?                         
            },
            failure: function(response, options){
                Ext.MessageBox.alert('Warning','Failed to update report...');
            },                                     
            success: function(response, options){
                var json = eval("("+response.responseText+")");
                if(!json) {
                    throw {message: "Exception is saveCell, Json response not found"};
                }
                var cell = Ext.get(grid.getView().getCell(json.row,json.column));        										
                cell.removeClass('x-cell-pending');
                var record = grid.getStore().getAt(json.row);
                var fieldName = grid.getColumnModel().getDataIndex(json.column);
                var data = record.get(fieldName);
                if (json.errors) {
                    cell.addClass('x-cell-invalid');
                    cellinner = Ext.get(cell.dom.firstChild);
                    Ext.QuickTips.register({
                        target: cellinner.id,
                        text: json.errors,
                        cls: 'x-form-invalid-tip'
                    });
                } else {	
                    record.set(fieldName,json.value);
                    cell.addClass('x-cell-saved');					
                }
            }                                   
        }
    );                                   
    };
    /**
     * Generate a Record from current context
     * Generate a fake data store for preview (currenly linked to server)
     */
    function getStore(){
        var fields =[{name: "row_no", type:'int'},
            {name: "row_group"}, 
            {name: "row_label"}, 
            {name: "context_id", type:'int'}
        ];
        var i=4;
        config.parameters.each( function(item){ 
            fields[i] = { name: item.index, type: 'string'  }
            i++;   
        }); 
    
        store = new Ext.data.GroupingStore({
            reader: new Ext.data.JsonReader({idProperty:'id',fields: fields}),
            pruneModifiedRecords: true,
            data: config.data,
            sortInfo:{field: 'row_no', direction: "ASC"},
            groupField:'row_group'
        });
        return store;
    };
    //
    // Get the currently selected record 
    //
    function getRecord(){
        sel = grid.getSelectionModel();
        if (sel.hasSelection() ) {
            record = sel.getSelections()[0];
        } else {
            record = store.getRange()[store.getCount()-1]
        };
        return record;
    };

    function renderRowHeader(value, metarule, record, rowIndex){
        metarule.css = 'x-cell-row-header';
        return value;
    };
    /**
     * Geneate a Column View based on passed context 
     */
    function getModel(){
        if (!model)
        {
            var columns =[ {header: "row_group",width:70,
                    menuDisabled:true, 
                    sortable: true,
                    fixed: false, 
                    renderer : renderRowHeader,
                    dataIndex: "row_group"},	                
                {header: "row_label",
                    width:70,
                    menuDisabled:true, 
                    sortable: true,
                    fixed: false, 
                    renderer : renderRowHeader,
                    dataIndex: "row_label"}];
            var i=2;
            config.parameters.each( function(item){ 
                columns[i] = {
                    header: item.name,
                    width: 120,
                    fixed: false, 
                    sortable: false,
                    parameter: item,
                    dataIndex: item.index,
                    editor: Biorails.Protocol.getRenderer(item),
                    editor: Biorails.Protocol.getEditor(item)
                }
                i++;   
            }); 
            // Column model for report definition with label,filter and sort changable
            model = new Ext.grid.ColumnModel( columns );
            model.defaultSortable =false;
        };
        return model;
    };
    
    /**
     * Call superclass to generate the actual grid
     */
    options= {
        store: getStore(),        
        cm:    getModel() ,
        tbar: [{
                text: '<b> Context ['+config.path+'] </b> '
            },'->',{ 
                text:'Add Row',
                iconCls:'icon-add',
                tooltip:'New Row below currently selected one',
                handler: function(){
                    record =  getRecord();
                    Biorails.Task.addRow(record.data.row_group,record.data.context_id)
                }
            },{ 
                text:'Add Column',
                iconCls:'icon-add',
                tooltip:'New Column for all rows in context',
                disabled: !config.flexible,
                handler: function(){
                    record =  getRecord();
                    Biorails.Task.addColumn(record.data.context_id)
                }
            }],
        view: new Ext.grid.GroupingView({  
            autoFill: false,
            enableNoGroups:true, // REQUIRED!
            enableGroupingMenu:true,
            hideGroupedColumn: true,
            forceFit: true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})',
            showGroupName: true
        }),
        autoExpandMax:200,
        autoExpandMin:50,
        autoScroll: false,
        autoHeight: true,
        autoShow: true,
        stripeRows: true,
        selModel: new Ext.grid.RowSelectionModel({singleSelect:true}),
        clicksToEdit: 1,
        enableColLock:false,
        enableColumnMove: false,
        enableColumnHide:false,
        enableHdMenu: true,
        loadMask: true,
        minColumnWidth:25,
        trackMouseOver: true,
        frame:false,
        stateful:false,
        floating: false,
        collapsible: false,
        animCollapse: false,
        iconCls: 'icon-grid'
    }	
    if (Ext.isIE6) {
        options['width']= Biorails.getWidth()-20;
        options['autoWidth']=false;
    } else { 
        options['autoWidth']=true;
    }
    grid = new Ext.grid.EditorGridPanel(options);
//    grid.syncSize();
    /**
     * Add handler to save cell after edit
     */
    grid.addListener('afteredit', saveCell);
    //this.addListener('keypress', keyPassed)
    //this.on('render',    function(panel){ panel.enableDD();  });
    return grid;
};




//----------------------------------------  Protocol Preview Context Form ---------------------------------------------

Biorails.Task.ContextForm = function(config) {
    
    var form;
    var config = config;

    
    /**        width: Biorails.getWidth(),

     * Function for updating database
     * @param {Object} event
     */
    function updateDb(field, value, oldValue) {
        if (value != oldValue) {newValue
            var newValue = value;
            field.removeClass('x-cell-saved');
            field.removeClass('x-cell-invalid');      										
            field.addClass('x-cell-pending');					
            if (value instanceof Date) { 
                newValue = value.format('Y-m-d H:i:s') 
            };
            Ext.Ajax.request( {  
                waitMsg: 'Saving changes...',
                url: '/tasks/cell_value/'+config.data[0].context_id,
                method: 'POST',
                params: { 
                    column: 0,
                    row:  config.data[0].row_no,
                    label: config.data[0].row_label,
                    field: field.name,
                    value: newValue,
                    originalValue: oldValue                                                                                                                        //when the response comes back from the server can we make an undo array?                         
                },
                failure: function(response, options){
                    Ext.MessageBox.alert('Warning','Failed to update report...');
                },                                     
                success: function(response, options) {
                    var json = response.responseText;
                    json = eval("("+response.responseText+")");
                    if(!json) {
                        throw {message: "Exception is saveCell, Json response not found"};
                    }
                    field.removeClass('x-cell-pending');
                    if (json.errors) {
                        field.addClass('x-cell-invalid');
                        cellinner = Ext.get(field.dom.firstChild);
                        Ext.QuickTips.register({
                            target: cellinner.id,
                            text: json.errors,
                            cls: 'x-form-invalid-tip'
                        });
                    } else {			   
                        field.addClass('x-cell-saved');		
                        field.setValue(json.value);			
                    }   
                }                
            }); 
        }
    }; 

    /**
     * Generate Field definition from configuration
     */
    function getFields() {
        var fields =[new Ext.form.Hidden({fieldLabel: 'Context Id:',value: config.id,name: 'parameter_context_id'})];
        var i = 1;
        config.parameters.each( function(item){
            fields[i] = Biorails.Protocol.getEditor(item,config.data[0][item.index]);
            fields[i].on('change',updateDb);
            i++;  
        });
        return fields;
    };
	
    var options= {
        labelWidth: 120,
        context: config,
		monitorResize: false,
        tbar: [{
                text: '<b>Context ['+config.path+']</b> '
            },'->',{ 
                text:'Add Field',
                iconCls:'icon-add',
                tooltip:'Add field for all rows in context',
                disabled: !config.flexible,
				autoScroll: false,
                handler: function(){
                    Biorails.Task.addColumn(config.data[0].context_id);
                }
            }],        
        defaults: {width: 400},
        defaultType: 'textfield',
        items : getFields()
    };
    if (Ext.isIE6) {
        options['width']=Biorails.getWidth()-20;
        options['autoWidth']=false;
        options['autoHeight'] = true;
    } else { 
        options['autoWidth']=true;
        options['autoHeight'] = true;
    };
    Biorails.Task.ContextForm.superclass.constructor.call(this,options);        
};

Ext.extend(Biorails.Task.ContextForm, Ext.form.FormPanel);

