
Ext.namespace("Biorails");
Ext.namespace('Biorails.Protocol');
/**
 * Core protocol related static functions to change ajax calls to 
 * update the status of protocol on the server
 */
Biorails.Protocol = function(){

    return {
    
        getEditor: function(item, value){
            switch (item.data_type_id)   {
                case 2 :  
                return new Ext.form.TextField({
                    name: item.name,
//                    maskRe: new RegExp(item.regex),
                    value: value,
                    fieldLabel: item.name});
                break;                      
                case 3 : 
                return new Biorails.DateField({
                    name: item.name, 
                    format: 'Y-m-d',                    
                    value: value,
                    fieldLabel: item.name});
                break;
                case 4: 
                return new Ext.form.TimeField({
                    name: item.name, 
                    value: value,
                    fieldLabel: item.name});
                break;
                case 5:  
                return new Biorails.ComboField({
                    name: item.name,  
                    value: value,
                    root_id: item.data_element_id, 
                    fieldLabel: item.name});
                break;
                case 6: 
                return new Ext.form.TextField({
                    name: item.name,   
                    value: value,
                    vtype: 'url',  
                    fieldLabel: item.name});
                break;
                case 7:  
                return new Biorails.FileComboField({
                    name: item.name,  
                    value: value,
                    folder_id: item.folder_id, 
                    fieldLabel: item.name});
                break;
                default:
                return new Ext.form.TextField({
                    name: item.name,  
                    value: value,
//                    maskRe: new RegExp(item.regex),
                    fieldLabel: item.name});
                break;
            };
        },  
        getRenderer: function(item) {
            switch (item.data_type_id)   {                    
                case 3 : 
                     return function(v){
                        return Ext.util.Format.date(v,'Y-m-d');
                    }; 
                break;
              
                default:
                return function(v){ return Ext.util.Format.htmlEncode(v); }; 
                break;
            };            
        },
        /**
         * Add a new child context
         */
        addContext: function(context_id){       
            try{ 
                var form = new Ext.FormPanel({
                    labelWidth: 75,
                    frame: true,
                    width: 300,
                    height: 100,
                    url: '/processes/add_context/'+context_id,
                    defaults: { width: 200},
                    defaultType: 'textfield',
                    items : [{
                            fieldLabel: 'Label',
                            name: 'label',
                            maskRe: /^[A-Z,a-z,0-9,-,_]*$/,
                            invalidText: 'Only Alpha Numeric characters allowed',
                            blankText:'Parameters must have a name',
                            value: '',
                            allowBlank:false
                        },{
                            fieldLabel: 'Default Count',
                            xtype: 'numberfield',
                            value: 1,
                            minValue: 1,
                            maxValue: 100,
                            allowBlank:false,
                            name: 'default_count'
                        }]
                });
                
                var win = new Ext.Window({
                    layout:'fit',
                    width: 350,
                    height:200,
                    url: '/processes/add_context/'+context_id,
                    modal: true,
                    plain: true,                
                    items: form,
                    buttons: [{
                            text:'Add',
                            handler: function(item){ 
                                if(form.getForm().isValid() ){
                                    win.hide(); 
                                    form.getForm().submit({
                                        url: form.url
                                    });

                                } else { 
                                    Ext.Msg.alert('Warning', 'Entered Data is not valid');	
                                }                
                            }
                        },{
                            text: 'Cancel',
                            handler: function(){
                                win.close(); 
                            }
                        }]
                });
                win.show(this);
                //win.render(document.body); 
            } catch (e) {
                console.log('Problem cant handle add context ');
                console.log(e);
            } 

   
        },
        editContext: function(config){       
            try{ 
                var  form = new Ext.FormPanel({
                    labelWidth: 75,
                    frame: true,
                    width:  300,
                    height: 100,
                    url: '/processes/update_context/'+config.id,
                    defaults: {width: 200},
                    defaultType: 'textfield',
                    items : [{
                            fieldLabel: 'Label',
                            name: 'label',
                            value: config.label,
                            maskRe: /^[A-Z,a-z,0-9,-,_]*$/,
                            invalidText: 'Only Alpha Numeric characters allowed',
                            blankText:'Parameters must have a name',
                            allowBlank:false
                        },{
                            fieldLabel: 'Default Count',
                            xtype: 'numberfield',  
                            value: config.default_count,
                            minValue: 1,
                            maxValue: 100,
                            allowBlank:false,
                            name: 'default_count'
                        },{
                            fieldLabel: 'Context',
                            name: 'parameter_context_id',
                            xtype: 'hidden',
                            value: config.id,
                            allowBlank:false
                        }]
                });
                
                var win = new Ext.Window({
                    layout:'fit',
                    width: 350,
                    height:200,
                    url: '/processes/update_context/'+config.id,
                    modal: true,
                    plain: true,                
                    items: form,
                    buttons: [{
                            text:'Update',
                            handler: function(item){ 
                                if(form.getForm().isValid() ){
                                    win.hide(); 
                                    form.getForm().submit({
                                        url: form.url
                                    });

                                } else { 
                                    Ext.Msg.alert('Warning', 'Entered Data is not valid');	
                                }                
                            }
                        },{
                            text: 'Cancel',
                            handler: function(){
                                win.close(); 
                            }
                        }]
                });
                win.show(this);
                //win.render(document.body); 
            } catch (e) {
                console.log('Problem cant handle edit context ');
                console.log(e);
            } 
   
        }, /**
         * Remove a context from the treee
         */
        removeContext: function(context_id){
            try{ 
                Ext.MessageBox.confirm('Remove Context', 'Are you sure you want to remove this context?', function(btn){
                    if (btn =='yes'){
                        new Ajax.Request('/processes/remove_context/'+context_id, {asynchronous:true, evalScripts:true }); 
                    }
                });
            } catch (e) {
                console.log('Problem cant handle remove context ');
                console.log(e);
            } 
   
        },
        /**
         * Remove a parameter from a context
         */
        removeParameter: function(parameter_id,mode){
            try{ 
                Ext.MessageBox.confirm('Remove Parameter', 'Are you sure you want to remove this parameter?', function(btn){
                    if (btn =='yes'){
                        new Ajax.Request("/processes/remove_parameter/"+  parameter_id,
                        {asynchronous:true, evalJS: true,
                            parameters:{ mode: mode }
                        });
                    };
                });
            } catch (e) {
                console.log('Problem cannot handle Dropped Item ');
                console.log(e);
            };
            return true;    
        },
        /**
         * Add a parameter to a given context
         */
        addParameter: function( context_id,lock_version, parameter_el,mode ){
            try{ 
                new Ajax.Request('/processes/add_parameter/'+context_id,
                {asynchronous:true, evalJS:true,
                    parameters:{
                        node: encodeURIComponent(parameter_el),
                        lock_version: lock_version,
                        mode: mode
                    } }); 
                return true;  
            } catch (e) {
                console.log('Problem cannot handle Parameter move');
                console.log(e);
                return false;
            } 
        },

        /**
         * Move location of a parameter in tree
         */
        moveParameter: function(source_id,dest_id,mode){
            try{ 
                new Ajax.Request("/processes/move_parameter/"+  source_id,
                {asynchronous:true, evalScripts:true,
                    parameters: {after: dest_id,
                        mode: mode }});                          
            } catch (e) {
                console.log('Problem cannot handle Parameter move');
                console.log(e);
            } 
            return true;  
        }   
    }  
}();
Ext.namespace("Biorails.Protocol.ContextDialog");

    
//----------------------------------------  Biorails Conceptural Tree ---------------------------------------------
Ext.namespace("Biorails.Protocol.ParameterTree");

