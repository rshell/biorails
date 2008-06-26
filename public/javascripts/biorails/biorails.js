/////////////////////////////////////////////////////////////////////////////////////
// Biorails Application Javascript Support codde
//
//
// Created by:
//      Robert Shell - http://biorails.com
//
// License:
//      GNU General Public License version 2.0
//      http://www.gnu.org/licenses/gpl.html
//
// Bugs:
//      Please submit bug reports to http://biorails.org
//
/////////////////////////////////////////////////////////////////////////////////////
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var VK_LEFT = 0x25;
var VK_UP = 0x26;
var VK_RIGHT = 0x27;
var VK_DOWN = 0x28;
var VK_RETURN = 13;
var VK_TAB = 9;

/**
 * Simple default spinner for ajax call active on in the header
 */
Ajax.Responders.register({
    onCreate: function() {
        if (Ajax.activeRequestCount > 0)
	{
            document.body.style.cursor = 'wait';
            Element.show('busy-indicator');
	}
    },
    onComplete: function() {
        if (Ajax.activeRequestCount == 0)
        {
            document.body.style.cursor = 'default';
            Element.hide('busy-indicator');

	}    
    }
});

// Make sure there a console to report errors to in some form or other
// [use firebug plugin to firefox for real development]
//
if (!window.console || !console.firebug)
{
    var names = ["log", "debug", "info", "warn", "error", "assert", "dir", "dirxml",
        "group", "groupEnd", "time", "timeEnd", "count", "trace", "profile", "profileEnd"];

    window.console = {};
    for (var i = 0; i < names.length; ++i)
        window.console[names[i]] = function() {}
}

/*
 * simple RegEx match tester
 */
function RegExMatchCheck(mask,subject) {
    try{
        re = new RegExp(mask);
        if (re.test(subject.value)) {
            subject.style.background = "#99FF99";
            alert("passed mask /"+mask+"/ matches: "+subject.value );
        } else {
            subject.style.background = "#FFAAAA";
            alert("failed");
        }
    } catch (e) {
        console.log(e);
    } 
    
}

/*
 * simple RegEx match hifhligher
 */
function RegExMatchOnKey(mask,subject) {
    try{
        re = new RegExp(mask);
        if (re.test(subject.value)) {
            subject.style.background = "#99FF99";
        } else {
            subject.style.background = "#FFAAAA";
        }
    } catch (e) {
        console.log(e);
    } 
}
    
