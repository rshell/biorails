// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var VK_LEFT = 0x25;
var VK_UP = 0x26;
var VK_RIGHT = 0x27;
var VK_DOWN = 0x28;
var VK_RETURN = 13;
var VK_TAB = 9;

var current_cell_classname = "cell-initial"
var current_cell_background = 'rgb(255,255,255) none';
var current_cell_value = '';
var current_cell_regex = '/./';
var current_cell_id ='';

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

/*
 * simple RegEx match tester
 */
function RegExMatchCheck(mask,subject) {

   re = new RegExp(mask);
     if (re.test(subject.value)) {
		subject.style.background = "#99FF99";
       alert("passed mask matches: "+subject.value );
     } else {
		subject.style.background = "#FFAAAA";
       alert("failed");
    }
}

/*
 * simple RegEx match hifhligher
 */
function RegExMatchOnKey(mask,subject) {
   re = new RegExp(mask);
    if (re.test(subject.value)) {
		subject.style.background = "#99FF99";
    } else {
		subject.style.background = "#FFAAAA";
    }
}

var MceEditor = {
    init : function(el){
      tinyMCE.init({
           theme: 'advanced',
           mode: "textareas",
           doctype: " ",
           theme_advanced_toolbar_location: "top",
           theme_advanced_toolbar_align: "left",
           auto_resize: false,
           theme_advanced_resizing: true,
           theme_advanced_statusbar_location: "bottom",
           paste_auto_cleanup_on_paste: true,
           theme_advanced_buttons1: "formatselect,fontselect,fontsizeselect,bold,italic,underline,strikethrough,separator,justifyleft,justifycenter,justifyright,indent,outdent,bullist,numlist,separator,fullscreen,help",
           theme_advanced_buttons2: "cut,copy,paste,pastetext,pasteword,undo,redo,link,unlink,image,separator,visualaid,tablecontrols,separator,fullpage,code,cleanup",
           theme_advanced_buttons3: "",
           plugins: "contextmenu,paste,table,fullscreen,fullpage",
           width: "600",
           height: "400",
           mode : "exact",
           elements : el  });
    }
  };