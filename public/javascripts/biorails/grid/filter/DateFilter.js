Ext.ux.grid.filter.DateFilter = Ext.extend(Ext.ux.grid.filter.Filter, {
	dateFormat: 'm/d/Y',
	
	init: function(){
		var dates = this.dates = {
			'before': new Ext.menu.CheckItem({text: "Before", menu: new Ext.menu.DateMenu()}),
			'after':  new Ext.menu.CheckItem({text: "After", menu: new Ext.menu.DateMenu()}),
			'on':     new Ext.menu.CheckItem({text: "On", menu: new Ext.menu.DateMenu()})};
				
		this.menu.add(dates.before, dates.after, "-", dates.on);
		
		for(var key in dates){
			var date = dates[key];
			date.menu.on('select', function(date, picker, value){
				date.setChecked(true);
				
				if(date == dates.on){
					dates.before.setChecked(false, true);
					dates.after.setChecked(false, true);
				} else {
					dates.on.setChecked(false, true);
					
					/*
					dates.before.menu.picker.minDate = 
						dates.after.checked ? this.getFieldValue('after') : null;
					dates.after.menu.picker.maxDate = 
						dates.before.checked ? this.getFieldValue('before') : null;*/
				}
				
				this.fireEvent("update", this);
			}.createDelegate(this, [date]));
			
			date.on('checkchange', function(){
				this.setActive(this.isActivatable());
			}, this);
		};
	},
	
	getFieldValue: function(field){
		return this.dates[field].menu.picker.getValue();
	},
	
	getPicker: function(field){
		return this.dates[field].menu.picker;
	},
	
	isActivatable: function(){
		return this.dates.on.checked || this.dates.after.checked || this.dates.before.checked;
	},
	
	setValue: function(value){
		for(var key in this.dates)
			if(value[key]){
				this.dates[key].menu.picker.setValue(value[key]);
				this.dates[key].setChecked(true);
			} else {
				this.dates[key].setChecked(false);
			}
	},
	
	getValue: function(){
		var result = {};
		for(var key in this.dates)
			if(this.dates[key].checked)
				result[key] = this.dates[key].menu.picker.getValue();
				
		return result;
	},
	
	serialize: function(){
		var args = [];
		if(this.dates.before.checked)
			args = [{type: 'date', comparison: 'lt',  value: this.getFieldValue('before').format(this.dateFormat)}];
		if(this.dates.after.checked)
			args.push({type: 'date', comparison: 'gt', value: this.getFieldValue('after').format(this.dateFormat)});
		if(this.dates.on.checked)
			args = {type: 'date', comparison: 'eq',  value: this.getFieldValue('on').format(this.dateFormat)};

		return args;
	},
	
	validateRecord: function(record){
		var val = record.get(this.dataIndex).clearTime(true).getTime();
		
		if(this.dates.on.checked && val != this.getFieldValue('on').clearTime(true).getTime())
			return false;
		
		if(this.dates.before.checked && val >= this.getFieldValue('before').clearTime(true).getTime())
			return false;
		
		if(this.dates.after.checked && val <= this.getFieldValue('after').clearTime(true).getTime())
			return false;
			
		return true;
	}
});