/**
 * Study Parameters grouped tree to soon the defined namespace for data collection in the assay
 * This is used drag source to parameters to add to a protocol data entry sheet.
 *
 * Config properties
 *   assay_id
 *   plus core TreePanel settings
 * 
 */

Biorails.Protocol.ParameterTree = function(config){
    
    Biorails.Protocol.ParameterTree.superclass.constructor.call(this,Ext.apply(config,{
        title:'Assy Parameters',
        minHeight: 400,
        autoShow: true, 
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',           
        animate: true,
        enableDD: true,
        ddGroup:'parameterDD',
        iconCls:'icon-assay', 
        root:  new Ext.tree.AsyncTreeNode({   text: 'Parameters',
            expanded: true,  
            draggable:false, id: 'root' }),
        loader: new Ext.tree.TreeLoader({ dataUrl:'/parameters/tree/'+config.assay_id})
    }));
        
};

Ext.extend(Biorails.Protocol.ParameterTree,  Ext.tree.TreePanel, {} );

//----------------------------------------  Protocol Preview Context Table ------------------------------------

Biorails.Protocol.ContextTable = function(config) {
    var record;
    var store;
    var model;
    
    /**
     * Function for updating database
     * @param {Object} event
     */
    function saveCell(event) {
        if (event.value instanceof Date)            
        {   
            var fieldValue = event.value.format('Y-m-d H:i:s');
        } else
        {
            var fieldValue = event.value;
        }	
        Ext.Ajax.request( {  
            waitMsg: 'Saving changes...',
            url: config.url,
            method: 'POST',
            params: { 
                id: event.record.data.id,
                column: {id: event.record.data.id},
                field: event.field,
                value: event.value,
                originalValue: event.record.modified                                                                                                                              //when the response comes back from the server can we make an undo array?                         
            },
            failure: function(response, options){
                Ext.MessageBox.alert('Warning','Failed to update report...');
                store.rejectChanges();
            },                                     
            success: function(response, options){
                store.commitChanges();
            }                                   
        }
    ); 
    };
    /**
     * Generate a Record from current context
     * Generate a fake data store for preview (currenly linked to server)
     */
    function getStore(){
        if (!store) {
            record = config.parameters.each( function(item){ 
                {name: item.name} 
            });
            
            row = config.parameters.each(function(item){ 
                item.default_value
            });
            rows = []
            for(i=0;i<config.default_count;i++) {
                rows[i] = row;
            }
            //store = new Ext.data.SimpleStore({  fields: record});
            //store.loadData([row,row])
            store = new Ext.data.Store({

                data: { id: config.id, total: 2,items: rows },
                pruneModifiedRecords: true,
                reader: new Ext.data.JsonReader({
                root: 'items',  totalProperty: 'total', id: 'id' },record),        
                remoteSort: true	
            });

        }
        return store;
    };

    /**
     * Geneate a Column View based on passed context 
     */
    function getModel(){
        if (!model)
        {
            // Column model for report definition with label,filter and sort changable
            var columns =[];
            var i=0;
            config.parameters.each( function(item){ 
                columns[i] = {
                    header: item.name,
                    width: 50,
                    sortable: true,
                    parameter: item,
                    dataIndex: item.name,
                    renderer: Biorails.Protocol.getRenderer(item),
                    editor: Biorails.Protocol.getEditor(item,item.default_value)
                }
                i++;   
            }); 
            model = new Ext.grid.ColumnModel(columns);
            model.defaultSortable =true;
        };
        return model;
    };
   
    /**
     * Call superclass to generate the actual grid
     */
    Biorails.Protocol.ContextTable.superclass.constructor.call(this, {
        store: getStore(),        
        cm:    getModel() ,
        viewConfig: {  forceFit: true  },
        context: config,
        autoHeight : true,
        width: Biorails.getWidth()-10,
        sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
        enableDragDrop: true,
        stripeRows: true,
        enableColumnMove: false,
        listeners:{
            scope:this,
            'mouseup':{scope:this.grid, fn:function(e, t){
                    var row;
                    if( (row = this.view.findRowIndex(t)) !== false)  this.rowMouseUp=row;
                    else this.rowMouseUp=false;
                }}
        },
        frame:true,
        iconCls:'icon-grid',        
        clicksToEdit: 0
    });
    /**
     * Add handler to save cell after edit
     */
    this.addListener('afteredit', saveCell);
    this.on('render',    function(panel){ panel.enableDD();  });

};

