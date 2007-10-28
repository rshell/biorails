Ext.ux.grid.filter.BooleanFilter = Ext.extend(Ext.ux.grid.filter.Filter, {	
	init: function(){
		this.options = [
			new Ext.menu.CheckItem({text: "Yes", group: 'boolean'}),
			new Ext.menu.CheckItem({text: "No", group: 'boolean', checked: true})];
		
		this.menu.add(this.options[0], this.options[1]);
		
		for(var i=0; i<this.options.length; i++){
			this.options[i].on('click', this.fireUpdate, this);
			this.options[i].on('checkchange', this.fireUpdate, this);
		}
	},
	
	isActivatable: function(){
		return true;
	},
	
	fireUpdate: function(){		
		this.fireEvent("update", this);			
		this.setActive(true);
	},
	
	setValue: function(value){
		this.options[value ? 0 : 1].setChecked(true);
	},
	
	getValue: function(){
		return this.options[0].checked;
	},
	
	serialize: function(){
		return {type: 'boolean', value: this.getValue()};
	},
	
	validateRecord: function(record){
		return record.get(this.dataIndex) == this.getValue();
	}
});