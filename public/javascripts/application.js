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


Ajax.Responders.register({
 onCreate: function() {
    if (Ajax.activeRequestCount > 0)
      Element.show('form-indicator');
 },
 onComplete: function() {
    if (Ajax.activeRequestCount == 0)
      Element.hide('form-indicator');
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

/**
 * Set a single panel to be displayed or not
 */
function toggle_element(label,body)
{
   if ($(label).className =="selected") {
     $(label).className ="unselected";
   } else {
     $(label).className ="selected";
   }
   Effect.toggle(body,'appear');
}


function showTab(block,tab)
{
  blocks =document.getElementsByClassName('TabPanel').each( 
        function(value, index) {  value.style.display ='none';  });
  $(tab).style.display ='';       
}