Ext.extend(Biorails.Protocol.ContextTable,Ext.grid.EditorGridPanel,{
    /**
     * Function to add a dropped a parameter
     */
    add: function(source,event,data){
        if (data.node.leaf) {
            return Biorails.Protocol.addParameter( this.context_id, this.lock_version, data.node.id, 0);  
        }
    },
  
    /*
     * Custom Rendering function to add drop zone on grid after its rendered
     */    
    enableDD: function(){
        try{ 
            var dropzone = new Ext.dd.DropTarget(this.id, {
                ddGroup : 'parameterDD',
                context_id: this.context.id,
                lock_version : this.context.lock_version,
                panel: this,
                notifyDrop : this.add });

        } catch (e) {
            console.log('Problem with setup drop zone on Biorails.Protocol.ContextTable ');
            console.log(e);
        }        
    }


});


//----------------------------------------  Protocol Preview Context Form ---------------------------------------------

Biorails.Protocol.ContextForm = function(config) {
    
    var form;
    var config = config;
    /**
     * Function for updating database
     * @param {Object} event
     */
    function updateDb(field, value, oldValue) {
        if (value == oldValue) {
            var newValue = value;
            if (value instanceof Date)            
            {   
                var newValue = value.format('Y-m-d H:i:s');
            }
            Ext.Ajax.request( {  
                waitMsg: 'Saving changes...',
                url: config.url,
                method: 'POST',
                params: {  
                    field: field.name,
                    value: newValue,
                    originalValue: oldValue                                                                                                                             //when the response comes back from the server can we make an undo array?                         
                },
                failure: function(response, options){
                    Ext.MessageBox.alert('Warning','Failed to update cell...');
                },                                     
                success: function(response, options){
                }                                   
            }
        ); 
        }
    }; 
  
    
    /**
     * Generate Field definition from configuration
     */
    function getFields() {
        var fields =[new Ext.form.Hidden({fieldLabel: 'Context Id:',value: config.id,name: 'parameter_context_id'})];
        var i = 1;
        config.parameters.each( function(item){
            fields[i] = Biorails.Protocol.getEditor(item,null);
            fields[i].on('change',updateDb);
            i++;  
        });
        return fields;
    };
    
    Biorails.Protocol.ContextForm.superclass.constructor.call(this,{
        labelWidth: 75,
        frame: true,
        context: config,
        autoHeight: true,
        bodyStyle:'padding:5px 5px 0',
        defaults: {width: 400},
        defaultType: 'textfield',
        items : getFields()
    });  
    this.on('render', function(panel){ panel.enableDD();  });      
};

