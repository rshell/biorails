class AlcesScaffoldGenerator < Rails::Generator::NamedBase
  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_singular_name, @controller_plural_name = inflect_names(base_name)

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end
  
  def all_columns
     @columns ||= ActiveRecord::Base.connection.columns(table_name)
     return @columns
   rescue 
     return []
  end

  def content_columns
     @columns = ActiveRecord::Base.connection.columns(table_name)
     return @columns.reject { |c|c.name=='id' || c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ }        
   rescue 
     return []
  end
  
def field(column)
    case column.type
      when :integer
        return "<%= text_field :#{file_name}, :#{column.name}, :size=>#{column.limit}, :class=> 'x-form-text x-form-field' %>"
      when :string
        if column.limit>80
          return "<%= text_area :#{file_name},:#{column.name},:cols=>80,:rows=>3, :class=> 'x-form-area x-form-field' %>"
        else
          return "<%= text_field :#{file_name}, :#{column.name}, :size=>#{column.limit}, :class=> 'x-form-text x-form-field' %>"
        end
      when :text
        return "<%= text_area :#{file_name},:#{column.name},:cols=>80,:rows=>3,  :class=> 'x-form-area x-form-field' %>"
      when :boolean
        return "<%= check_box :#{file_name},:#{column.name}, :class=> 'x-form-field' %>"
     else
        return "<%= text_field :#{file_name},:#{column.name}, :size=>40, :class=> 'x-form-text x-form-field' %>"
    end
end  
  
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions(controller_class_path, "#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_path, "#{class_name}")

      # Controller, helper, views, and test directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('app/views/layouts', controller_class_path))
      m.directory(File.join('test/functional', controller_class_path))
      m.directory(File.join('test/unit', class_path))

      for action in scaffold_views
        m.template(
          "#{action}.rhtml",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.rhtml")
        )
      end

      # Layout and stylesheet.
      m.template('style.css', 'public/stylesheets/scaffold.css')

      m.template('model.rb', File.join('app/models', class_path, "#{file_name}.rb"))

      m.template(
        'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      m.template('functional_test.rb', File.join('test/functional', controller_class_path, "#{controller_file_name}_controller_test.rb"))
      m.template('helper.rb',          File.join('app/helpers',     controller_class_path, "#{controller_file_name}_helper.rb"))
      m.template('unit_test.rb',       File.join('test/unit',       class_path, "#{file_name}_test.rb"))
      m.template('fixtures.yml',       File.join('test/fixtures', "#{table_name}.yml"))

      unless options[:skip_migration]
        m.migration_template(
          'migration.rb', 'db/migrate', 
          :assigns => {
            :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}",
            :attributes     => attributes
          }, 
          :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
        )
      end

      m.route_resources controller_file_name
    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} scaffold_resource ModelName [field:type, field:type]"
    end

    def scaffold_views
      %w[ index show new edit _show _edit _new _list _form _help _actions _status ]
    end

    def model_name 
      class_name.demodulize
    end
end
