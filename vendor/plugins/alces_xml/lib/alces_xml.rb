# AlcesXml
# 
# This provides a modifed instance.to_xml() and class.from_xml()
# 
module Alces

  module Xml

    def self.included(base) # :nodoc:
        base.extend ClassMethods
    end

    module InstanceMethods
      # Builds an XML document to represent the model.   Some configuration is
      # availble through +options+, however more complicated cases should use 
      # override ActiveRecord's to_xml.
      #
      # This behavior can be controlled with :only, :except,
      # :skip_instruct, :skip_types and :dasherize.  The :only and
      # :except options are the same as for the #attributes method.
      # The default is to dasherize all column names, to disable this,
      # set :dasherize to false.  To not have the column type included
      # in the XML output, set :skip_types to false.
      #
      # For instance:
      #
      #   topic.to_xml(:skip_instruct => true, :except => [ :id, :bonus_time, :written_on, :replies_count ])
      #
      #   <topic>
      #     <title>The First Topic</title>
      #     <author-name>David</author-name>
      #     <approved type="boolean">false</approved>
      #     <content>Have a nice day</content>
      #     <author-email-address>david@loudthinking.com</author-email-address>
      #     <parent-id></parent-id>
      #     <last-read type="date">2004-04-15</last-read>
      #   </topic>
      # 
      # options[:include]->[] List of relationship names to used in xml generation
      # options[:except]->[] List of attributes to override on loading
      # options[:reference]=>{} Hash of models to represent as a referenece and the name of the field to use for the reference
      #
      # To include first level associations use :include
      #
      #   firm.to_xml :include => [ :account, :clients ]
      #
      def to_xml(options = {})
        Alces::XmlSerializer.new(self, options).to_s
      end
    end

    module ClassMethods
      #
      # Convert from xml to ActiveRecord Model Graph
      #
      # options[:create] =>[] List of models to ignore the id field and recreate on load
      # options[:update] =>[] List of models update to match this imported data
      # options[:include]->[] List of relationship names to used in xml generation
      # options[:except]->[] List of attributes to override on loading
      # options[:override]->{} Hash of attributes to override on loading
      # options[:reference]=>{} Hash of models to represent as a referenece and the name of the field to use for the reference
      #   
      # Example of a loader to create new study and study_parameter objects
      # in the load is even below
      #
      # Parameter.from_xml(xml, :create => [:parameter],
      #                     :override => { :name =>'xxxx' },
      #                     :reference => {:data_type=>:name} ) 
      #
      #  Study.from_xml (xml, :create => [:assay,:assay_parameter ],
      #                   :include => [:parameters] )
      #
      # Unluckly some configuration is needed to manually identify where the break points in the model.
      # Generally a subset of the dependent collection and references are needed to build a consistent model 
      #
      def from_xml(xml, options = {})
         Alces::XmlDeserializer.new(self, options).to_object(xml)
      end

     include Alces::Xml::InstanceMethods         
    end
  end

   