Ext.extend(Biorails.Protocol.ContextForm, Ext.form.FormPanel,{
    
    droppedParameter: function(source,event,data){
        if (data.node.leaf) {
            return Biorails.Protocol.addParameter(this.context_id,this.lock_version,data.node.id,0);  
        }
    },  
    /*
     * Custom Rendering function to add drop zone on grid after its rendered
     */    
    enableDD: function(){
        try{ 
            var dropzone = new Ext.dd.DropTarget(this.id, {
                ddGroup : 'parameterDD',
                context_id: this.context.id,
                lock_version : this.context.lock_version,
                panel: this,
                notifyDrop : this.droppedParameter  });
        } catch (e) {
            console.log('Problem with setup drop zone on Biorails.Protocol.ContextForm ');
            console.log(e);
        }        
    }   

});

//----------------------------------------  Protocol Context Definition Table ------------------------------------

Biorails.Protocol.ContextEditor = function(config) {

    var grid;
    var record;
    var store;
    var model;
    /*
     * Custom column renderer for cancel icon
     */
    function renderId(val){
        return '<img alt="remove" src="/images/enterprise/actions/cancel.png"/>';
    };

    /**
     * Handler for a cell click to call delete row if 1st column clicked
     */
    function cellClicked( grid, rowIndex,  columnIndex, event){
        if (columnIndex == 0){
            var record = store.getAt(rowIndex);
            Biorails.Protocol.removeParameter(record.data.id,1)
        }
    };    

    /**
     * Function for updating database
     * @param {Object} event
     */
    function saveCell(event) {
        if (event.value instanceof Date)            
        {   
            var fieldValue = event.value.format('Y-m-d H:i:s');
        } else
        {
            var fieldValue = event.value;
        }	
        Ext.Ajax.request( {  
            waitMsg: 'Saving changes...',
            url: '/processes/update_parameter/'+ event.record.data.id ,
            method: 'POST',
            params: { 
                field: event.field,
                value: event.value                                                                                                                             //when the response comes back from the server can we make an undo array?                         
            },
            failure: function(response, options){
                Ext.MessageBox.alert('Warning','Failed to update report...');
                store.rejectChanges();
            },                                     
            success: function(response, options){
                store.commitChanges();
            }                                   
        }
    ); 
    };  
    /**
     * Setup Context Ajax data loader
     */
    function setupStore(){
        record = Ext.data.Record.create([
            {name: 'id', type: 'int' },
            {name: 'column_no', type: 'int'},
            {name: 'description'},
            {name: 'style'},
            {name: 'name'},
            {name: 'default_value'},
            {name: 'regex'},
            {name: 'unit'},
            {name: 'assay_parameter_id', type: 'int'},
            {name: 'data_type_id', type: 'int'},
            {name: 'data_format_id', type: 'int'},
            {name: 'data_element_id', type: 'int'}]   );
    
        store = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({url: '/processes/context/'+config.id, method: 'GET'}),

            reader: new Ext.data.JsonReader({
                root: 'items',  totalProperty: 'total', id: 'id' },record),        
            remoteSort: true	
        });
        store.load();
    };
    
    /**
     * Setup Column Model
     */
    function setupColumns(){
        model = new Ext.grid.ColumnModel([
            { header: "Remove", width: 44, id:'id', renderer: renderId, dataIndex: 'id' },
            { header: "No.", width: 32, dataIndex: 'column_no'   },        
            { header: "Definition", width: 150, dataIndex: 'description' },        
            { header: "Style",  width: 80, dataIndex: 'style' },        
            { header: "Unit", width: 32,  dataIndex: 'unit' },        
            { header: "Name",    width: 90,  dataIndex: 'name',
                editor: new Ext.form.TextField({allowBlank: false,
                    maskRe: /^[A-Z,a-z,0-9,_]*$/,
                    invalidText: 'Only Alpha Numeric characters allowed',
                    blankText:'Parameters must have a name' }) 
            },        
            { header: "Default",   width: 180,  sortable: true,dataIndex: 'default_value', 
                editor: new Ext.form.TextField()        
            }]);

        model.defaultSortable =false;
    };

    setupStore();
    setupColumns();
    /**
     * Setup Context Model
     */
    Biorails.Protocol.ContextEditor.superclass.constructor.call(this,{ 
        store: store,        
        cm:    model ,
        context: config,
        viewConfig: {  forceFit: true  },
        autoHeight : true,
        width: Biorails.getWidth()-10,
        sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
        enableDragDrop: true,
        stripeRows: true,
        enableColumnMove: false,
        listeners:{
            scope:this,
            'mouseup':{scope:this.grid, fn:function(e, t){
                    var row;
                    if( (row = this.view.findRowIndex(t)) !== false)  this.rowMouseUp=row;
                    else this.rowMouseUp=false;
                }}
        },
        frame:true,
        iconCls:'icon-grid'
    });
    store.load();
    
    this.on('cellclick', cellClicked);
    this.addListener('afteredit', saveCell);
    this.on('render',  function(grid){ grid.enableDD();  });
}

