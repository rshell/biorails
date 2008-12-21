
Ext.namespace("Biorails");
//---------------------------------------- Conbo Field Widget--------------------------------------------------------
Ext.namespace("Biorails.TaskComboField");
/**
 * Custom Select field for a remote data element field
 */

Biorails.TaskComboField  = Ext.extend(Ext.form.ComboBox,{
    my_store: null,

    cleanup: function(){
        this.removeClass('x-cell-active');
    },
    entry: function(){
        this.removeClass('x-cell-saved');
        this.addClass('x-cell-active');
    },
    initComponent : function() {
        this.my_url = this.url;
        this.my_store = new Ext.data.Store({
                proxy: new Ext.data.HttpProxy({
                    url: this.url,
                    method: 'post'
                }),
                reader: new Ext.data.JsonReader({
                    root: 'items',
                    totalProperty: 'total'
                }, [{
                    name: 'id',
                    type: 'int'
                }, {
                    name: 'name'
                }, {
                    name: 'description'
                }])
            });
        options =  {
            mode: 'remote',
            store: this.my_store,
            triggerAction: 'all',
            typeAhead: false,
            typeAheadDelay: 500,
            editable: true,
            allowBlank: true,
            cls: 'x-combo-remote',
            forceSelection: true,
            loadingText: 'Looking Up Name...',
            selectOnFocus: false,
            minChars: 3,
            allQuery: '',
            queryDelay: 500,
            valueField: 'name',
            displayField: 'name'
        };
        Ext.apply(this, options);

        Biorails.Task.ContextTable.superclass.initComponent.call(this);
        this.on('expand', function(field){ 
            field.my_store.reload();
        });
        this.on('focus',  function(field){
            field.entry();
        });
        this.on('blur',   function(field){
            field.cleanup();
        });
    }
});

