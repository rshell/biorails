module SexyStatementsHook
  
  def self.included(base)
    base.extend ClassMethods
    class << base
      cattr_accessor :sexy_up, :sexy_down, :desired_migration_name
      self.sexy_up, self.sexy_down, self.desired_migration_name = "","",""
      alias_method_chain :method_missing, :sexy_statements
    end
  end

  module ClassMethods
  
    def add_to_migration_name(what)
      if self.desired_migration_name.length < 100
        self.desired_migration_name << "_" unless self.desired_migration_name.blank?
        self.desired_migration_name << what 
      else
        self.desired_migration_name << "and_more" unless self.desired_migration_name.index("and_more")
      end      
    end
  
    def method_missing_with_sexy_statements(method, *args, &block)
      case method
      when :create_table, :create_view
        table_name = args.shift.to_s    
        lines = IO.readlines(File.join(RAILS_ROOT, 'db', 'definition.rb'))
        inside_table = false
        self.sexy_up << "\n"
        for line in lines do
          clean_line = line.gsub(/#.*/,"")
          if clean_line =~ /create_(table|view)\W+#{table_name}(\W+|$)/i
            inside_table = true  
          end
          self.sexy_up << "  " + line if inside_table
          if inside_table and (clean_line =~ /\send\s*/i || clean_line =~ /^end\s*/i)
            break
          end
        end
      
        add_to_migration_name( "create_#{table_name}" )

      else
        add_to_migration_name( method.to_s.split('_')[0] + ("_"+args[0].to_s rescue "") + ("_"+args[1].to_s rescue "") )
        self.sexy_up << "    " + method.to_s + " " + args.collect{ |a| a.inspect }.join(",") + "\n"
			end
	
#        auto_create_table(method, *args, &block)
#      when :add_index
#        auto_add_index(method, *args, &block)
#      else
#        method_missing_without_auto_migration(method, *args, &block) 
#      end
    end
  
  end

end