Ext.extend(Biorails.Protocol.ContextEditor,Ext.grid.EditorGridPanel,{
    /** 
     * Handler for dropped parameters, checks if a node or row then moves or
     * adds parameter
     *
     */
    droppedParameter: function(source,event,data){
        if (data.node){
            if (data.node.leaf) {
                return Biorails.Protocol.addParameter(this.context_id,this.lock_version,data.node.id,1);  
            }
        }
        else if (data.rowIndex) {  
            var source_row = data.grid.store.getAt(data.rowIndex);                
            var dest_row  = this.grid.store.getAt( this.grid.rowMouseUp );
            return Biorails.Protocol.moveParameter( source_row.data.id,dest_row.data.id, 1);
        }
    },  
    /*
     * Custom Rendering function to add drop zone on grid after its rendered
     */    
    enableDD: function(){
        try{ 
            var dropzone = new Ext.dd.DropTarget(this.id, {
                grid: this,
                ddGroup : 'parameterDD',
                lock_version : this.context.lock_version,
                context_id: this.context.id,
                notifyDrop : this.droppedParameter }); 
            dropzone.addToGroup("GridDD"); 

        } catch (e) {
            console.log('Problem with setup drop zone on Biorails.Protocol.ContextEditor ');
            console.log(e);
        }        
    }
});