#
# XML serialization processing to convert a list of ActiveRecord objects to a XML graph
#
#
  class XmlSerializer #:nodoc:
    attr_reader :options

    def initialize(record, options = {})
      @record, @options = record, options.dup
 
      #puts " #{@record.class}(#{@record.id}).to_xml( options={"
      #puts "   :reference=>[#{( @options[:reference] || [] ).to_a.join(', ')}],"
      #puts "   :include  =>[#{( @options[:include]   || [] ).to_a.join(', ')}],"
      #puts "   :except   =>[#{( @options[:except]    || [] ).to_a.join(', ')}]}"

    end
    ##
    # Default logger got tracing problem
    #
    def logger
      ActiveRecord::Base.logger rescue nil
    end

    #
    # Generate a XML builder it none is defined
    #
    def builder
      @builder ||= begin
        options[:indent] ||= 2
        builder = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])

        unless options[:skip_instruct]
          builder.instruct!
          options[:skip_instruct] = true
        end
        
        builder
      end
    end

    def root
       options[:root] || format(@record.class)
    end
    
    def dasherize?
      !options.has_key?(:dasherize) || options[:dasherize]
    end


    # To replicate the behavior in ActiveRecord#attributes,
    # :except takes precedence over :only.  If :only is not set
    # for a N level model but is set for the N+1 level models,
    # then because :except is set to a default value, the second
    # level model can have both :except and :only set.  So if
    # :only is set, always delete :except.
    #
    def serializable_attributes
      attribute_names = @record.attribute_names
      if options[:only]
        options.delete(:except)
        attribute_names = attribute_names & Array(options[:only]).collect { |n| n.to_s }
      else
        options[:except] = Array(options[:except]) | Array(@record.class.inheritance_column)
        attribute_names = attribute_names - options[:except].collect { |n| n.to_s }
      end      
      attribute_names.collect { |name| Attribute.new(name, @record) }
    end


    def serializable_method_attributes
      Array(options[:methods]).collect { |name| MethodAttribute.new(name.to_s, @record) }
    end
    ##
    # Exclude a attribute from output
    #
    def except?(key = nil)
      if key and options[:except]
        options[:except].include?(key)
      else
        options[:except]
      end
    end

    ##
    # is this included in the output
    #
    def include?(key = nil)
      if key and options[:include]
      	options[:include].include?(key)
      else
      	options[:include]
      end
    end
    ##
    # is this a reference? that should be outputed
    #
    def reference?(key = nil)
      if key and options[:reference]
      	options[:reference].include?(key)
      else
      	options[:reference]
      end
    end
    #
    # Added the basic attributes on the model
    #
    def add_attributes
      (serializable_attributes + serializable_method_attributes).each do |attribute|
        add_tag(attribute)
      end
    end
     
    ##
    # add a related collection to the the output
    #
    def add_collection(link)
	    if include?(link.name)
	      records = @record.send(link.name).to_a
	      unless records.empty?
          opts = child_options(link)
      		builder.tag!(format(link.name),{:style => link.macro,:class=>link.class_name}) do
      		    records.each { |r| r.to_xml(opts.merge(:root => format(r.class) )) }
      		end
	      end
      end	
    end

    def add_composed(link)
     # @todo sorry have not used in project
    end    
    #
    # Add references to classes with will not be linked in the XML 
    # This is done as a partial class
    # 
    def add_reference(link)
    	if reference?(link.name)
    		ref = @record.send(link.name)
          if ref
      		builder.tag!(format(link.name),{:style => link.macro,:class=>link.class_name}) do
            id = options[:reference][link.name] || :id
       			builder.tag!(id,ref.send(id) ) 
      		end
        end
      elsif include?(link.name)
        opts = child_options(link)
        if record = @record.send(link.name)
          record.to_xml(opts.merge(:root => format(link.name)))
        end
      end
    end
    
    def child_options(link)
       opts = options.dup 
       opts[:include] = options[:include].is_a?(Hash) ? option[:include][link.name] : []
       opts[:except] = [link.primary_key_name]  
       return opts
    end
    #
    # Add associated collections and reference classes
    #
    def add_includes
       for key in @record.class.reflections().keys
          link =  @record.class.reflect_on_association(key)
          case link.macro
          when :has_many, :has_and_belongs_to_many
              add_collection(link)
          when :belongs_to, :has_one
              add_reference(link)
          when :composed_of
              add_composed(link)
          end
       end
    end

    def add_procs
      if procs = options.delete(:procs)
        [ *procs ].each do |proc|
          proc.call(options)
        end
      end
    end

    def format(name)
        dasherize? ? name.to_s.underscore.dasherize : name.to_s.underscore
    end

    def add_tag(attribute)
      builder.tag!(
        format(attribute.name), 
        attribute.value.to_s, 
        attribute.decorations(!options[:skip_types])
      )
    end

    def serialize
      args = [root]
      if options[:namespace]
        args << {:xmlns=>options[:namespace]}
      end
        
      builder.tag!(*args) do
        add_attributes
        add_includes
        add_procs
      end
    end        
    
    alias_method :to_s, :serialize

    class Attribute #:nodoc:
      attr_reader :name, :value, :type
    
      def initialize(name, record)
        @name, @record = name, record
      
        @type  = compute_type
        @value = compute_value
      end

      # There is a significant speed improvement if the value
      # does not need to be escaped, as #tag! escapes all values
      # to ensure that valid XML is generated.  For known binary
      # values, it is at least an order of magnitude faster to
      # Base64 encode binary values and directly put them in the
      # output XML than to pass the original value or the Base64
      # encoded value to the #tag! method. It definitely makes
      # no sense to Base64 encode the value and then give it to
      # #tag!, since that just adds additional overhead.
      def needs_encoding?
        ![ :binary, :date, :datetime, :boolean, :float, :integer ].include?(type)
      end
    
      def decorations(include_types = true)
        decorations = {}

        if type == :binary
          decorations[:encoding] = 'base64'
        end
      
        if include_types && type != :string
          decorations[:type] = type
        end
      
        decorations
      end
    
      protected
        def compute_type
          type = @record.class.columns_hash[name].type

          case type
            when :text
              :string
            when :time
              :datetime
            else
              type
          end
        end
    
        def compute_value
          value = @record.send(name)
        
          if formatter = Hash::XML_FORMATTING[type.to_s]
            value ? formatter.call(value) : nil
          else
            value
          end
        end
    end

    class MethodAttribute < Attribute #:nodoc:
      protected
        def compute_type
          Hash::XML_TYPE_NAMES[@record.send(name).class.name] || :string
        end
    end
  end
 
 # 
 # This provides the reverse of the Serialization process and will attempt to 
 # recreate objects from a XML data stream
 # 
 # 
 class XmlDeserializer #:nodoc:
    attr_reader :options
    attr_reader :root
    attr_reader :model
    attr_reader :object
    
    #
    # options[:create] =>[] List of models to ignore the id field and recreate on load
    # options[:update] =>[] List of models update to match this imported data
    # options[:lookup] =>[] List of models as termination points in graph there a simple lookup of existing object is used
    # options[:include]->[] List of relationship names to used in xml generation
    #
    #
    def initialize(model, options = {})
      @model = model 
      @options = options.dup
      @options[:create]  = XmlDeserializer.fill(options[:create])
      @options[:update]  = XmlDeserializer.fill(options[:update])
      @options[:include] = XmlDeserializer.fill(options[:include])
      @options[:except]  = XmlDeserializer.fill(options[:except])
      @options[:override]   = XmlDeserializer.fill(options[:override] || {})
      @options[:reference]  = XmlDeserializer.fill(options[:reference] || {})

      #logger.info " #{model}.from_xml( options={"
      #logger.info "  	:create=>[#{@options[:create].to_a.join(', ')}],"
      #logger.info "  	:update=>[#{@options[:update].to_a.join(', ')}],"
      #logger.info "  	:reference=>[#{@options[:reference].to_a.join(', ')}],"
      #logger.info "  	:override=>[#{@options[:override].to_a.join(', ')}],"
      #logger.info "  	:include=>[#{@options[:include].to_a.join(', ')}],"
      #logger.info "  	:except=>[#{@options[:except].to_a.join(', ')}]}"

    end
    
    ##
    #Helper to sort out the inputted options
    #
    def XmlDeserializer.fill(object)
      case object
      when Set
         return object.to_a.collect{|i|i.to_s}
      when Hash
         return object.stringify_keys!
      when Array
         return object.uniq.collect{|i|i.to_s}
      else
         return []
      end
    end 
    ##
    # Defeult logger got tracing problem
    #
    def logger
      ActionController::Base.logger rescue nil
    end
    
    ##.
    # Setup from String or xml object for reading
    # 
    def setup(xml)
      case xml 
      when String, File, Tempfile,StringIO
         @doc = REXML::Document.new(xml)
         @root = @doc.root
      when REXML::Element
         @root = xml
      when REXML::Document
         @doc = xml 
         @root = @doc.root
      end
      raise RuntimeError, 'from_xml() failed did not any xml to read ' if @root.nil?
    end
    ##
    # Create records in databases as loading XML
    # 
    # Example
    #   options[:create] = [:assays,:assay_protocols]
    # 
    def create?(klass)
      options[:create].include?(klass.to_s.underscore)
    end
    ##
    # Test if this is on the update attributes if exists list
    def update?(klass)
      options[:update].include?(klass.to_s.underscore)
    end

    def include?(klass)
      options[:include].include?(klass.to_s.underscore)
    end

    def exclude?(attribute)
      options[:except].include?(attribute.to_s.underscore)
    end

    def override?(attribute)
      options[:override][attribute.to_s]
    end

    ##
    # Lookup records in databases as loading XML
    # This is used to stop recursion on back reference to preview loadded types. Should with 
    # simple graphs but may have problem with many to many self references and trees.
    # 
    def reference?(attribute)
        options[:reference].include?(attribute.to_s.underscore)
    end
    ##
    # use dashes in names
    #         
    def dasherize?
      !options.has_key?(:dasherize) || options[:dasherize]
    end

    ##
    # The the class for a XML element
    #  "<study-protocol>" => StudyProtocol
    #  "<id type=integer>" => Integer
    #  
    def element_to_class(element)
       name = element.attribute('type') 
       name ||= element.name.underscore 
       return eval(name.camelcase)
    end
    ##
    # Convert object to a xml style name 
    # 
    #  StudyProtocol => study-protocl
    #  
    def format(object)
       dasherize? ? object.to_s.underscore.dasherize : object.to_s.underscore
    end

    ##
    # Lookup the element by id in the current database 
    # 
    def lookup(element)
       source_model = element_to_class(element)
       id = element.elements['id'].text
       return source_model.find(id)
    end
    ##
    # Lookup a reference to a existing record
    # returned the last created match to hopefully return internal references
    # @todo handle cyclic references to other created elements better
    #       make sure models have valiations for this in code
    #
    def reference(element,link)
       item_class = eval(link.class_name)
       if reference?(link.name)
         #logger.info "reference? #{link.name}"
         list = []
         logger.info element.to_s
         element.elements.each do |i|
           list << " #{i.name}='#{i.text}' " 
         end
         logger.info "lookup  #{item_class}.find(:first, :conditions => #{list.join(' and ')})"
         return item_class.find(:first, :conditions => list.join(' and '),:order =>'id desc')
       else 
         child_options = options.dup
         child_options[:include] = nil
         child_options[:override]= {}
       
         return item_class.from_xml(element,child_options)
       end
    end
    #
    # Read the basic attributes
    #
    def read_attributes
       for column in model.column_names
          if override?(column)
            @object[column]= override?(column)  
            logger.debug "override #{column}=#{override?(column)} [#{object[column]}]"
            
          elsif not exclude?(column) 
            value = root.elements[format(column)]
            unless value.nil?
              @object[column]= value.text
              #logger.info "read   #{object.class} #{column}=#{value.text} [#{object[column]}]"
            end 
            
          end  
       end          
    end

   ##
   # Deal with references to bemore objects before basic save
   # 
    def read_references
       for relation_name in model.reflections.keys
         link = model.reflect_on_association(relation_name.to_sym)
         if (link.macro == :has_one or link.macro == :belongs_to)  and !exclude?(relation_name) 
           element = root.elements[ format(relation_name) ]

           unless element.nil?
              @object.send("#{relation_name}=", reference(element,link) )
           end
           
         end  
       end
    end
    
   ##
   # as inserting will have to add dependent collections are objects
   # 
    def read_collections
       for relation_name in options[:include]
        link = model.reflect_on_association(relation_name.to_sym)
        if (link and (link.macro == :has_many or link.macro == :has_and_belongs_to_many))
            child_options = @options.dup
            child_options[:except] << link.primary_key_name
            child_options[:include] = nil
            child_options[:override] = { link.primary_key_name => object.id }
 
            element = root.elements[ format(relation_name) ]

            unless element.nil? 
                logger.info "reading collection #{element.name}"
                element.each_element do |child|
                    item_class = element_to_class(child)
                    item = item_class.from_xml(child,child_options)
                    eval("object.#{relation_name} <<  item" )
                    #if item.save!
                    #   logger.info "Inserted #{item.class}.#{item.id}" 
                    #else
                    #   logger.warning "Failed Inserting #{item.class}.#{item.id} #{item.errors.full_messages().join('\n')}"
                    #   raise "Xml Deserialized Problem: Inserted #{item.class}.#{item.id} #{item.errors.full_messages().join('<br/>')}"
                    #end
                end 
            end
         end
       end         
    end
    ##
    # Convert a piece of xml to a object grapg
    # 
    def to_object(xml)
       setup(xml)
       if !create?(root.name) and root.elements['id']
          id = root.elements['id'].text
          @object =  model.find(id)
          logger.info "find #{model}"
       else  
          logger.info "new  #{model}"
          @object = model.new(@options[:override])
       end
       unless @object
          raise "Reference to #{model} #{root} "
       end
       read_attributes
       read_references         
  
       if (object.new_record? and  create?(model))
           old_id = @object.id
           @object.id = nil
           unless @object.save
             raise "Xml Deserialized Problem: Inserted #{@object.class}.#{@object.id} #{@object.errors.full_messages().join('<br/>')}"
           end
           logger.info "Inserted #{object.class}.#{object.id} " 
           read_collections
       elsif update?(object.class)
          unless @object.save
             raise "Xml Deserialized Problem: Updating #{@object.class}.#{@object.id} #{@object.errors.full_messages().join('<br/>')}"
          end
          logger.info "Updating #{object.class}.#{object.id} "            
       end
       
       return object
    end
  end
end