
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
                        value: value,
                        autoShow: true,
                        fieldLabel: item.name});
                    break;
                case 3 : 
                    return new Biorails.DateField({
                        name: item.name,
                        format: 'Y-m-d',
                        autoShow: true,
                        value: value,
                        fieldLabel: item.name});
                    break;
                case 4: 
                    return new Ext.form.TimeField({
                        name: item.name,
                        autoShow: true,
                        value: value,
                        fieldLabel: item.name});
                    break;
                case 5:  
                    return new Biorails.ComboField({
                        name: item.name,
                        value: value,
                        autoShow: true,
                        url: '/admin/element/select/' + item.data_element_id,
                        root_id: item.data_element_id,
                        fieldLabel: item.name});
                    break;
                case 6: 
                    return new Ext.form.TextField({
                        name: item.name,
                        value: value,
                        vtype: 'url',
                        autoShow: true,
                        fieldLabel: item.name});
                    break;
                case 7:  
                    return new Biorails.FileComboField({
                        name: item.name,
                        value: value,
                        autoShow: true,
                        folder_id: item.folder_id,
                        fieldLabel: item.name});
                    break;
                default:
                    return new Ext.form.TextField({
                        name: item.name,
                        autoShow: true,
                        value: value,
                        fieldLabel: item.name});
                    break;
            };
        },  
        getRenderer: function(item) {
            switch (item.data_type_id)   {                    
//                case 3 : 
//                    return function(v){
//                        return Ext.util.Format.date(v,'Y-m-d');
//                    }; 
//                    break;
              
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
                        },
                        new Ext.form.ComboBox({
                            store: ['default','form','scaled','rotated','split'],
                            fieldLabel: 'Output Style',
                            typeAhead: false,
                            forceSelection: true,
                            editable: true,
                            allowBlank: false,
                            value:'default',
                            name: 'output_style'
                        })]
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
                                    form.getForm().getEl().dom.action= form.url;
                                    form.getForm().getEl().dom.submit();
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
                        },  new Ext.form.ComboBox({
                            store: ['default','form','scaled','rotated','split'],
                            fieldLabel: 'Output Style',
                            typeAhead: false,
                            forceSelection: true,
                            editable: true,
                            allowBlank: false,
                            mode: 'local',
                            value:config.output_style,
                            name: 'output_style'
                        })]
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
                                    form.getForm().getEl().dom.action= form.url;
                                    form.getForm().getEl().dom.submit();

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
        title:'Assay Parameters',
        minHeight: 400,
        autoShow: true, 
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',           
        animate: true,
        enableDD: true,
        ddGroup:'parameterDD',
        ddText: 'drag and drop context to add a column',
        iconCls:'icon-assay', 
        root:  new Ext.tree.AsyncTreeNode({   text: 'Parameters',
            expanded: true,  
            draggable:false, id: 'root' }),
        loader: new Ext.tree.TreeLoader({ dataUrl:'/parameters/tree/'+config.assay_id})
    }));
        
};

Ext.extend(Biorails.Protocol.ParameterTree,  Ext.tree.TreePanel, {} );

//----------------------------------------  Protocol Preview Context Table ------------------------------------