//----------------------------------------  Protocol Context ------------------------------------
/**
 * Protocol Context Editor and Preview Panel 
 *
 *  This Takes as protocol context as json and generate a suitable editor panel
 *
 */
Biorails.Protocol.Context = function(config,mode) {  
    var context = config; 
    var preview_panel= (config.default_count == 1 ? new Biorails.Protocol.ContextForm(config) : new Biorails.Protocol.ContextTable(config) );

    var editor_panel= new Biorails.Protocol.ContextEditor(config);

    var sizeField = new Ext.form.NumberField({
        fieldLabel: 'Default Count',
        name: 'default_count',
        value: 1,
        width:32,
        allowBlank:false});
    /**
     * Event Handler to show Preview
     */
    function showPreview() {
        preview_panel.show();
        editor_panel.hide();       
    };
   
    /**
     * Event Handler to show editor
     */
    function  showEditor(){
        preview_panel.hide();
        editor_panel.show();
    };  
    /**
     * Event Handler to show editor
     */
    function  edit(){
        Biorails.Protocol.editContext(context);
    }; 
    /** 
     * Build Panel with top/bottom panel functions set
     */
    Biorails.Protocol.Context.superclass.constructor.call(this,{
        layout:"card",
        context: config,
        tbar: [{
                text: 'Context ['+config.path+'] expected '+config.default_count+' rows',
                handler: function(panel){
                    edit();
                }
            },'->',{
                text:'Preview',
                tooltip:'Show as a table',                            
                handler: function(){
                    showPreview();
                },                                
                iconCls:'icon-list'
            },'-', {
                text:'Edit',
                tooltip:'Context editor to allow for customization',                            
                handler: function(){
                    showEditor();
                },                            
                iconCls:'icon-edit'
            }],
        bbar: [{ 
                text:'Add Child',
                iconCls:'icon-add',
                tooltip:'New Child context',
                handler: function(){
                    Biorails.Protocol.addContext(config.id);
                } 
            },'->', (config.parent_id == null ? "" : {
                text:'Remove',
                iconCls:'icon-cancel',
                tooltip:'Remove context and all children',                              
                handler: function(){
                    Biorails.Protocol.removeContext(config.id);
                } 
            })],
        activeItem: mode, // make sure the active item is set on the container config!
        bodyStyle: 'padding:1px',
        defaults: {  border:false  },         
        autoHeight: true,
        width: Biorails.getWidth()-5,
        autoWidth : false,
        autoScroll: false,
        items: [preview_panel,editor_panel]
    }); 
    //   this.on('render',    function(panel){ panel.enableDD();  });
};    

Ext.extend(Biorails.Protocol.Context, Ext.Panel,{});
  
