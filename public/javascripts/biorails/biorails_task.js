
Ext.namespace("Biorails");
Ext.namespace('Biorails.Task');
/**
 * Core protocol related static functions to change ajax calls to 
 * update the status of protocol on the server
 */
Biorails.Task = function(){
    
return {
 /**
  * Add a new child context
  */
   addRow: function(context_id){       
     try{ 
        Ext.MessageBox.prompt('Add rows', 'How Many rows do you want to append? :', function(btn,name){
            if (btn =='ok'){
                 new Ajax.Request('/tasks/add_context/'+context_id, 
                            {asynchronous:true, evalScripts:true,
                             parameters:'name='+encodeURIComponent( name ) }); 
            }
         });
        } catch (e) {
              console.log('Problem cant handle add rows ');
              console.log(e);
        } 
   
   },
 /** 
  * Remove a context from the treee
  */
   removeRow: function(context_id){
     try{ 
        Ext.MessageBox.confirm('Remove row', 'Are you sure you want to remove this row?', function(btn){
            if (btn =='yes'){
                new Ajax.Request('/tasks/remove_context/'+context_id, {asynchronous:true, evalScripts:true }); 
            }
         });
        } catch (e) {
              console.log('Problem cant handle remove row ');
              console.log(e);
        } 
   
   },
/**
 * Remove a parameter from a context
 */
  saveValue: function(context_id,parameter_id,value){
       try{ 
            Ext.MessageBox.confirm('Remove Parameter', 'Are you sure you want to remove this parameter?', function(btn){
                if (btn =='yes'){
                    new Ajax.Request("/protocols/remove_parameter/"+  parameter_id,
                            {asynchronous:true, evalScripts: true,
                             parameters:{ mode: mode }
                         });
                 };
              });
        } catch (e) {
              console.log('Problem cant handle Dropped Item ');
              console.log(e);
        };
        return true;    
  }
  }
}();

//----------------------------------------  Protocol Preview Context Table ------------------------------------

