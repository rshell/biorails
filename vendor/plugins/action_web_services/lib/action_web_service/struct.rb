module ActionWebService
  # To send structured types across the wire, derive from ActionWebService::Struct,
  # and use +member+ to declare structure members.
  #
  # ActionWebService::Struct should be used in method signatures when you want to accept or return
  # structured types that have no Active Record model class representations, or you don't
  # want to expose your entire Active Record model to remote callers.
  #
  # === Example
  #
  #   class Person < ActionWebService::Struct
  #     member :id,         :int
  #     member :firstnames, [:string]
  #     member :lastname,   :string
  #     member :email,      :string
  #   end
  #   person = Person.new(:id => 5, :firstname => 'john', :lastname => 'doe')
  #
  # Active Record model classes are already implicitly supported in method
  # signatures.
  class Struct
    
    # If a Hash is given as argument to an ActionWebService::Struct constructor,
    # it can contain initial values for the structure member.
    def initialize(values={})
      if values.is_a?(Hash)
        values.map{|k,v| __send__('%s=' % k.to_s, v)}
      end
    end

    # The member with the given name
    def [](name)
      send(name.to_s)
    end

    # Iterates through each member
    def each_pair(&block)
      self.class.members.each do |name, type|
        yield name, self.__send__(name)
      end
    end
    

    def to_hash
      set = {}
      self.class.members.each do |name,value|
        set[name]=value
      end
      set
    end

    def to_rec(rec)
      self.class.members.each do |name,type|
         begin
           rec.send("#{name}=",self.send(name))  
         rescue
           puts "failed to read attribute #{name}" 
         end        
      end
      rec
    end

    def from_rec(rec)
      self.class.members.each do |name,type|
           begin
             self.send("#{name}=",rec.send(name))  
           rescue
             ActiveRecord::Base.logger.warn "failed to read attribute #{name}" 
           end        
        end
        self
    end
        
    class << self
      # Creates a structure member with the specified +name+ and +type+. Generates
      # accessor methods for reading and writing the member value.
      def member(name, type,nillable=false,default=nil)
        name = name.to_sym
        type = ActionWebService::SignatureTypes.canonical_signature_entry({ name => type }, 0,nillable,default)
        write_inheritable_hash("struct_members", name => type)
        class_eval <<-END
          def #{name}; @#{name}; end
          def #{name}=(value); @#{name} = value; end
        END
      end
      
        def from_rec(rec)
          item = self.new
          self.members.each do |name,type|
               begin
                 item.send("#{name}=",rec.send(name))  
               rescue
                 ActiveRecord::Base.logger.warn "failed to read attribute #{name}" 
               end        
            end
          item
        end
      #
      # Convert a list of items into a list of struct
      #  
      def from_list(list)
        list.collect do | rec|
           from_rec(rec)          
        end
      end
            
  
      def members # :nodoc:
        read_inheritable_attribute("struct_members") || {}
      end

      def member_type(name) # :nodoc:
        members[name.to_sym]
      end
    end
  end
end
