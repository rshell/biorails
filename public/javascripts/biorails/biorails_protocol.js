
Ext.namespace("Biorails");

//----------------------------------------  Biorails Column Tree ---------------------------------------------
Ext.namespace('Biorails.Protocol');

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

//----------------------------------------  Biorails Conceptural Tree ---------------------------------------------
Ext.namespace("Biorails.ParameterTree");

Biorails.ParameterTree = function(config){
    
    Biorails.ParameterTree.superclass.constructor.call(this,Ext.apply(config,{
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
                
        this.on('dblclick',function(node,e) { 
            this.add_parameter(node) 
        });                  
}

Ext.extend(Biorails.ParameterTree,  Ext.tree.TreePanel, {
    
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

Biorails.Protocol.Preview = function(config) {
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


  // show details form on click on header  
  function columnDetails(grid,columnIndex,event)
  {
      var name = column_model.getColumnId(columnIndex);
      var column = column_model.getColumnById(name);
  }
  
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
                      columns[i].editor = new Ext.form.NumberField({name: item.name,                                                               
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
                                                            vtype: url, 
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
   
     
   Biorails.Protocol.Preview.superclass.constructor.call(this, {
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
            title: config.path,
            iconCls:'icon-grid'
         });
    this.store.load();
    this.addListener('afteredit', saveCell);
    this.addListener('columnmove',columnMoved);
    this.addListener('headerclick',columnDetails);

};

Ext.extend(Biorails.Protocol.Preview,Ext.grid.EditorGridPanel,{
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
            title: config.path,
            autoHeight: true,
            bodyStyle:'padding:5px 5px 0',
            defaults: {width: 400},
            defaultType: 'textfield',
            items : getFields()
         });    
};

Ext.extend(Biorails.Protocol.ContextForm, Ext.form.FormPanel,{

});

//----------------------------------------  Protocol Context Definition Table ------------------------------------

Biorails.Protocol.ContextTable = function(config) {

  var grid;
  var record;
  var store;
  var model;

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
    Biorails.Protocol.ContextTable.superclass.constructor.call(this,{ 
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
            title:'Definition of '+config.path,
            iconCls:'icon-grid'
         });
    store.load();
    this.on('render',    function(grid){ grid.enableDD();  });
}

Ext.extend(Biorails.Protocol.ContextTable,Ext.grid.EditorGridPanel,{
  
   addItem: function(source,event,data){
       try{ 
            new Ajax.Request('/protocols/add_parameter/'+this.config.id,
                {asynchronous:true, evalScripts:true,
                 parameters:'node='+encodeURIComponent(data.node.id) }); 
        } catch (e) {
              console.log('Problem cant handle Dropped Item ');
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
              console.log('Problem cant handle Dropped Item ');
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
              Ext.log('Problem with setup drop zone on folder grid ');
              Ext.log(e);
        }        
   }

});


//----------------------------------------  Protocol Context ------------------------------------

Biorails.Protocol.Context = function(config) {
   if (config.parent_id > 0) {
       return new Biorails.Protocol.Preview(config);
   } else  {
       return new Biorails.Protocol.ContextForm(config);
   };
}    
