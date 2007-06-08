/**
 * Function to link in colour and style changes to cell status
 * 
 * Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
 * See license agreement for additional rights
 *
 */

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


function FieldRestore(element) {
      element.style.background = current_cell_background
	  current_enabled = true;
}

function FieldSaved(element) {
      new Effect.Highlight(element.id,{endcolor:'#99FF99', restorecolor:'#99FF99'} );
}

/**
 * Test if current cell content matches the mask set
 */
function FieldValidate(element)
{
   ok = true
   // console.log("FieldValidate %s=%s",element.id,element.value)
   if (element.getAttribute('mask') !=null )
   {
        current_regex =  new RegExp(element.getAttribute('mask'));
		ok = current_regex.test(element.value);
   }
   if (ok && element.min !=null && element.value > element.min )  
   {
       ok = false;
       current_error = 'data less then min value '+element.min;   
   }
   if (ok && element.max !=null && element.value > element.max )  
   {
       ok = false;
       current_error = 'data more then max value '+element.min  ;    
   }
   if (ok) 
   { 
      element.style.background = "rgb(255,255,140) none";
   } 
   else 
   {
      new Effect.Highlight(element.id,{endcolor:'#FFAAAA', restorecolor:'#FFAAAA'} );
   }
   return ok;
}

/**
 * Actual make keyboard input work with arrow keys and tab, return to move arround
 *
 */
function FieldOnKeyPress(element, event) 
{
  // console.log("FieldOnKeyPress %s=%s",element.id,element.value)
    var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
    if (keyCode == VK_DOWN)       { GridMove(element,1,0)  }
    else if (keyCode == VK_UP)    { GridMove(element,-1,0) }
    else if (keyCode == VK_RETURN){ GridMove(element,1,0); return true } 
    else
    {
      FieldValidate(element)
    }
}
/**
 * Split up the cell location and change location via delta of cols and rows
 */
function GridMove(element,rows,cols)
{
   ids = element.id.split('_')
   ids[2] = rows + (+ids[2])
   ids[3] = cols + (+ids[3])
   if ($(ids.join('_'))) 
   { 
    $(ids.join('_')).focus() 
   }
   else if (rows==0)
   {
     ids[2] = cols + (+ids[1])
     ids[3] = 0     
     if ($(ids.join('_'))) 
     {  
        $(ids.join('_')).focus() 
     }
   }
}

/**
 * Split up the cell location and do ajax call to save contents to server
 */
function FieldSave(element,event)
{
  // console.log("FieldSave %s=%s",element.id,element.value)
     if (element.getAttribute('save') !=null )
	 {
        new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
        var url = element.getAttribute('save')+'?element='+element.id;
        new Ajax.Request(url,{asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
	 }
}

/*
* Ajax call to send a cells data upto server if changed
*/
function FieldExit(element,event)
{
  // console.log("FieldExit %s=%s",element.id,element.value)
  if ((element.value != current_cell_value))
  {
      if (FieldValidate(element,event))
      {
         FieldSave(element,event);
      }
  }
  else
  {
     FieldRestore(element);
  }  
}

/**
 * Call to cache current cell contents
 */
function FieldEntry(element,event)
{  
  if (element!=null)
  {
    // console.log("FieldEntry %s=%s",element.id,element.value)
    current_cell_background = element.style.background
    current_cell_value = element.value 
    current_cell_id = element.id  
    if (element.type == "text")
     { 
      element.select();
     }
  }
}


/**
 * Date handler with validation on tab/return
 */
function DateFieldOnKeyPress(element, event) 
{
    // console.log("DateFieldOnKeyPress %s=%s",element.id,element.value)
    var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
    if (keyCode == VK_DOWN){ 
  		DateFieldValidate(element); 
        }
    else if (keyCode == VK_UP)    { 
  		DateFieldValidate(element);
    }
    else if (keyCode == VK_RETURN)
    { 
  		DateFieldValidate(element);
    }
    else if ( keyCode == VK_TAB )
    { 
  		DateFieldValidate(element);
    }
}


/**
* This function is dependent on the datebocks_engine.js
*/
function DateFieldValidate(input) {
    ok =true;   
    // console.log("DateFieldValidate %s",input.value)
    FieldEntry(input);
    try {
        var d = parseDateString(input.value);
        
        var day = (d.getDate() <= 9) ? '0' + d.getDate().toString() : d.getDate();
        var month = ((d.getMonth() + 1) <= 9) ? '0' + (d.getMonth() + 1) : (d.getMonth() + 1);
        
        switch (configDateType) {
            case 'dd/mm/yyyy':
                input.value = day + '/' + month + '/' + d.getFullYear();
                break;
            case 'dd-mm-yyyy':
                input.value = day + '-' + month + '-' + d.getFullYear();
                break;
            case 'mm/dd/yyyy':
            case 'us':
                input.value = month + '/' + day + '/' + d.getFullYear();
                break;
            case 'mm.dd.yyyy':
            case 'de':
                input.value = month + '.' + day + '.' + d.getFullYear();
                break;
            case 'iso':
            case 'yyyy-mm-dd':
            default:
                input.value = d.getFullYear() + '-' + month + '-' + day;
                break;
        }
    }
    catch (e) {
        var message = e.message;
        // Fix for IE6 bug
        if (message.indexOf('is null or not an object') > -1) {
            message = 'Invalid date string';
        }
        ok =false; 
        new Effect.Highlight(input.id,{endcolor:'#FFAAAA', restorecolor:'#FFAAAA'} );
    }
    return ok;
}

/*
* Ajax call to send a cells data upto server if changed
*/
function DateFieldExit(element,event)
{
  // console.log("DateFieldExit %s=%s [%s] ",element.id,element.value,current_cell_value)
  if (element.value != current_cell_value)
  if (DateFieldValidate(element,event))
  {
     FieldSave(element,event);
  }
}
