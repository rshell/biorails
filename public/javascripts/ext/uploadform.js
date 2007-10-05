// vim: ts=2:sw=2:nu:fdc=4:nospell
/**
	* Ext.ux.UploadForm Widget Example Application
	*
	* @author  Ing. Jozef Sakalos
	* @version $Id: uploadform.js 66 2007-07-25 23:14:47Z jozo $
	*
	*/

// set blank image to local file
Ext.BLANK_IMAGE_URL = '../extjs/resources/images/default/s.gif';

// run this function when document becomes ready
Ext.onReady(function() {

	var iconPath = '../img/silk/icons/';

	Ext.QuickTips.init();

	var upform = new Ext.ux.UploadForm('form-ct-in', {
		autoCreate: true
		, url: '/filetree/filetree.php'
		, method: 'post'
		, maxFileSize: 1048570
		, pgCfg: {
			uploadIdName: 'UPLOAD_IDENTIFIER'
			, uploadIdValue: 'auto'
			, progressBar: true
			, progressTarget: 'under'
			, interval: 1000
			, maxPgErrors: 10
			, options: {
				url: 'progress.php'
				, method: 'post'
//				, callback: pgCallback
			}
		}
		, baseParams: {
			cmd:'upload'
			, path: 'root'
		}
	});

	Ext.ux.SWFUpload.create('swfu-ct', {
		fv: {
			uploadScript: encodeURIComponent('/filetree/swfupload.php?cmd=upload&path=root')
			, maximumFilesize: 1024 //1024 * 1024 // 1G
		}
		, pgCfg: {
			progressBar: true
			, progressTarget: 'under'
		}
	});
	//Ext.ux.SWFUpload.destroy();

	var f2 = new Ext.ux.UploadForm('float-form-ct', {
		autoCreate: true
		, floating: true
		, url: '/filetree/filetree.php'
		, method: 'post'
		, maxFileSize: 1048570
		, pgCfg: {
			uploadIdName: 'UPLOAD_IDENTIFIER'
			, uploadIdValue: 'auto'
			, progressBar: true
			, progressTarget: 'under'
			, interval: 1000
			, maxPgErrors: 10
			, options: {
				url: 'progress.php'
				, method: 'post'
//				, callback: pgCallback
			}
		}
		, baseParams: {
			cmd:'upload'
			, path: 'root'
		}
	});

	f2.showAt([240, 111]);

}) // end of onReady


// end of file
