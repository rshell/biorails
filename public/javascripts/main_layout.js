/**
 * @author rshell
 */
MainLayout = function(){
    var layout;
    var toolbar;
    var folders;
    var root;	
return {	
    init : function(){
       layout = new Ext.BorderLayout(document.body, {
            north: {
                split:false,
                initialSize: 32,
                titlebar: false
            },
            west: {
                split:true,
                initialSize: 120,
                minSize: 100,
                maxSize: 400,
                titlebar: true,
                collapsible: true,
                animate: true
            },
            east: {
                split:true,
                initialSize: 200,
                minSize: 100,
                maxSize: 400,
                titlebar: true,
                collapsible: true,
                animate: true
            },
            south: {
                split:true,
                initialSize: 50,
                minSize: 50,
                maxSize: 200,
                titlebar: true,
                collapsible: true,
                animate: true
            },
            center: {
                titlebar: true,
                autoScroll:true,
                closeOnTab: true
            }
        });

        layout.beginUpdate();
        layout.add('north', new Ext.ContentPanel('header', 'North'));
        layout.add('south', new Ext.ContentPanel('footer', {title: 'Historic Log', closable: false}));

        layout.add('west', new Ext.ContentPanel('left', {title: 'Menu', closable: false}));

        layout.add('east', new Ext.ContentPanel('right', {title: 'Context', closable: false}));

        layout.add('center', new Ext.ContentPanel('center', {title: 'Main', closable: false}));

        layout.getRegion('center').show();
        layout.getRegion('west').show();
        layout.endUpdate();
        
   }
 };       
}();

Ext.EventManager.onDocumentReady(MainLayout.init, MainLayout, true);
