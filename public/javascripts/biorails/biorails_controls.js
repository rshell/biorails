Ext.namespace("Biorails");

//------------------ Biorails Form controls --------------------------------------------------------

/*
 * Do some intelligent parsing of date to like like's  of next tues
 */
Biorails.MagicDate = function(){
    // arrays for month and weekday names
    var monthNames = "January February March April May June July August September October November December".split(" ");
    var weekdayNames = "Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split(" ");

    /* Takes a string, returns the index of the month matching that string, throws
	   an error if 0 or more than 1 matches
     */
    function parseMonth(month) {
        var matches = monthNames.filter(function(item) { 
            return new RegExp("^" + month, "i").test(item);
        });
        if (matches.length == 0) {
            throw new Error("Invalid month string");
        }
        if (matches.length < 1) {
            throw new Error("Ambiguous month");
        }
        return monthNames.indexOf(matches[0]);
    }

    /* Same as parseMonth but for days of the week */
    function parseWeekday(weekday) {
        var matches = weekdayNames.filter(function(item) {
            return new RegExp("^" + weekday, "i").test(item);
        });
        if (matches.length == 0) {
            throw new Error("Invalid day string");
        }
        if (matches.length < 1) {
            throw new Error("Ambiguous weekday");
        }
        return weekdayNames.indexOf(matches[0]);
    }

    function DateInRange( yyyy, mm, dd )
    {
        // if month out of range
        if ( mm < 0 || mm > 11 )
            throw new Error('Invalid month value.  Valid months values are 1 to 12');

        if (!configAutoRollOver) {
            // get last day in month
            var d = (11 == mm) ? new Date(yyyy + 1, 0, 0) : new Date(yyyy, mm + 1, 0);

            // if date out of range
            if ( dd < 1 || dd > d.getDate() )
                throw new Error('Invalid date value.  Valid date values for ' + monthNames[mm] + ' are 1 to ' + d.getDate().toString());
        }
        return true;
    }

    function getDateObj(yyyy, mm, dd) {
        var obj = new Date();

        obj.setDate(1);
        obj.setYear(yyyy);
        obj.setMonth(mm);
        obj.setDate(dd);

        return obj;
    }

    /* Array of objects, each has 're', a regular expression and 'handler', a 
	   function for creating a date from something that matches the regular 
	   expression. Handlers may throw errors if string is unparseable. 
     */
    var dateParsePatterns = [
        // Today
        {   re: /^tod|now/i,
            handler: function() { 
                return new Date();
            } 
        },
        // Tomorrow
        {   re: /^tom/i,
            handler: function() {
                var d = new Date(); 
                d.setDate(d.getDate() + 1); 
                return d;
            }
        },
        // Yesterday
        {   re: /^yes/i,
            handler: function() {
                var d = new Date();
                d.setDate(d.getDate() - 1);
                return d;
            }
        },
        // 4th
        {   re: /^(\d{1,2})(st|nd|rd|th)?$/i, 
            handler: function(bits) {

                var d = new Date();
                var yyyy = d.getFullYear();
                var dd = parseInt(bits[1], 10);
                var mm = d.getMonth();

                if ( DateInRange( yyyy, mm, dd ) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // 4th Jan
        {   re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of\s)?(\w+)$/i, 
            handler: function(bits) {

                var d = new Date();
                var yyyy = d.getFullYear();
                var dd = parseInt(bits[1], 10);
                var mm = parseMonth(bits[2]);

                if ( DateInRange( yyyy, mm, dd ) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // 4th Jan 2003
        {   re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of )?(\w+),? (\d{4})$/i,
            handler: function(bits) {
                var d = new Date();
                d.setDate(parseInt(bits[1], 10));
                d.setMonth(parseMonth(bits[2]));
                d.setYear(bits[3]);
                return d;
            }
        },
        // Jan 4th
        {   re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?$/i, 
            handler: function(bits) {

                var d = new Date();
                var yyyy = d.getFullYear(); 
                var dd = parseInt(bits[2], 10);
                var mm = parseMonth(bits[1]);

                if ( DateInRange( yyyy, mm, dd ) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // Jan 4th 2003
        {   re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?,? (\d{4})$/i,
            handler: function(bits) {

                var yyyy = parseInt(bits[3], 10); 
                var dd = parseInt(bits[2], 10);
                var mm = parseMonth(bits[1]);

                if ( DateInRange( yyyy, mm, dd ) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // Next Week, Last Week, Next Month, Last Month, Next Year, Last Year
        {   re: /((next|last)\s(week|month|year))/i,
            handler: function(bits) {
                var objDate = new Date();

                var dd = objDate.getDate();
                var mm = objDate.getMonth();
                var yyyy = objDate.getFullYear();

                switch (bits[3]) {
                    case 'week':
                        var newDay = (bits[2] == 'next') ? (dd + 7) : (dd - 7);

                        objDate.setDate(newDay);

                        break;
                    case 'month':
                        var newMonth = (bits[2] == 'next') ? (mm + 1) : (mm - 1);

                        objDate.setMonth(newMonth);

                        break;
                    case 'year':
                        var newYear = (bits[2] == 'next') ? (yyyy + 1) : (yyyy - 1);

                        objDate.setYear(newYear);

                        break;
                }

                return objDate;
            }
        },
        // next Tuesday - this is suspect due to weird meaning of "next"
        {   re: /^next (\w+)$/i,
            handler: function(bits) {

                var d = new Date();
                var day = d.getDay();
                var newDay = parseWeekday(bits[1]);
                var addDays = newDay - day;
                if (newDay <= day) {
                    addDays += 7;
                }
                d.setDate(d.getDate() + addDays);
                return d;

            }
        },
        // last Tuesday
        {   re: /^last (\w+)$/i,
            handler: function(bits) {

                var d = new Date();
                var wd = d.getDay();
                var nwd = parseWeekday(bits[1]);

                // determine the number of days to subtract to get last weekday
                var addDays = (-1 * (wd + 7 - nwd)) % 7;

                // above calculate 0 if weekdays are the same so we have to change this to 7
                if (0 == addDays)
                    addDays = -7;

                // adjust date and return
                d.setDate(d.getDate() + addDays);
                return d;

            }
        },
        // mm/dd/yyyy (American style)
        {   re: /(\d{1,2})\/(\d{1,2})\/(\d{4})/,
            handler: function(bits) {
                // if config date type is set to another format, use that instead
                if (configDateType == 'dd/mm/yyyy') {
                    var yyyy = parseInt(bits[3], 10);
                    var dd = parseInt(bits[1], 10);
                    var mm = parseInt(bits[2], 10) - 1;
                } else {
                    var yyyy = parseInt(bits[3], 10);
                    var dd = parseInt(bits[2], 10);
                    var mm = parseInt(bits[1], 10) - 1;
                }

                if ( DateInRange( yyyy, mm, dd ) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // mm/dd/yy (American style) short year
        {   re: /(\d{1,2})\/(\d{1,2})\/(\d{1,2})/,
            handler: function(bits) {

                var d = new Date();
                var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[3], 10);
                var dd = parseInt(bits[2], 10);
                var mm = parseInt(bits[1], 10) - 1;

                if ( DateInRange(yyyy, mm, dd) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // mm/dd (American style) omitted year
        {   re: /(\d{1,2})\/(\d{1,2})/,
            handler: function(bits) {

                var d = new Date();
                var yyyy = d.getFullYear();
                var dd = parseInt(bits[2], 10);
                var mm = parseInt(bits[1], 10) - 1;

                if ( DateInRange(yyyy, mm, dd) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // mm-dd-yyyy
        {   re: /(\d{1,2})-(\d{1,2})-(\d{4})/,
            handler: function(bits) {
                if (configDateType == 'dd-mm-yyyy') {
                    // if the config is set to use a different schema, then use that instead
                    var yyyy = parseInt(bits[3], 10);
                    var dd = parseInt(bits[1], 10);
                    var mm = parseInt(bits[2], 10) - 1;
                } else {
                    var yyyy = parseInt(bits[3], 10);
                    var dd = parseInt(bits[2], 10);
                    var mm = parseInt(bits[1], 10) - 1;
                }

                if ( DateInRange( yyyy, mm, dd ) ) {
                    return getDateObj(yyyy, mm, dd);
                }

            }
        },
        // dd.mm.yyyy
        {   re: /(\d{1,2})\.(\d{1,2})\.(\d{4})/,
            handler: function(bits) {
                var dd = parseInt(bits[1], 10);
                var mm = parseInt(bits[2], 10) - 1;
                var yyyy = parseInt(bits[3], 10);

                if ( DateInRange( yyyy, mm, dd ) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // yyyy-mm-dd (ISO style)
        {   re: /(\d{4})-(\d{1,2})-(\d{1,2})/,
            handler: function(bits) {

                var yyyy = parseInt(bits[1], 10);
                var dd = parseInt(bits[3], 10);
                var mm = parseInt(bits[2], 10) - 1;

                if ( DateInRange( yyyy, mm, dd ) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // yy-mm-dd (ISO style) short year
        {   re: /(\d{1,2})-(\d{1,2})-(\d{1,2})/,
            handler: function(bits) {

                var d = new Date();
                var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[1], 10);
                var dd = parseInt(bits[3], 10);
                var mm = parseInt(bits[2], 10) - 1;

                if ( DateInRange( yyyy, mm, dd ) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // mm-dd (ISO style) omitted year
        {   re: /(\d{1,2})-(\d{1,2})/,
            handler: function(bits) {

                var d = new Date();
                var yyyy = d.getFullYear();
                var dd = parseInt(bits[2], 10);
                var mm = parseInt(bits[1], 10) - 1;

                if ( DateInRange( yyyy, mm, dd ) )
                    return getDateObj(yyyy, mm, dd);

            }
        },
        // mon, tue, wed, thr, fri, sat, sun
        {   re: /(^mon.*|^tue.*|^wed.*|^thu.*|^fri.*|^sat.*|^sun.*)/i,
            handler: function(bits) {
                var d = new Date();
                var day = d.getDay();
                var newDay = parseWeekday(bits[1]);
                var addDays = newDay - day;
                if (newDay <= day) {
                    addDays += 7;
                }
                d.setDate(d.getDate() + addDays);
                return d;
            }
        },
    ];
    return {
        parse: function(s) {
            for (var i = 0; i < dateParsePatterns.length; i++) {
                var re = dateParsePatterns[i].re;
                var handler = dateParsePatterns[i].handler;
                var bits = re.exec(s);
                if (bits) {
                    return handler(bits);
                }
            }
                
            //throw new Error("Invalid date string");
            return "";        
	}
    }      
}();


//---------------------------------------- Date Field Widget--------------------------------------------------------
Ext.namespace("Biorails.DateField");
/**
 *  Biorails.DateField 
 *  
 *  Based on "A better way of entering dates"  
 *       http://simonwillison.net/2003/Oct/6/betterDateInput/
 *  and Datablocks engine http://dev.toolbocks.com
 *
 * Date field that allows user to enter shortcuts (ie 't' for today's date)
 * and plain english like '5 days ago'.
 * 
 * @class Biorails.DateFieldField
 * @extends Ext.form.DateField
 * @see Biorails.DateField
 * @constructor   Create a new  Date Field
 * @param {Object} config The config object
 */
Biorails.DateField = function(config){    
    Biorails.DateField.superclass.constructor.call(this,config); 
         
    this.on('blur',function(field){
        field.save();
    });
    this.on('focus',function(field){
        field.entry();
    });
};

Ext.extend(Biorails.DateField,  Ext.form.DateField, {
    parseDate : function(raw) {
        try {
            var value = Biorails.DateField.superclass.parseDate.call(this, raw);
		
            if(!value) {
                value = Biorails.MagicDate.parse(raw);
            }
            return value;
        } catch (e) {
            return "";    
        }
    },

    save: function(){
        if ( this.url && (_original_value != this.getValue() ) ) {
            var element=this.getEl().dom;
            new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
            var save_url = this.url+'?element='+element.id;
            new Ajax.Request(save_url,
            {asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
        }
    },
          
    entry: function(){
        var element=this.getEl().dom;
        _original_background = element.style.background;
        _original_value = this.getValue();
    }              
                 
});
//Ext.reg('datefield', Biorails.DateField); // Register as default datefield in Ext

//Ext.reg('brdatefield', Biorails.FileComboField);


//---------------------------------------- Select Field Widget--------------------------------------------------------

/**
 *  Biorails.SelectField 
 *
 * Custom Select field for a defined list of values
 */



Biorails.SelectField = function(config){   
     
    Biorails.SelectField.superclass.constructor.call(this,Ext.apply(config,{
        typeAhead: true,
        triggerAction: 'all',
        forceSelection:true        
    }));
         
    this.on('change',function(field){
        field.save();
    });
    this.on('focus',function(field){
        field.entry();
    });     
};

Ext.extend(Biorails.SelectField,  Ext.form.ComboBox, {

    save: function(){
        if ( this.url && (_original_value != this.getValue() ) ) {
            var element=this.getEl().dom;
            new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
            var save_url = this.url+'?element='+element.id;
            new Ajax.Request(save_url,
            {asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
        }
    },
          
    entry: function(){
        var element=this.getEl().dom;
        _original_background = element.style.background;
        _original_value = this.getValue();
    }              
                 
});
//Ext.reg('brselectfield', Biorails.FileComboField);

//---------------------------------------- Conbo Field Widget--------------------------------------------------------
Ext.namespace("Biorails.ComboField");
/**
 * Custom Select field for a remote data element field
 */
Biorails.ComboField = function(config){    
    Biorails.ComboField.superclass.constructor.call(this,Ext.apply(config,{
        mode:'remote',
        store: new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: '/admin/element/select/'+config.root_id, method: 'get' 
            }),
            reader: new Ext.data.JsonReader({
                root: 'items', 
                totalProperty: 'total'},
            [ {name: 'id', type: 'int'},
                {name: 'name'},
                {name: 'description'}]  )
        }),
        triggerAction: 'all',
        forceSelection: false,
        editable: true,
        loadingText: 'Looking Up Name...',
        selectOnFocus: false,
        minChars:0,
        valueField: 'name',
        displayField: 'name'
    })); 
         
    this.on('blur',function(field){
        field.save();
    });
    this.on('focus',function(field){
        field.entry();
    });
      
};

Ext.extend(Biorails.ComboField,  Ext.form.ComboBox, {

    save: function(){
        if ( this.url && (_original_value != this.getValue() ) ) {
            var element=this.getEl().dom;
            new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
            var save_url = this.url+'?element='+element.id;
            new Ajax.Request(save_url,
            {asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
        }
    },
          
    entry: function(){
        var element=this.getEl().dom;
        _original_background = element.style.background;
        _original_value = this.getValue();
    }              
                 
});
//---------------------------------------- Conbo Field Widget--------------------------------------------------------
Ext.namespace("Biorails.RegExpField");
/**
 * Custom Select field for a remote data element field
 */
Biorails.RegExpField = function(config){    
    Biorails.RegExpField.superclass.constructor.call(this,Ext.apply(config,{regexText: 'Failed to meet mask'}));
         
    this.on('blur',function(field){
        field.save();
    });
    this.on('focus',function(field){
        field.entry();
    });
};

    
Ext.extend(Biorails.RegExpField,  Ext.form.TextField, {
    
    save: function(){
        if ( this.url && (_original_value != this.getValue() ) ) {
            var element=this.getEl().dom;
            new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
            var save_url = this.url+'?element='+element.id;
            new Ajax.Request(save_url,
            {asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
        }
    },
          
    entry: function(){
        var element=this.getEl().dom;
        _original_background = element.style.background;
        _original_value = this.getValue();
    }         
                 
});

//Ext.reg('brcombofield', Biorails.FileComboField);

//---------------------------------------- Conbo Field Widget--------------------------------------------------------
Ext.namespace("Biorails.FileComboField");
/**
 * Custom Select field for a remote data element field
 */
Biorails.FileComboField = function(config){ 
    var _original_value = null;
    var _original_background = null;   
    Biorails.FileComboField.superclass.constructor.call(this,Ext.apply(config,{
        mode:'remote',
        store: new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: '/folders/select/'+config.folder_id, method: 'get' 
            }),
            reader: new Ext.data.JsonReader({
                root: 'items', 
                totalProperty: 'total'},
            [ {name: 'id', type: 'int'},
                {name: 'name'},
                {name: 'path'},
                {name: 'icon'}]  )
        }),
        triggerAction: 'all',
        forceSelection: false,
        editable: true,               
        loadingText: 'Searching...',
        valueField: 'id',
        displayField: 'name',
        tpl: new Ext.XTemplate(
        '<tpl for="."><div class="x-combo-list-item">',
        '<image src="{icon}"/>',
        '<em>{name}</em>:   <strong>{path}</strong>',
        '<div class="x-clear"></div>',
        '</div></tpl>')       
    })); 
    this.on('blur',function(field,newValue,oldValue){
        field.save();
    });
    this.on('focus',function(field){
        field.entry();
    });
      
};

Ext.extend(Biorails.FileComboField,  Ext.form.ComboBox, {


    save: function(){
        if ( this.url && (_original_value != this.getValue() ) ) {
            var element=this.getEl().dom;
            new Effect.Highlight(element.id,{endcolor:'#FFFF99', restorecolor:'#FFFF99'} );
            var save_url = this.url+'?element='+element.id;
            new Ajax.Request(save_url,
            {asynchronous:true, evalScripts:true, parameters:'value=' + escape(element.value)} ); 
        }
    },
          
    entry: function(){
        var element=this.getEl().dom;
        _original_background = element.style.background;
        _original_value = this.getValue();
    }                        
        
});

//Ext.reg('brfilefield', Biorails.FileComboField);

//---------------------------------------- Simple  HTML Editor -------------------------------------------------
Ext.namespace("Biorails.HtmlField");

Biorails.HtmlField = function(id){
    Biorails.HtmlField.superclass.constructor.call(this,{
        id: id,
        applyTo: id,
        autoWidth : true,
        height: 300,
        enableFormat: true,
        enableLists: true,
        enableFontSize: false,
        enableLinks:  false,
        enableSourceEdit: false,
        enableColours: false
    });
}

//Ext.extend(Biorails.HtmlField,  Ext.form.HtmlEditor, {});
//----------------------------------------  HTML Word processor -------------------------------------------------
Ext.namespace("Biorails.DocumentField");

Biorails.DocumentField = function(id){
    Biorails.DocumentField.superclass.constructor.call(this,{
        applyTo: id,
        enableFontSize: true,
        enableFormat: true,
        enableLists: true,
        enableLinks: true,
        minHeight: 400,
        height: 600,
        autoWidth : true,
        enableSourceEdit: true,
        enableColours:true
    });
}


Ext.extend(Biorails.DocumentField,  Ext.form.HtmlEditor, {});
//Ext.reg('brdocument', Biorails.DocumentField);

//----------------------------------------  Biorails Conceptural Tree ---------------------------------------------
Ext.namespace("Biorails.ConceptTree");

Biorails.ConceptTree = function(el){
    
    Biorails.ConceptTree.superclass.constructor.call(this,{
        el: el,
        title:'Dictionaries',
        minHeight: 400,
        autoShow: true, 
        autoHeight:true,
        autoScroll:true,
        layout: 'fit',           
        animate:true,
        enableDD:false,
        iconCls:'icon-data_concept', 
        root:  new Ext.tree.AsyncTreeNode({   
            text: 'Biorails',
            expanded: true,  
            draggable:false, id: '1' }),
        loader: new Ext.tree.TreeLoader({ dataUrl:'/admin/catalogue/tree'	})
    });
                
    this.on('click',function(node){
        try{ 
            new Ajax.Request(node.attributes.url,{asynchronous:true, evalScripts:true});  
        } catch (e) {
            Ext.log('Problem with click on tree node ');
            Ext.log(e);
        } 
    });                     
}

Ext.extend(Biorails.ConceptTree,  Ext.tree.TreePanel, {} );
