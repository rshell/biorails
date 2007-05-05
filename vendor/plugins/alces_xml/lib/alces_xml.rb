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
      # options[:lookup] =>[] List of models as termination points in graph there a simple lookup of existing object is used
      # options[:include]->[] List of relationship names to used in xml generation
      #
      # Example of a loader to create new study and study_parameter objects
      # in the load is even below
      #
      # Study.from_xml(:create=>[:study,:study_parameter]) 
      #
      def from_xml(options = {})
         Alces::XmlDeserializer.new(self, options).to_object
      end

     include Alces::Xml::InstanceMethods         
    end
  end

  class XmlSerializer #:nodoc:
    attr_reader :options
    
    def initialize(record, options = {})
      @record, @options = record, options.dup
    end
    
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


    def add_attributes
      (serializable_attributes + serializable_method_attributes).each do |attribute|
        add_tag(attribute)
      end
    end

    def add_includes
      if include_associations = options.delete(:include)
        root_only_or_except = { :except => options[:except],
                                :only => options[:only] }

        include_has_options = include_associations.is_a?(Hash)

        for association in include_has_options ? include_associations.keys : Array(include_associations)
          association_options = include_has_options ? include_associations[association] : root_only_or_except

          opts = options.merge(association_options)

          case @record.class.reflect_on_association(association).macro
          when :has_many, :has_and_belongs_to_many
            records = @record.send(association).to_a
            unless records.empty?
              tag = format(association)
              builder.tag!(tag) do
                records.each { |r| r.to_xml(opts.merge(:root => format(r.class) )) }
              end
            end
          when :has_one, :belongs_to
            if record = @record.send(association)
              record.to_xml(opts.merge(:root => format(association)))
            end
          end
        end

        options[:include] = include_associations
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
      @options[:lookup]  = XmlDeserializer.fill(options[:lookup])
      @options[:include] = XmlDeserializer.fill(options[:include])
      @options[:exclude] = XmlDeserializer.fill(options[:exclude])
      puts " #{model}.from_xml( options={"
      puts "  :create=>[#{@options[:create].to_a.join(', ')}],"
      puts "  :update=>[#{@options[:update].to_a.join(', ')}],"
      puts "  :lookup=>[#{@options[:lookup].to_a.join(', ')}],"
      puts "  :include=>[#{@options[:include].to_a.join(', ')}],"
      puts "  :exclude=>[#{@options[:exclude].to_a.join(', ')}]}"

    end
    def XmlDeserializer.fill(object)
      case object
      when Hash
         return object.keys.to_set
      when Array
         return object.collect{|i|i.to_s}.to_set
      else
         return []
      end
    end 
    ##.
    # Setup from String or xml object for reading
    # 
    def setup(xml)
      if xml.class== String
         @doc = REXML::Document.new(xml)
         @root = @doc.root
      else
         @root = xml
      end
      raise RuntimeError, 'from_xml() failed did not any xml to read ' if @root.nil?
    end
    ##
    # Create records in databases as loading XML
    # 
    # Example
    #   options[:create] = [:studies,:study_protocols]
    # 
    def create?(klass)
      options.has_key?(:create) and options[:create].include?(klass.to_s.underscore)
    end
    ##
    # Test if this is on the update attributes if exists list
    def update?(klass)
      options.has_key?(:update) and options[:update].include?(klass.to_s.underscore)
    end

    def include?(klass)
      options.has_key?(:include) and options[:include].include?(klass.to_s.underscore)
    end

    def exclude?(attribute)
      options.has_key?(:exclude) and options[:exclude].include?(attribute.to_s.underscore)
    end
    
    ##
    # Lookup records in databases as loading XML
    # This is used to stop recursion on back reference to preview loadded types. Should with 
    # simple graphs but may have problem with many to many self references and trees.
    # 
    def lookup?(klass)
       (options.has_key?(:lookup) and options[:lookup].any?{|i|i.to_s.underscore==klass.to_s.underscore}) or !create?(klass)
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
    # Convert a piece of xml to a object grapg
    # 
    def to_object(xml)
       setup(xml)
       if !create?(root.name) and root.elements['id']
         object =  model.find(root.elements['id'].text)
         return object if lookup?(root.name)
       end
       object = model.new
   
       for column in model.columns
          unless exclude?(column.name) 
            value = root.elements[format(column.name)]
            unless value.nil?
              object.send("#{column.name}=", value.text )
              ## puts "#{object.class} #{column.name}=#{value.text}"
            end 
          end  
       end    

       child_options = options.dup
       child_options[:lookup] << format(model.to_s) 
       ##
       # Deal with references to bemore objects before basic save
       # 
       for relation_name in model.reflections.keys
         link = model.reflections[relation_name]
         if (link.macro == :has_one or link.macro == :belongs_to)     
           element = root.elements[ format(relation_name) ]
           unless element.nil?
              puts "reference #{relation_name}"
              item_class = eval(link.class_name)
              item = item_class.from_xml(element)
              object.send("#{relation_name}=", item )
           end
         end  
       end
  
       if (object.new_record? and  create?(object.class))
           object.id = nil
           object.save 
           puts "Inserted #{object.class}.#{object.id}.." if object.valid?
           ##
           # as inserting will have to add dependent collections are objects
           # 
           for relation_name in model.reflections.keys
             link = model.reflections[relation_name]          
             child_options = options.dup
             child_options[:lookup] << format(model.to_s) 
             child_options[:exclude] << link.primary_key_name

             if (link.macro == :has_many or link.macro == :has_and_belongs_to_many)
                element = root.elements[ format(relation_name) ]
                unless element.nil?
                    puts "reading #{element.name}"
                    element.each_element do |child|
                      item_class = element_to_class(child)
                      item = item_class.from_xml(child,child_options)
                      eval("object.#{relation_name} <<  item" )
                      puts "Inserted #{item.class}.#{item.id}.." if item.valid?
                      puts item.errors.full_messages().join("\n")
                    end 
                end
             end
           end         
       elsif update?(object.class)
         puts "Updating #{object.class}.#{object.id}..."
         object.save  
       end
       
       return object
    end
  end
end