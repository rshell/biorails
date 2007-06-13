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


/**
* Set a panel type to be displayed or not
*/
function toggle_classes(label,body)
{
   if ($(label).className =="selected") {
     $(label).className ="unselected";
     blocks = document.getElementsByClassName(body).each( 
        function(value, index) {  value.style.display ='none';  });
   } else {
     $(label).className ="selected";
     blocks = document.getElementsByClassName(body).each( 
        function(value, index) {  value.style.display ='';  });
   }
}
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