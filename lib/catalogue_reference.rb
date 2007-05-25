
module CatalogueReference

##
# Internal holder for the current value of the item (cached to save complex lookups to 
# other tables more then once.
# 
 attr_accessor :current_value

##
# Defeult logger got tracing problesm
def logger
  ActionController::Base.logger rescue nil
end
 
##
# Convert Name to DataValue(id,Name) from DataElement
# 
 def lookup(name)
   if self.data_element
       self.data_element.lookup(name)
   else
     name    
   end
 end

##
# Convert id to DataValue(id,Name) from DataElement
# 
 def reference(id)
   if self.data_element
       self.data_element.reference(id)
   else
     id.to_s    
   end
 end

##
# returns actual object
# 
 def object
   unless @current_value      
      @current_value = lookup(self.data_name)
   end
   return @current_value
 end

##
# set the value for the reference
# 
 def value=(new_value)
   logger.debug "catalogue_reference.value= #{new_value} #{new_value.class} [:name=>#{self.data_name},:id=>#{self.data_id},type=>#{self.data_type}]"
  if new_value != @current_value
    case new_value
      when Fixnum
        from_named(self.reference(new_value) )
      when ListItem
        from_data(self.reference(new_value))
      when Hash
        from_named(self.reference(new_value))
      when String,NilClass
        from_string(new_value)  
      else       
        from_named(new_value)
     end
   end 
   logger.debug "catalogue_reference.value= #{new_value} [:name=>#{self.data_name},:id=>#{self.data_id},type=>#{self.data_type}]"
   return @current_value
 end
 
 def from_string(new_value)
     if !new_value.nil? and new_value.to_s.length>0
        item   = self.lookup(new_value.to_s)
        item ||= self.reference(new_value)
        from_named(item)
     else 
        clear 
     end
 end

 def clear
      self.data_type = nil
      self.data_id   = nil
      self.data_name = nil
      @current_value = nil
 end 
 

 def from_data(new_value)
    self.data_type = new_value.data_type if new_value.respond_to?(:date_type)
    self.data_id   = new_value.data_id if new_value.respond_to?(:date_id)
    self.data_name = new_value.data_name if new_value.respond_to?(:date_name)
    @current_value = new_value
 end

  
 def from_named(new_value)
     if new_value.nil?
        clear
     else
        self.data_type = new_value.class.to_s
        self.data_id   = new_value[:id].to_i 
        self.data_name = new_value[:name] 
        @current_value = new_value
    end
 end

##
# returns a string value for the current object 
# 
 def value
   return self.data_name
 end

end