Ext.namespace('Biorails.Task');
//----------------------------------------  Protocol Preview Context Table ------------------------------------
Biorails.Task = function() {
    
    return {
        getEditor: function(item, value){
            switch (item.data_type_id)   {
                case 2 :
                    return new Ext.form.TextField({
                        name: item.name,
                        value: value,
                        task_item: item,
                        autoShow: true,
                        fieldLabel: item.name
                    });
                    break;
                case 3 :
                    return new Biorails.DateField({
                        name: item.name,
                        format: 'Y-m-d',
                        autoShow: true,
                        task_item: item,
                        value: value,
                        fieldLabel: item.name
                    });
                    break;
                case 4:
                    return new Ext.form.TimeField({
                        name: item.name,
                        autoShow: true,
                        task_item: item,
                        value: value,
                        fieldLabel: item.name
                    });
                    break;
                case 5:
                    return new Biorails.TaskComboField({
                        name: item.name,
                        value: value,
                        autoShow: true,
                        task_item: item,
                        url: '/tasks/select/' + item.data_element_id,
                        fieldLabel: item.name
                    });
                    break;
                case 6:
                    return new Ext.form.TextField({
                        name: item.name,
                        value: value,
                        task_item: item,
                        vtype: 'url',
                        autoShow: true,
                        fieldLabel: item.name
                    });
                    break;
                case 7:
                    return new Biorails.FileComboField({
                        name: item.name,
                        value: value,
                        task_item: item,
                        autoShow: true,
                        folder_id: item.folder_id,
                        fieldLabel: item.name
                    });
                    break;
                default:
                    return new Ext.form.TextField({
                        name: item.name,
                        autoShow: true,
                        task_item: item,
                        value: value,
                        fieldLabel: item.name
                    });
                    break;
            };
        },
        //
        // Add a Row to the pass context_id block
        //
        addRow: function (row_group,context_id) {
            try{
                Ext.MessageBox.prompt('Under context '+row_group, 'Enter number of rows do you want to add?',
                function(btn,text){
                    if (btn =='ok'){
                        new Ajax.Request('/tasks/add_row/'+context_id,
                        {
                            asynchronous:true,
                            parameters:'count='+encodeURIComponent( text),
                            evalScripts:true
                        });
                    }
                },this,false,1);
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
                            totalProperty: 'total'
                        },
                        [ {
                            name: 'id',
                            type: 'int'
                        },

                        {
                            name: 'name'
                        },

                        {
                            name: 'description'
                        }]  )
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
                            {
                                asynchronous:true,
                                evalScripts:true,
                                parameters:'name='+encodeURIComponent( paramField.value )
                            });
                            win.close();
                        }
                    }
                });
                var cancel_button = new Ext.Button({
                    text: 'Cancel',
                    handler: function(){
                        win.close();
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

Biorails.Task.ContextTable = Ext.extend(Ext.grid.EditorGridPanel,{
    rowMouseUp: 0,
    grid: null,
    /**
     * cell Save failure handler
     */
    save_failure: function(response, options){
        Ext.MessageBox.alert('Warning','Failed to update report...');
    },
    /**
     * cell Save success handler
     */
    save_success: function(response, options){
        var json = Ext.util.JSON.decode(response.responseText);
        if(!json) {
            throw {
                message: "Exception is saveCell, Json response not found"
            };
        }
        var cell = Ext.get(options.grid.getView().getCell(json.row,json.column));
        cell.removeClass('x-cell-pending');
        var record = options.grid.getStore().getAt(json.row);
        var fieldName = options.grid.getColumnModel().getDataIndex(json.column);
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
            /* Update other cells in row*/
            /*if (json.data!=null) {
               for (key  in json.data) {
                  record.set(key,json.data[key]);
               }
            }*/
            record.set(fieldName,json.value);
            cell.addClass('x-cell-saved');
        }
    },
    editCell: function(event) {
        editor =  event.grid.getColumnModel().getCellEditor( event.column,event.row)
        if (editor.field.my_store) {
            editor.field.my_store.baseParams = {
                task_context_id: event.record.data.context_id
            };
            editor.field.my_store.load();
        };
    },
    /**
     * Function for updating database
     * @param {Object} event
     */
    saveCell: function(event) {
        fieldValue = event.value;
        if (event.value instanceof Date)  {
            fieldValue = event.value.format('Y-m-d');
        }
        var cell = Ext.get(this.getView().getCell(event.row,event.column));
        //store.commitChange();
        cell.removeClass('x-cell-saved');
        cell.removeClass('x-cell-invalid');
        cell.removeClass('x-cell-active');
        cell.addClass('x-cell-pending');
        Ext.Ajax.request( {
            waitMsg: 'Saving changes...',
            url: '/tasks/cell_value/'+event.record.data.context_id,
            method: 'POST',
            grid: this,
            params: {
                label: event.record.data.row_label,
                field: event.field,
                row: event.row,
                data:  Ext.util.JSON.encode(event.record.data),
                column: event.column,
                value: fieldValue,
                originalValue: event.originalValue
            },
            failure: this.save_failure ,
            success: this.save_success
        });
    },

    //
    // Get the currently selected record
    //
    getRecord: function(){
        sel = grid.getSelectionModel();
        if (sel.hasSelection() ) {
            record = sel.getSelections()[0];
        } else {
            record = store.getRange()[store.getCount()-1]
        };
        return record;
    },
    getCurrentRow: function(e, t){
        var row;
        if( (row = this.view.findRowIndex(t)) !== false)  {
            this.rowMouseUp=row;
        }else {
            this.rowMouseUp=false;
        }
    },
    addRow: function(button,event){
        record = this.grid.store.getAt( this.grid.rowMouseUp );
        Biorails.Task.addRow(record.data.row_group,record.data.context_id);
    },
    addColumn: function(button,event){
        Biorails.Task.addColumn(button.context_id);
    },

    renderRowHeader: function(value, metarule, record, rowIndex){
        metarule.css = 'x-cell-row-header';
        return value;
    },
    initComponent : function() {
        /**
         * Generate a Record from current context
         * Generate a fake data store for preview (currenly linked to server)
         */
        var fields =[{
            name: "row_no",
            type:'int'
        },

        {
            name: "row_group"
        },

        {
            name: "row_label"
        },

        {
            name: "context_id",
            type:'int'
        } ];
        var i=4;

        this.parameters.each( function(item){
            fields[i] = {
                name: item.index,
                type: 'string'
            }
            i++;
        });

        store = new Ext.data.GroupingStore({
            reader: new Ext.data.JsonReader({
                idProperty:'id',
                fields: fields
            }),
            pruneModifiedRecords: true,
            data: this.values,
            sortInfo:{
                field: 'row_no',
                direction: "ASC"
            },
            groupField:'row_group'
        });
        /**
         * Geneate a Column View based on passed context
         */
        var columns =[ {
            header: "row_group",
            width:70,
            menuDisabled:true,
            sortable: true,
            fixed: false,
            renderer : this.renderRowHeader,
            dataIndex: "row_group"
        },{
            header: "row_label",
            width:70,
            menuDisabled:true,
            sortable: true,
            fixed: false,
            renderer : this.renderRowHeader,
            dataIndex: "row_label"
        }];
        i=2;
        folder_id = this.folder_id;
        this.parameters.each( function(item){
            item.entry = function(event){
                alert(event)
            };
            item['grid'] = this;
            item['folder_id'] = folder_id;
            columns[i] = {
                header: item.label,
                tooltip: item.description,
                width: 120,
                fixed: false,
                sortable: false,
                parameter: item,
                dataIndex: item.index,
                renderer: Biorails.Protocol.getRenderer(item),
                editor: Biorails.Task.getEditor(item)
            }
            i++;
        });
        // Column model for report definition with label,filter and sort changable
        model = new Ext.grid.ColumnModel( columns );
        model.defaultSortable =false;
        /**
         * Call superclass to generate the actual grid
         */
        options= {
            store: store,
            cm:    model ,
            tbar: [{
                text: '<b> Context ['+this.path+'] </b> '
            },'->',{
                text:'Add Row',
                iconCls:'icon-add',
                tooltip:'New Row below currently selected one',
                context_id: this.values[0].context_id,
                grid: this,
                handler: this.addRow
            },{
                text:'Add Column',
                iconCls:'icon-add',
                tooltip:'New Column for all rows in context',
                disabled: !this.flexible,
                context_id: this.values[0].context_id,
                grid: this,
                handler: this.addColumn
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
            stripeRows: true,
            enableColumnMove: false,
            listeners:{
                scope:this,
                'mouseup':{
                    scope:this.grid,
                    fn:function(e, t){
                        var row;
                        if( (row = this.view.findRowIndex(t)) !== false)  this.rowMouseUp=row;
                        else this.rowMouseUp=false;
                    }
                }
            },
            autoScroll: false,
            autoHeight: true,
            autoShow: true,
            selModel: new Ext.grid.RowSelectionModel({
                singleSelect:true
            }),
            clicksToEdit: 0,
            enableColLock:false,
            enableColumnHide:false,
            enableHdMenu: true,
            loadMask: true,
            trackMouseOver: true,
            frame:true,
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
        Ext.apply(this, options);
        // finally call the superclasses implementation
        Biorails.Task.ContextTable.superclass.initComponent.call(this);
        grid = this;
        this.on('beforeedit',this.editCell,this)
        this.on('afteredit',this.saveCell,this);
        this.on('mouseup', this.getCurrentRow, this);
    /**
         * Add handler to save cell after edit
         */
    //this.addListener('keypress', keyPassed)
    //this.on('render',    function(panel){ panel.enableDD();  });
    }
});




//----------------------------------------  Protocol Preview Context Form ---------------------------------------------

Biorails.Task.ContextForm = Ext.extend(Ext.form.FormPanel, {
 
    /**
     * Function for updating database
     * @param {Object} event
     */
    updateDb: function(field, value, oldValue) {
        if (value == oldValue) {
            field.cleanup();
        } else {
            var newValue = value;
            var data = field.ownerCt.context.values
            field.removeClass('x-cell-saved');
            field.removeClass('x-cell-active');
            field.removeClass('x-cell-invalid');
            field.addClass('x-cell-pending');
            if (value instanceof Date) {
                newValue = value.format('Y-m-d H:i:s')
            };

            Ext.Ajax.request( {
                waitMsg: 'Saving changes...',
                url: '/tasks/cell_value/'+data[0].context_id,
                method: 'POST',
                params: {
                    column: 0,
                    row:   data[0].row_no,
                    label: data[0].row_label,
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
                        throw {
                            message: "Exception is saveCell, Json response not found"
                        };
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
    },
    exitField: function(field){
        if (field.cleanup != null) {   field.cleanup();}
    },
    enterField: function(field){
        var data = field.ownerCt.context.values;
        if (field.entry !=null) {field.entry();}
        if (field.my_store) {
           field.my_store.clearFilter();
           field.my_store.baseParams = {
                task_context_id: data[0].context_id
            }
        }
    },
    initComponent: function() {
        var fields =[
        new Ext.form.Hidden({
            fieldLabel: 'Definition Id:',
            value: this.id,
            name: 'parameter_context_id'
        },{
            fieldLabel: 'Context Id:',
            value: this.values[0].context_id,
            name: 'task_context_id'
        }
        )];
        var i = 1;
        data = this.values;
        func1 = this.updateDb;
        func2 = this.enterField;
        func3 = this.exitField;
        folder_id = this.folder_id;
        this.parameters.each( function(item){
            item['form'] = this;
            item['folder_id'] = folder_id;
            fields[i] = Biorails.Task.getEditor(item,data[0][item.index]);
            if (fields[i].my_store) {
                fields[i].my_store.baseParams = {
                    task_context_id: data[0].context_id
                };
            };
            fields[i].on('change',func1);
            fields[i].on('focus',func2);
            fields[i].on('blur',func3);

            i++;
        });
	
        var options= {
            labelWidth: 120,
            scope: this,
            context: this,
            autoWidth: true,
            autoHeight: true,
            monitorResize: false,
            context_id: data[0].context_id,
            tbar: [{
                text: '<b>Context ['+this.path+']</b> '
            },'->',{
                text:'Add Field',
                iconCls:'icon-add',
                tooltip:'Add field for all rows in context',
                disabled: !this.flexible,
                autoScroll: false,
                handler: function(){
                    Biorails.Task.addColumn(data[0].context_id);
                }
            }],
            defaults: {
                width: 400
            },
            defaultType: 'textfield',
            items : fields
        };
        if (Ext.isIE6) {
            options['width']=Biorails.getWidth()-20;
            options['autoWidth']=false;
            options['autoHeight'] = true;
        };
        Ext.apply(this, options);
        // finally call the superclasses implementation
        Biorails.Task.ContextForm.superclass.initComponent.call(this);
    }
});
