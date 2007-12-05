
Ext.namespace("Biorails");
Ext.namespace('Biorails.Protocol');
//----------------------------------------  Biorails Conceptural Tree ---------------------------------------------
Ext.namespace("Biorails.Protocol.ParameterTree");

Biorails.Protocol.ParameterTree = function(config){
    
    Biorails.Protocol.ParameterTree.superclass.constructor.call(this,Ext.apply(config,{
            title:'Study (Parameters)',
            minHeight: 400,
            autoShow: true, 
            autoHeight: true,
            autoScroll: true,
            layout: 'fit',           
			animate: true,
			enableDD: true,
            ddGroup:'parameterDD',
            iconCls:'icon-study', 
            root:  new Ext.tree.AsyncTreeNode({   text: 'Parameters',
                                                  expanded: true,  
                                                  draggable:false, id: 'root' }),
			loader: new Ext.tree.TreeLoader({ dataUrl:'/parameters/tree/'+config.study_id})
		}));
         
        this.on('notifyDrop',function(source,e,data) {   this.remove_parameter(data); });  
        
        this.on('dblclick',function(node,e) {      this.add_parameter(node);     });                  
};

Ext.extend(Biorails.Protocol.ParameterTree,  Ext.tree.TreePanel, {
  
  remove_parameter: function(source,e,data){
       try{ 
         if (data.grid) {
            var source_row = data.grid.store.getAt(data.rowIndex);                
            new Ajax.Request("/protocols/remove_parameter/"+  source_row.data.id,
                    {asynchronous:true,
                     evalScripts: true });
          }
        } catch (e) {
              console.log('Problem cant handle Dropped Item ');
              console.log(e);
        };
        return true;    
  },
  
  add_parameter: function (node){
      if (node.leaf) {
        new Ajax.Request('/protocols/add_parameter/'+this.process_id,
                {asynchronous:true,
                 evalScripts:true,
                 parameters:'id='+encodeURIComponent(node.id) }); 
        }
        return false;
  }  
} );

//----------------------------------------  Protocol Preview Context Table ------------------------------------

Biorails.Protocol.ContextTable = function(config) {
  var column_record;
  var column_store;
  var column_model;
    
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
                    column_store.rejectChanges();
                },                                     
                success: function(response, options){
                    column_store.commitChanges();
                }                                   
             }
        ); 
    };
    
  // Move column placement in table
  
  function columnMoved(oldColNo,newColNo)
  {
    var oldName = column_model.getColumnId(oldColNo);
    var newName = column_model.getColumnId(newColNo);
    var oldCol = column_model.getColumnById(oldName);
    var newCol = column_model.getColumnById(newName);
    Ext.Ajax.request( {  
          waitMsg: 'Saving changes...',
            url: '/protocols/move_parameter/'+newCol.parameter.id ,
            method: 'POST',
            params: { 
                after: oldCol.parameter.id                                                                                                                          //when the response comes back from the server can we make an undo array?                         
            },
            failure: function(response, options){
                Ext.MessageBox.alert('Warning','Failed to move column...');
                context_store.rejectChanges();
            },                                     
            success: function(response, options){
                context_store.commitChanges();
            }                                   
         }
    ); 
  };

/**
 * Generate a Record to 
 */
  function getRecord(){
        if (!column_record)
        {
            record = config.parameters.each(function(item){
                {name: item.name}
            })
            column_record = Ext.data.Record.create(record );
        }
        return column_record;
    };

  function getDataStore(){
        if (!column_store) {
            column_store = new Ext.data.Store({
              proxy: new Ext.data.HttpProxy({url: config.url, method: 'GET'}),

              reader: new Ext.data.JsonReader({
                  root: 'items',
                  totalProperty: 'total',
                  id: 'id'
                 },getRecord()),        
              remoteSort: true	
            })
        }
        return column_store;
    };

  function getColumnModel(){
        if (!column_model)
        {
           // Column model for report definition with label,filter and sort changable
          var columns =[];
          var i=0;
          config.parameters.each( function(item){ 
             columns[i] = {
               header: item.name,
               width: 120,
               sortable: true,
               parameter: item,
               dataIndex: item.name,
               editor: null
             }
             switch (item.data_type_id)   {
                   case 2 :  
                      columns[i].editor = new Ext.form.TextField({name: item.name,                                                               
                                                                    fieldLabel: item.name});
                      break;                      
                   case 3 : 
                      columns[i].editor = new Ext.form.DateField({name: item.name, 
                                                                  fieldLabel: item.name});
                      break;
                   case 4: 
                      columns[i].editor = new Ext.form.TimeField({name: item.name, 
                                                                  fieldLabel: item.name});
                      break;
                   case 5:  
                      columns[i].editor = new Biorails.ComboField({name: item.name, 
                                                              root_id: item.data_element_id, 
                                                              fieldLabel: item.name});
                      break;
                   case 6: 
                      columns[i].editor = new Ext.form.TextField({name: item.name, 
                                                            vtype: 'url', 
                                                            fieldLabel: item.name});
                      break;
                   case 7:  
                      columns[i].editor = new Biorails.FileComboField({name: item.name,
                                                                  folder_id: item.folder_id,
                                                                  fieldLabel: item.name});
                      break;
                   default:
                      columns[i].editor = new Ext.form.TextField({name: item.name, 
                                                                 fieldLabel: item.name});
                      break;
                };
             i++;   
            }); 
           column_model = new Ext.grid.ColumnModel(columns);
           column_model.defaultSortable =true;
       };
       return column_model;
    };
   
     
   Biorails.Protocol.ContextTable.superclass.constructor.call(this, {
            store: getDataStore(),        
            cm:    getColumnModel() ,
            viewConfig: {  forceFit: true  },
            width:'auto',
            clicksToEdit: 0,
            autoHeight : true,
            stripeRows: true,
            enableHdMenu: false,
            selModel: new Ext.grid.CellSelectionModel(),
            frame:true,
            iconCls:'icon-grid'
         });
    this.store.load();
    this.addListener('afteredit', saveCell);
    this.addListener('columnmove',columnMoved);

};