Ext.BLANK_IMAGE_URL = '/images/s.gif';
Ext.ux.grid.filter.StringFilter.prototype.icon = 'img/find.png';
Ext.ux.menu.RangeMenu.prototype.icons = {
    gt: '/images/greater_then.png',
    lt: '/images/less_then.png',
    eq: '/images/equals.png'
};

    
Ext.namespace("Biorails");
//---------------------------------------- Core Biorails ----------------------------------------------------------
//
// Main biorails client application code.
// Licence GNU 2.0 see biorails.org project site for details
//
Biorails = function(){
    //
    // Internal State of the Client Application
    //
    var _instance = null;
    var _version = '0.1';
    var _model = 'Compound';
    var _controller = 'compounds';
    var _columns = [];
    var _fields = [];
    var _filters = [];

    var _toolbar = null;
    var _base_url = null;
    var _viewport = null;
    var _center_panel = null;
    var _folder_panel = null;
    var _document_panel = null;

    var searchField = new Ext.form.TextField({
        fieldLabel: 'search',
        name: 'first',
        width:175,
        allowBlank:false});  
    //
    // Manage Free Text Search Click
    //
    function onSearchClick(btn){
        new Ajax.Request('/finder/search',
        {asynchronous:true,
            evalScripts:true,
            parameters:'text='+encodeURIComponent(searchField.getValue()) });
        return false;
    };
    //
    // Chick on a Menu
    //
    function clickMenu(e) {
        if (e.ajax) {
            this.base_url = e.url;
            new Ajax.Request(e.url,{
                method: 'get',
                evalScripts: true
            });
        } else {

        };
    };
    /*
     * Handling a element dropped onto the clipboard work brench
     *
     */
    function dropOnClipboard(dd,e,data) {
        try{
            // Test for case of a row from a grid
            if (data.grid) {
                source_row = data.grid.store.getAt(data.rowIndex);
                new Ajax.Request("/finder/add_clipboard/"+source_row.data.id,
                {asynchronous:true, evalScripts:true});
            }
            // Test for case of a node from a folder tree
            else if (data.node) {
                new Ajax.Request("/finder/add_clipboard/"+data.node.id,
                {asynchronous:true, evalScripts:true});
            }
        } catch (e) {
            console.log('Problem with drop ');
            console.log(e);
        }
        return true;
    };
    //------------------ Main Layout ------------------------------------------------------------------------
    // West: Navigation with project tree and actions for current controller
    // East: Extras with help, work brench and current status messages
    // North: Simple toolbar
    // South: Audting and history information
    // Centre: Main tab + accessaries tabs for grids etc.
    //
    //
    // Default Toolbar
    //
    function create_layout(toolbar_items){  
     items =  toolbar_items.concat([
            '->',
            searchField,
            {text: 'Search',handler: onSearchClick},
            {text: "Logout",  iconCls:'icon-logout' ,  handler: function(){window.location='/logoff'} ,scope: this  }                
        ])       
     _toolbar =  new Ext.Toolbar({ items: items});

    // region -----------------------North------------------------------

    _north_panel = new Ext.Panel({
        region:"north", height: 24, autoShow: true, el: 'toolbar-panel', tbar: _toolbar 
    });
    
    // region -----------------------West------------------------------
    _actions_panel = new Ext.Panel({
        title:'Menu Actions', iconCls:'icon-action', contentEl: 'actions-panel', border:false, autoScroll: true  
    } );

    _work_panel = new Ext.Panel({
        xtype:"panel", autoScroll: true, contentEl: 'work-tab', id: 'work-id', title:"Clipboard", iconCls: 'icon-clipboard'
    }  );

    _west_panel = new Ext.Panel( {
        region:"west",
        title:"Navigation",
        iconCls:'icon-navigation',
        id:'nav-id',
        split:true,
        stateId: 'West',
        stateful: true,
        stateEvents: ["collapse","expand"],
        getState: function() { 
            state = {collapsed:  this.collapsed};
            return state;
        },                               
        applyState : function(state) {
            try{
              if (state){
                  if (this.collapsed != state.collapsed) {
                      this.toggleCollapse(false);              
                  }
              }
            } catch (e) {
                console.log('Problem with main javascript ');
                console.log(e);
           }    
        },
        restoreState : function() {
            var state = Ext.state.Manager.get(this.stateId);
            this.applyState(state);
        },     
        collapsible:true,
        useSplitTips: true,
        titleCollapse:true,
        width: 140,
        minHeight: 600,
        minSize: 100,
        maxSize: 400,
        layout:'accordion',
        layoutConfig:{     animate:true   },
        items: [ _actions_panel, _work_panel]
    });


    // region -----------------------East------------------------------
    _status_panel = new Ext.Panel({
        xtype:"panel",
        layout:'fit',
        contentEl: 'status-tab',
        autoDestroy: true,
        autoScroll: true,
        id: 'status-id',
        iconCls:'icon-info',
        title:"Info."
    } );

    _tree_panel = new Ext.tree.TreePanel({
        el:'tree-panel',
        title:'Folders',
        minHeight: 400,
        autoShow: true,
        autoScroll: true,
        autoDestroy: true,
        animate:true,
        enableDD:true,
        iconCls:'icon-folder',
        loader: new Ext.tree.TreeLoader({ dataUrl:'/home/tree'	})
    });
    
    _tree_panel.setRootNode( new Ext.tree.AsyncTreeNode({   
        text: 'Projects',
        expanded: true,    
        draggable:false, 
        id: 'root' }) 
    );

    _east_panel = new Ext.TabPanel( {
        region:"east",
        title:"Extras",
        xtype:"tabpanel",
        id:'extra-id',
        stateId: 'East',
        stateful: true,
        stateEvents: ["collapse","expand"],
        getState: function() { 
            state = {collapsed:  this.collapsed};
            return state;
        },                               
        applyState : function(state) {
            try{
              if (state){
                  if (this.collapsed != state.collapsed) {
                      this.toggleCollapse(false);              
                  }
              }
            } catch (e) {
                console.log('Problem with main javascript ');
                console.log(e);
           }    
        },
        restoreState : function() {
            var state = Ext.state.Manager.get(this.stateId);
            this.applyState(state);
        },     
        width: 170,
        minHeight: 600,
        minSize: 100,
        maxSize: 400,
        split:true,
        useSplitTips: true,
        collapsible:true,
        titleCollapse:true,
        activeTab:0,
        tabPosition: 'bottom',
        items:[ _status_panel, _tree_panel ]
    });

    // region -----------------------Center------------------------------
    _center_panel = new Ext.Panel({
        region:"center",
        id: 'center-id',
        contentEl:'center-panel',
        autoScroll: true,
        frame: true
    });

    _south_panel = new Ext.Panel({
        region:"south", 
        title:"History", 
        id:'footer-id', 
        height:150,
        split:true,  
        titleCollapse: true,
        splitTip: "Mesages and Audit information",
        useSplitTips: true,
        contentEl:'footer-panel',
        collapsible:true,
        collapsed: true,
        floatable: true,
        titleCollapse:false,
        stateful: true,
        stateId: 'South-panel',
        stateEvents: ["collapse","expand"],
        getState: function() { 
            state = {collapsed:  this.collapsed};
            return state;
        },                               
        applyState : function(state) {
            try{
              if (state){
                  if (this.collapsed != state.collapsed) {
                      this.toggleCollapse(false);              
                  }
              }
            } catch (e) {
                console.log('Problem with main javascript ');
                console.log(e);
           }    
        },
        restoreState : function() {
            var state = Ext.state.Manager.get(this.stateId);
            this.applyState(state);
        }     
    });

    _layout = {
        layout:"border",
        autoHeight: true,
        autoWidth : true,
        autoScroll: true,
        stateid: 'Workspace',
        stateEvents: ["drop","close","collapse","expand"],
        stateful:true,
        items:[ _north_panel , _south_panel  , _west_panel , _east_panel , _center_panel  ]
    };
}
    //------------------Public Methods ------------------------------------------------------------------------

    return {
        /*
         * Get the current client code version
         * @return {float} version
         */
        version : function(){ return _version;  },
        /*
         * Get the model in the current context
         * @return {string} model
         */
        model : function(){ return _model;},
        /*
         * Get the controller in the current context
         * @return {array} controller
         */
        controller : function(){ return _controller; },
        /*
         * Get the List of columns in the current context
         * @return {array} columns
         */
        getColumns : function(){ return _columns; },
        /*
         * Get the List of fields in the current context
         * @return {array} fields
         */
        getFields : function(){    return _fields; },
        centerPanel: function(){ return _center_panel;},
        statusPanel: function(){ return _status_panel;},
        actionPanel: function(){ return _actions_panel;},
        clipboardPanel: function(){ return _work_panel;},
        
        /**
         * Get the Width of the main working area
         **/
        getWidth: function(){ return _center_panel.getSize().width-20},
        /**
         * Get the Height of the main working area
         **/
        getHeight: function(){ return _center_panel.getSize().height-20},
        /*
         * Set the current Context for the client in terms of model/controller
         */
        setContext : function(config){ ReadConfig(config);  },

        /*
         * Setup the Project tree on the navigation panel
         */
        projectTree : function(config){

            var tree = new Ext.tree.TreePanel('project-tree', {
                animate: true,
                enableDrag: true,
                ddGroup: "GridDD",
                stateId:'ProjectTree',   //stateId override
                loader: new Ext.tree.TreeLoader(),
                stateEvents:['hide','show','destroy','collapsenode'],
                lines: true,
                selModel: new Ext.tree.MultiSelectionModel(),
                containerScroll: false });

            var root = new Ext.tree.AsyncTreeNode(config);
            tree.setRootNode(root);
            tree.render();
            root.expand()
        },
        /*
         * Set the active panel in the UI
         */
        focus: function(id){
            if ('main'==id) {  _center_panel.focus(); }
            else if ('clipboard'==id) { _work_panel.focus(); }
            else if ('status'==id) { _east_panel.activate(_status_panel); }
            else if ('tree'==id) { _east_panel.activate(_tree_panel); }
            return id;
        },

        init : function(toolbar_items){
            if (!_viewport){
                create_layout(toolbar_items);
                _viewport = new Ext.Viewport(_layout ); // End Viewport

                var dropZone = new Ext.dd.DropTarget(_work_panel.id, {
                    ddGroup:"GridDD",
                    copy:false,
                    notifyDrop : dropOnClipboard});

                dropZone.addToGroup("ClipboardDD");
                dropZone.addToGroup("TreeDD");
            }
            //_south_panel.restoreState();
            _east_panel.restoreState();
            _west_panel.restoreState();
            _south_panel.restoreState();
        }
    };
}();



