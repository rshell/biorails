// vim: ts=2:sw=2:nu:fdc=4:nospell
/**
	* Ext.ux.InfoPanel and Ext.ux.Accordion Example Application
	*
	* @author  Ing. Jozef Sakalos
	* @version $Id: filetree.js 73 2007-07-27 10:32:06Z jozo $
	*
	*/

// set blank image to local file
Ext.BLANK_IMAGE_URL = '../extjs/resources/images/default/s.gif';

// run this function when document becomes ready
Ext.onReady(function() {

	var iconPath = '../img/silk/icons/';

	Ext.QuickTips.init();

	
	// {{{
	// create accordion
	var acc = new Ext.ux.Accordion('acc-body', {
		fitContainer: true
		, fitToFrame: true
		, boxWrap: true
		, wrapEl: 'acc-wrap'
		, fitHeight: true
		, initialHeight: 300
	});
	// }}}
	// {{{
	// resizing of fitHeight accordion
	var accCt = Ext.get('acc-ct');
	var resizer = new Ext.Resizable(accCt, {
		handles:'s e se'
		, transparent: true
		, minHeight: 180 //244
		, minWidth: 150 // 224
		, pinned: true
	});
	resizer.on({
		beforeresize: {
			scope:acc
			, fn: function(r, e) {

				// save old sizes
				r.oldSize = accCt.getSize();
				r.oldAccSize = this.body.getSize();
		}}
		, resize: {
			scope:acc
			, fn: function(r, w, h, e) {

				// calculate deltas
				var dw, dh;
				dw = w - r.oldSize.width;
				dh = h - r.oldSize.height;

				// resize Accordion 
				this.setSize(r.oldAccSize.width + dw, r.oldAccSize.height + dh);
				var dockWidth = this.body.getWidth(true);
				if(Ext.isIE) {
					this.items.each(function(panel) {
						panel.body.setWidth(dockWidth);
					})
				}

		}}
	});
	// }}}
	// {{{
	// add InfoPanel
	var ipTree = acc.add(new Ext.ux.InfoPanel('panel-tree', {
		autoScroll: true
		, collapsed: false
//		, collapsible: false
//		, showPin: true
		, icon: iconPath + 'page_white_stack.png'
		, fixedHeight: 300
	}))
	// }}}

	// tree in the panel
	var tree = new Ext.ux.FileTreePanel(ipTree.body, {
		animate: true
		, dataUrl: 'filetree.php'
		, readOnly: false
		, containerScroll: true
		, enableDD: true
		, enableUpload: true
		, enableRename: true
		, enableDelete: true
		, enableNewDir: true
		, uploadPosition: 'menu'
//		, edit: true
//		, sort: true
		, maxFileSize: 1048575
		, hrefPrefix: '/filetree/'
		, pgCfg: {
			uploadIdName: 'UPLOAD_IDENTIFIER'
			, uploadIdValue: 'auto'
			, progressBar: false
			, progressTarget: 'qtip'
			, maxPgErrors: 10
			, interval: 1000
			, options: {
				url: '../uploadform/progress.php'
				, method: 'post'
			}
		}
	});
	
	// {{{
	var root = new Ext.tree.AsyncTreeNode({text:'Tree Root', path:'root', allowDrag:false});
	tree.setRootNode(root);
	tree.render();
	root.expand();
//	tree.on('beforerename', function(tree, node, oldname, newname) {debugger;return false});
//	tree.setReadOnly(true);
//	tree.setReadOnly(false);
	// }}}

}) // end of onReady

// end of file
