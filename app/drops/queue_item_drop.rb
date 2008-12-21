class AssayParameterDrop < BaseDrop
 #
 # Special base handling for timestamps
 #
 timezone_dates :created_at, :updated_at
 #
 # Extra non attribute methods called
 #
 extra_attributes << :parameters << :contexts << :unit <<:full_name << :assay << :data_type << :data_element  << :parameter_type

 def initialize(source,options={})
   super source
    @options  = options
 end


 protected

end