Biorails.Task.ContextTable = function(config) {
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
                    column: event.record.data.id,
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
   var fields =[{name: "row_group"}, 
                 {name: "row_label"}, 
                 {name: "row_no", type:'int'}];
      var i=3;
      config.parameters.each( function(item){ 
         fields[i] = { name: item.index, type: 'string'  }
         i++;   
        }); 
                
      store = new Ext.data.GroupingStore({
            reader: new Ext.data.JsonReader({idProperty:'id',fields: fields}),
            data: config.data,
            sortInfo:{field: 'row_no', direction: "ASC"},
            groupField:'row_group'
        });
    return store;
  };

 /**
  * Geneate a Column View based on passed context 
  */
  function getModel(){
    if (!model)
    {
      var columns =[{header: "row_group",width:50, dataIndex: "row_group"}, 
                    {header: "row_no", width:24,   dataIndex: "row_no"},
                    {header: "row_label",width:32, dataIndex: "row_label"}];
      var i=3;
      config.parameters.each( function(item){ 
         columns[i] = {
           header: item.name,
           width: 75,
           sortable: false,
           parameter: item,
           dataIndex: item.index,
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
   Biorails.Task.ContextTable.superclass.constructor.call(this, {
            store: getStore(),        
            cm:    getModel() ,
            clicksToEdit: 0,
            width: 800,
            autoHeight:true,
            view: new Ext.grid.GroupingView({
                forceFit:true,
                showGroupName: false,
                enableNoGroups:false, // REQUIRED!
                hideGroupedColumn: true
            }),
            stripeRows: true,
            selModel: new Ext.grid.CellSelectionModel(),
            frame:true,
            collapsible: false,
            animCollapse: false,
            trackMouseOver: false,
            enableColumnMove: false,
            title: config.path,
            iconCls: 'icon-grid'
         });
    /**
     * Add handler to save cell after edit
     */
    this.addListener('afteredit', saveCell);
    //this.on('render',    function(panel){ panel.enableDD();  });

};

Ext.extend(Biorails.Task.ContextTable,Ext.grid.EditorGridPanel,{
/**
 * Function to add a dropped a parameter
 */
   add: function(source,event,data){
      if (data.node.leaf) {
         return Biorails.Task.addParameter( this.context_id, data.node.id, 0);  
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
                panel: this,
                notifyDrop : this.add });

        } catch (e) {
              console.log('Problem with setup drop zone on Biorails.Task.ContextTable ');
              console.log(e);
        }        
   }


});


//----------------------------------------  Protocol Preview Context Form ---------------------------------------------

Biorails.Task.ContextForm = function(config) {
    
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
        switch(item.data_type_id)
           {
           case 1:
               fields[i] = new Ext.form.TextField({
                 name: item.name, 
                 listeners: { change:   updateDb },
                 fieldLabel: item.name});
              break;
           case 2:
              fields[i] = new Ext.form.TextField({
                  name: item.name, 
                  listeners: { change:   updateDb },
                  fieldLabel: item.name});
              break;
           case 3:
              fields[i] = new Ext.form.DateField({
                  name: item.name, 
                  listeners: { change:   updateDb },
                  fieldLabel: item.name});
              break;
           case 4:
               fields[i] = new Ext.form.TimeField({
                  name: item.name, 
                  listeners: { change:   updateDb },
                  fieldLabel: item.name});
              break;
           case 5:
              fields[i] =  new Biorails.ComboField({
                  name: item.name, 
                  listeners: { change:   updateDb },
                  root_id: item.data_element_id, 
                  fieldLabel: item.name});
              break;
           case 6:
              fields[i] =  new Ext.form.TextField({
                  name: item.name, 
                  listeners: { change:   updateDb },
                  fieldLabel: item.name});
              break;
           case 7:
              fields[i] =  new Biorails.FileComboField({
                   name: item.name,
                   listeners: { change:   updateDb },
                   folder_id: item.folder_id,
                   fieldLabel: item.name});
              break;
           default:
              fields[i] =  new Ext.form.TextField({
                  name: item.name, 
                  listeners: { change:   updateDb },
                  fieldLabel: item.name});
              break;
           };
           i++;  
        });
        return fields;
    };
    
    Biorails.Task.ContextForm.superclass.constructor.call(this,{
            labelWidth: 75,
            frame: true,
            context: config,
            autoHeight: true,
            bodyStyle:'padding:5px 5px 0',
            defaults: {width: 400},
            defaultType: 'textfield',
            items : getFields()
         });  
    //this.on('render', function(panel){ panel.enableDD();  });      
};

Ext.extend(Biorails.Task.ContextForm, Ext.form.FormPanel,{
    
   droppedParameter: function(source,event,data){
      if (data.node.leaf) {
         return Biorails.Protocol.addParameter(this.context_id,data.node.id,0);  
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
                panel: this,
                notifyDrop : this.droppedParameter  });
        } catch (e) {
              console.log('Problem with setup drop zone on Biorails.Protocol.ContextForm ');
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
Biorails.Task.Context = function(config) {  
   var context = config; 
   // (config.default_count == 1 ? new Biorails.Task.ContextForm(config,data) :
   var preview_panel=  new Biorails.Task.ContextTable(config);
/** 
 * Build Panel with top/bottom panel functions set
 */
  Biorails.Task.Context.superclass.constructor.call(this,{
        layout:"card",
        context: config,
        tbar: [{
                    text: 'Context ['+config.path+']  ',
                    handler: function(panel){
                        edit();
                    }
                },'->'],
        bbar: [{ 
                    text:'Add Row',
                    iconCls:'icon-add',
                    tooltip:'New Child context',
                    handler: function(){
                        Biorails.Protocol.addContext(config.id);
                    }
                }],
        bodyStyle: 'padding:1px',
        defaults: {  border:false  },         
	    height: 100,         
 	   	autoWidth : false,
		autoScroll: false,
        items: preview_panel
   }); 
//   this.on('render',    function(panel){ panel.enableDD();  });
};    

Ext.extend(Biorails.Task.Context, Ext.Panel,{});
  