Biorails.Protocol.ContextTable = Ext.extend(Ext.grid.EditorGridPanel,{
    rowMouseUp: 0,
    initComponent : function() {
        /**
         * Generate a Record from current context
         * Generate a fake data store for preview (currenly linked to server)
         */
        record = this.context.parameters.each( function(item){
            {name: item.name}
        });

        var row =[];
        var i=0;
        row = this.context.parameters.each( function(item){
            row[i] = item.default_value;
            i++
        });
        rows = []
        for(i=0;i<this.context.default_count;i++) {
            rows[i] = row;
        };
        //store = new Ext.data.SimpleStore({  fields: record});
        //store.loadData([row,row])
        store = new Ext.data.Store({
            data: {
                id: this.context.id,
                total: 2,
                items: rows
            },
            pruneModifiedRecords: true,
            reader: new Ext.data.JsonReader({
                root: 'items',
                totalProperty: 'total',
                id: 'id' },
            record),
            remoteSort: false
        });
        // Column model for report definition with label,filter and sort changable
        var columns =[];
         i= 0;
        this.context.parameters.each( function(item){
            columns[i] = {
                header: item.name,
                width: 100,
                sortable: false,
                resizable: true,
                parameter: item,
                dataIndex: item.name,
                renderer: Biorails.Protocol.getRenderer(item),
                editor: Biorails.Protocol.getEditor(item,item.default_value)
            }
            i++;
        });
        model = new Ext.grid.ColumnModel(columns);
        model.defaultSortable =true;

        Ext.apply(this, {
            store: store,
            cm:    model ,
            viewConfig: {  forceFit: true  },
            autoHeight : true,
            layoutOnTabChange:true,
            width: Biorails.getWidth()-10,
            sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
            enableDragDrop: true,
            stripeRows: true,
            loadMask: true,
            enableColumnMove: false,
            iconCls:'icon-grid',
            clicksToEdit: 0
        });
        // finally call the superclasses implementation
        Biorails.Protocol.ContextTable.superclass.initComponent.call(this);
        this.on('afteredit', this.saveCell,this);
        this.on('mouseup', this.getCurrentRow, this);
    },
    getCurrentRow: function(e, t){
                 var row;
                 if( (row = this.view.findRowIndex(t)) !== false)  {
                    this.rowMouseUp=row;
                 }else {
                    this.rowMouseUp=false;
                 }
    },
    saveCell: function(event) {
         var fieldValue =null;
        if (event.value instanceof Date)            
        {   
             fieldValue = event.value.format('Y-m-d H:i:s');
        } else
        {
            fieldValue = event.value;
        }	
        Ext.Ajax.request( {  
            waitMsg: 'Saving changes...',
            url: this.context.url,
            asynchronous:true,
            evalJS:true,
            method: 'POST',
            params: { 
                id: event.record.data.id,
                column: {id: event.record.data.id},
                field: event.field,
                value: event.value,
                originalValue: event.record.modified
                //when the response comes back from the server can we make an undo array?
            },
            failure: function(response, options){
                Ext.MessageBox.alert('Warning','Failed to update report...');
                store.rejectChanges();
            },                                     
            success: function(response, options){
                store.commitChanges();
            }                                   
        }
    )} ,
    /**
     * Function to add a dropped a parameter
     */
    add: function(source,event,data){
        if (data.node.leaf) {
            return Biorails.Protocol.addParameter( this.context_id, this.lock_version, data.node.id, 0);
        }
        return null;
    }

});


//----------------------------------------  Protocol Preview Context Form ---------------------------------------------

Biorails.Protocol.ContextForm = Ext.extend( Ext.form.FormPanel, {
    
    initComponent : function() {
        fields =[new Ext.form.Hidden({
                fieldLabel: 'Context Id:',
                value: this.context.id,
                name: 'parameter_context_id'})];
        var i = 1;
        this.context.parameters.each( function(item){
            fields[i] = Biorails.Protocol.getEditor(item,null);
            fields[i].on('change',this.updateDb);
            i++;
        });

        Ext.apply(this, {
            labelWidth: 150,
            frame: true,
            autoHeight: true,
            autoWidth: true,
            layoutOnTabChange:true,
            bodyStyle:'padding:5px 5px 0',
            defaults: {width: 400},
            defaultType: 'textfield',
            items : fields
        });
        // finally call the superclasses implementation
        Biorails.Protocol.ContextForm.superclass.initComponent.call(this);

        this.on('afteredit', this.saveCell);
    },
    /**
     * Function for updating database
     * @param {Object} event
     */
    updateDb: function(field, value, oldValue) {
        if (value == oldValue) {
            var newValue = value;
            if (value instanceof Date)
            {
                 newValue = value.format('Y-m-d H:i:s');
            }
            Ext.Ajax.request( {
                waitMsg: 'Saving changes...',
                url: config.url,
                method: 'POST',
                params: {
                    field: field.name,
                    value: newValue,
                    originalValue: oldValue
                    //when the response comes back from the server can we make an undo array?
                },
                failure: function(response, options){
                    Ext.MessageBox.alert('Warning','Failed to update cell...');
                },
                success: function(response, options){
                }
            }
        );
        }
    },  
    /**
     * Generate Field definition from configuration
     */
    getFields: function() {
        return fields;
    }
});

//----------------------------------------  Protocol Context Definition Table ------------------------------------