Ext.extend(Biorails.Protocol.ContextTable,Ext.grid.EditorGridPanel,{
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
    
  function getFields() {
      var fields =[];
      var i = 0;
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
    
    Biorails.Protocol.ContextForm.superclass.constructor.call(this,{
            labelWidth: 75,
            frame: true,
            autoHeight: true,
            bodyStyle:'padding:5px 5px 0',
            defaults: {width: 400},
            defaultType: 'textfield',
            items : getFields()
         });    
};

Ext.extend(Biorails.Protocol.ContextForm, Ext.form.FormPanel,{

 
/*
 * Custom Rendering function to add drop zone on grid after its rendered
 */    
   enableDD: function(){
       try{ 
            var dropzone1 = new Ext.dd.DropTarget(this.id, {
                panel: this,
                notifyDrop : this.addItem  });            
            dropzone1.addToGroup("parameterDD"); 
             

        } catch (e) {
              Ext.log('Problem with setup drop zone on folder grid ');
              Ext.log(e);
        }        
   }
});

//----------------------------------------  Protocol Context Definition Table ------------------------------------

Biorails.Protocol.ContextEditor = function(config) {

  var grid;
  var record;
  var store;
  var model;

  function renderId(val){
      return '<img alt="remove" src="/images/action/cancel.png"/>';
   };

// Delete a Columns row from the report
//
  function deleteRow(record) {
      Ext.Ajax.request( {  
            waitMsg: 'Deleting row...',
            url: '/protocols/remove_parameter',
            method: 'POST',
            params: {
                  id: record.data.id
              },
            failure: function(response, options){
                  Ext.MessageBox.alert('Warning','Failed to remove column from report...');
              },                                  
            success: function(response, options){
                  store.remove(record);
              }                             
           }
      ); 
    };
    
 function cellClicked( grid, rowIndex,  columnIndex, event){
    if (columnIndex == 0){
       var record = store.getAt(rowIndex);
       deleteRow(record);
    }
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
         {name: 'study_parameter_id', type: 'int'},
         {name: 'data_type_id', type: 'int'},
         {name: 'data_format_id', type: 'int'},
         {name: 'data_element_id', type: 'int'}]   );
    
    store = new Ext.data.Store({
          proxy: new Ext.data.HttpProxy({url: '/protocols/context/'+config.id, method: 'GET'}),

          reader: new Ext.data.JsonReader({
              root: 'items',
              totalProperty: 'total',
              id: 'id'
             },record),        
          remoteSort: true	
        });
    store.load();
  };
    
/**
 * Setup Column Model
 */
  function setupColumns(){
    model = new Ext.grid.ColumnModel([
      { id:'Id', 
        header: "Remove", 
        width: 20,  
        renderer: renderId,
        dataIndex: 'id'
      },
      { header: "No.",  
        width: 32, 
        sortable: true,
        dataIndex: 'column_no'
      },        
      { header: "Definition",  
        width: 120, 
        sortable: true,
        dataIndex: 'description'
      },        
      { header: "Style",  
        width: 50, 
        sortable: true,
        dataIndex: 'style'
      },        
      { header: "Unit",  
        width: 32, 
        sortable: true,
        dataIndex: 'unit'
      },        
      { header: "Name",  
        width: 75, 
        sortable: true,
        editor: new Ext.form.TextField(),
        dataIndex: 'name'
      },        
      { header:'Require',  
        width:32, 
        editor: new Ext.form.Checkbox(),
        dataIndex:'mandatory'
      },
      { header: "Default",    
        width: 120, 
        sortable: true, 
        editor: new Ext.form.TextField(),
        dataIndex: 'default_value'
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
            viewConfig: {  forceFit: true  },
            sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
            width:'auto',
            autoHeight : true,
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
    this.on('render',    function(grid){ grid.enableDD();  });
}

Ext.extend(Biorails.Protocol.ContextEditor,Ext.grid.EditorGridPanel,{
  
   addItem: function(source,event,data){
       try{ 
            new Ajax.Request('/protocols/add_parameter/'+this.config.id,
                {asynchronous:true, evalScripts:true,
                 parameters:'node='+encodeURIComponent(data.node.id) }); 
        } catch (e) {
              console.log('Problem cant handle Add Item ');
              console.log(e);
        } 
        return true;  
   },
   moveItem: function(source,event,data){
       try{ 
            var source_row = data.grid.store.getAt(data.rowIndex);                
            var dest_row  = this.grid.store.getAt( this.grid.rowMouseUp );

            new Ajax.Request("/protocols/move_parameter/"+  source_row.data.id,
                    {asynchronous:true, 
                     onComplete: function(req) { data.grid.store.load(); } ,
                     parameters:'after='+dest_row.data.id });                          
        } catch (e) {
              console.log('Problem cant handle move Item ');
              console.log(e);
        } 
        return true;  
   },    
/*
 * Custom Rendering function to add drop zone on grid after its rendered
 */    
   enableDD: function(){
       try{ 
            var dropzone1 = new Ext.dd.DropTarget(this.id, {
                grid: this,
                notifyDrop : this.addItem  });            
             dropzone1.addToGroup("parameterDD"); 
             
             var dropzone2 = new Ext.dd.DropTarget(this.id, {
                grid: this,
                ddGroup : 'GridDD',
                notifyDrop : this.moveItem  });

        } catch (e) {
              Ext.log('Problem with setup drop zone on context editor grid ');
              Ext.log(e);
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
Biorails.Protocol.Context = function(config) {  
   var preview_panel= (config.parent_id == null ? new Biorails.Protocol.ContextForm(config) : new Biorails.Protocol.ContextTable(config) );

   var editor_panel= new Biorails.Protocol.ContextEditor(config);
   
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
  * Event Handler to add  child context to the form
  */
   function addContext(){
     try{ 
         new Ajax.Request('/protocols/add_context/'+config.id,
                {asynchronous:true,
                 evalScripts:true }); 
        } catch (e) {
              console.log('Problem cant handle add context ');
              console.log(e);
        } 
   
   };
 /**
  * Event Handler to remove current context from the form
  */
   function removeContext(){
     try{ 
         new Ajax.Request('/protocols/remove_context/'+config.id,
                {asynchronous:true,
                 evalScripts:true}); 
        } catch (e) {
              console.log('Problem cant handle remove context ');
              console.log(e);
        } 
   
   };
/** 
 * Build Panel with top/bottom panel functions set
 */
  Biorails.Protocol.Context.superclass.constructor.call(this,{
        layout:"card",
        context: config,
        tbar: ['Context: '+config.path,'->', {
                    text:'Preview',
                    tooltip:'Show as a table',
                    href: '/content/new/'+config.folder_id,                              
                    handler: function(){
                        showPreview();
                    },                                
                    iconCls:'icon-preview'
                },'-', {
                    text:'Edit',
                    tooltip:'Context editor to allow for customization',                            
                    handler: function(){
                        showEditor();
                    },                            
                    iconCls:'icon-edit'
                }],
        bbar: ['->',{ 
                    text:'Add Child',
                    tooltip:'New Child context',
                    handler: function(){
                        addContext();
                    }, 
                    iconCls:'icon-file'
                },' ', {
                    text:'Remove',
                    tooltip:'Remove context and all children',                              
                    handler: function(){
                        removeContext();
                    }, 
                    iconCls:'icon-note'
                }],
        activeItem: 0, // make sure the active item is set on the container config!
        bodyStyle: 'padding:1px',
        defaults: {  border:false  },         
	    autoHeight: true,
 	   	autoWidth : false,
		autoScroll: false,
        items: [preview_panel,editor_panel]
   });   
   this.on('render',    function(panel){ panel.enableDD();  });
};    

Ext.extend(Biorails.Protocol.Context, Ext.Panel,{
    
   addParameter: function(source,event,data){
     try{ 
         new Ajax.Request('/protocols/add_parameter/'+this.context_id,
                {asynchronous:true,
                 evalScripts:true,
                 parameters:'node='+encodeURIComponent(data.node.id) }); 
        } catch (e) {
              console.log('Problem cant handle Add Parameter ');
              console.log(e);
        } 
        return true;  
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
                notifyDrop : this.addParameter  });

        } catch (e) {
              Ext.log('Problem with setup drop zone on context panel ');
              Ext.log(e);
        }        
   }
    
});

 //----------------------------------------  Biorails Context Panel Drop Zone------------------------------------

Biorails.Protocol.DropTarget =function(el,config) {
   Biorails.Protocol.DropTarget.superclass.constructor.call(this,el, 
       Ext.apply(config,{
            ddGroup:'parameterDD',
            overClass: 'dd-over'}));   
};

Ext.extend( Biorails.Protocol.DropTarget, Ext.dd.DropTarget, {

  notifyDrop: function (source,e,data) {
    new Ajax.Request('/protocols/add_parameter/'+this.context_id,
                {asynchronous:true,
                 evalScripts:true,
                 parameters:'node='+encodeURIComponent(data.node.id) }); 
        return false;

     }
});    