Biorails.Protocol.ContextEditor = Ext.extend( Ext.grid.EditorGridPanel,{
    rowMouseUp: 0,

    initComponent : function() {
        /**
         * Setup Context Ajax data loader
         */
        record = Ext.data.Record.create([
            {name: 'id', type: 'int' },
            {name: 'column_no', type: 'int'},
            {name: 'description'},
            {name: 'style'},
            {name: 'name'},
            {name: 'mandatory'},
            {name: 'default_value'},
            {name: 'regex'},
            {name: 'unit'},
            {name: 'assay_parameter_id', type: 'int'},
            {name: 'data_type_id', type: 'int'},
            {name: 'data_format_id', type: 'int'},
            {name: 'data_element_id', type: 'int'}]   );

        store = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: '/processes/context/'+this.context.id,
                method: 'GET'
            }),

            reader: new Ext.data.JsonReader({
                root: 'items',
                totalProperty: 'total',
                id: 'id'
            },record),
            remoteSort: true
        });
       store.load();
        /**
         * Setup Column Model
         */
        model = new Ext.grid.ColumnModel([
            { header: "Remove", width: 44, id:'id', renderer: this.renderId, dataIndex: 'id' },
            { header: "No.", width: 32, dataIndex: 'column_no'   },
            { header: "Definition", width: 150, dataIndex: 'description' },
            { header: "Style",  width: 80,  dataIndex: 'style' },
            { header: "Unit", width: 32,    dataIndex: 'unit' },
            { header: "Mandatory",width:32, 
                dataIndex: 'mandatory',
                editor: new Ext.form.TextField()},
            { header: "Name",    width: 90,  dataIndex: 'name',
                editor: new Ext.form.TextField({allowBlank: false,
                    maskRe: /^[A-Z,a-z,0-9,_]*$/,
                    invalidText: 'Only Alpha Numeric characters allowed',
                    blankText:'Parameters must have a name' })
            },
            {   header: "Default",
                width: 180,
                sortable: true,
                dataIndex: 'default_value',
                editor: new Ext.form.TextField()
            }
        ]);

        model.defaultSortable =false;
        /**
         * Setup Context Model
         */
        Ext.apply(this, {
            store: store,
            cm:    model ,
            viewConfig: {  forceFit: true  },
            autoHeight : true,
            width: Biorails.getWidth()-10,
            sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
            enableDragDrop: true,
            ddGroup : 'paramDD',
            ddText: 'drag and drop over another row to swap positions',
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
        // finally call the superclasses implementation
        Biorails.Protocol.ContextEditor.superclass.initComponent.call(this);
        this.on('mouseup', this.getCurrentRow, this);
        this.on('cellclick', this.cellClicked,this);
        this.on('afteredit', this.saveCell,this);
        this.on('render', function(panel){
            panel.enableDD();
        },this);
    },
    getCurrentRow: function(e, t){
                 var row;
                 if( (row = this.view.findRowIndex(t)) !== false)  {
                    this.rowMouseUp=row;
                 }else {
                    this.rowMouseUp=false;
                 }
    },
    /*
     * Custom column renderer for cancel icon
     */
    renderId:  function(val){
        return '<img alt="remove" src="/images/enterprise/actions/cancel.png"/>';
    },
    /**
     * Handler for a cell click to call delete row if 1st column clicked
     */
    cellClicked:  function( grid, rowIndex,  columnIndex, event){
        if (columnIndex == 0){
            var record = this.store.getAt(rowIndex);
            Biorails.Protocol.removeParameter(record.data.id,2)
        }
    },
    /**
     * Function for updating database
     * @param {Object} event
     */
    saveCell:  function(event) {
        var fieldValue = null;
        if (event.value instanceof Date)
        {
            fieldValue = event.value.format('Y-m-d H:i:s');
        } else
        {
            fieldValue = event.value;
        }
        Ext.Ajax.request( {
            waitMsg: 'Saving changes...',
            url: '/processes/update_parameter/'+ event.record.data.id ,
            method: 'post',
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
    },
    /**
     * Handler for dropped parameters, checks if a node or row then moves or
     * adds parameter
     *
     */
    movedParameter: function(source,event,data){
        if (data.rowIndex!= null) {
            var source_row = data.grid.store.getAt(data.rowIndex);
            var dest_row  = this.grid.store.getAt( data.grid.rowMouseUp );
            return Biorails.Protocol.moveParameter( source_row.data.id,dest_row.data.id, 2);
        }
        return null;
    },
    /*
     * Custom Rendering function to add drop zone on grid after its rendered
     */
    enableDD: function(){
        try{
            var dropzone = new Ext.dd.DropTarget(this.id, {
                grid: this,
                ddGroup : 'paramDD',
                lock_version : this.context.lock_version,
                context_id: this.context.id,
                notifyDrop : this.movedParameter });
            dropzone.addToGroup("paramDD");

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
Biorails.Protocol.Context = Ext.extend(Ext.Panel, {
    initComponent : function() {
           table_panel = new Biorails.Protocol.ContextTable( {id:this.id+"_0", context: this.context } );
           form_panel = new Biorails.Protocol.ContextForm( { id:this.id+"_1", context: this.context } );
           editor_panel = new Biorails.Protocol.ContextEditor( {id:this.id+"_2", context: this.context } );

        var sizeField = new Ext.form.NumberField({
            fieldLabel: 'Default Count',
            name: 'default_count',
            value: 1,
            width:32,
            allowBlank:false});

        Ext.apply(this, {
            layout:"card",
            activeItem: this.mode,
            layoutOnTabChange:true,
            tbar: [{
                    text: 'Context ['+this.context.path+'] expected '+this.context.default_count+' rows',
                    context: this.context,
                    handler: function(panel){
                      Biorails.Protocol.editContext(this.context);
                    }
                },'->',{
                    text:'Table',
                    tooltip:'Preview the block as a table',
                    panel: this,
                    handler: this.showTable,
                    iconCls:'icon-list'
                },'-', {
                    text:'Form',
                    tooltip:'Show the block as a form',
                    panel: this,
                    handler: this.showForm,
                    iconCls:'icon-show'
                },'-', {
                    text:'Customize',
                    tooltip:'Context editor to allow for customization',
                    panel: this,
                    handler: this.showEditor,
                    iconCls:'icon-edit'
                }],
            bbar: [{
                    text:'Add Child',
                    iconCls:'icon-add',
                    context: this.context,
                    tooltip:'New Child context',
                    handler: function(){
                        Biorails.Protocol.addContext( this.context.id );
                    }
                },'->', (this.context.parent_id == null ? "" : {
                    text:'Remove',
                    iconCls:'icon-cancel',
                    context: this.context,
                    tooltip:'Remove context and all children',
                    handler: function(){
                        Biorails.Protocol.removeContext(this.context.id);
                    }
                })],
            defaults: {  border:false  },
            autoHeight: true,
            autoWidth : true,
            width: Biorails.getWidth()-10,
            autoScroll: false,
            items: [table_panel,form_panel,editor_panel]

        });
        if (Ext.isIE6) {
            Ext.apply(this, {
                autoWidth : false,
                width: Biorails.getWidth()
            });
        }
        // finally call the superclasses implementation
        Biorails.Protocol.Context.superclass.initComponent.call(this);
        this.on('render', function(panel){
            panel.enableDD();
        },this);
    },
    /*
     * Change panels to display the Table view
     */
    showTable: function(item){
       Ext.getCmp(item.panel.id+"_1").hide();
       Ext.getCmp(item.panel.id+"_2").hide();
       panel = Ext.getCmp(item.panel.id+"_0");
       panel.show();
       panel.enable();
       panel.doLayout(false);
       item.panel.mode = 0;
    },
    /*
     * Change panels to display the Form view
     */
    showForm: function(item){
       Ext.getCmp(item.panel.id+"_0").hide();
       Ext.getCmp(item.panel.id+"_2").hide();
       panel = Ext.getCmp(item.panel.id+"_1");
       panel.show();
       panel.enable();
       panel.doLayout(false);
       item.panel.mode = 1;
    },
    /*
     * Change panels to display the Editor
     */
    showEditor: function(item){
       Ext.getCmp(item.panel.id+"_0").hide();
       Ext.getCmp(item.panel.id+"_1").hide();
       panel = Ext.getCmp(item.panel.id+"_2");
       panel.show();
       panel.enable();
       panel.doLayout(false);
       item.panel.mode = 2;
    },
    /**
     * Handler for dropped parameters, checks if a node or row then moves or
     * adds parameter
     *
     */
    droppedParameter: function(source,event,data){
        if (data.node){
            if (data.node.leaf) {
                return Biorails.Protocol.addParameter(this.context_id,this.lock_version,data.node.id,this.grid.mode);
            }
        }       
        return null;
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

  
