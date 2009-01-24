class MigrationGenerator < Rails::Generator::Base

  def initialize(runtime_args, runtime_options = {})
    super
    @migration_arg_name = runtime_args.first
    @migration_filed_name = begin
                            i = Dir["#{RAILS_ROOT}/db/migrate/*definition_migration*"].length
                            "definition_migration_#{i+1}"
                           end
  end

  def manifest
    require 'auto_migrations'
    require 'sexy_statements_hook'
    ActiveRecord::Migration.send :include, SexyStatementsHook
    ActiveRecord::Migration.send :include, AutoMigrations      

    AutoMigrations.run
    
    print "Migration generated. Self.up is:\n" + ActiveRecord::Migration.sexy_up
    
#    connection = ActiveRecord::Base.connection
#    migration_name = input("\nEnter filename [#@migration_name]:").strip.gsub(' ', '_')
#    migration_name = @migration_name if migration_name.blank?

    migration_name = @migration_arg_name 
    if migration_name.blank?
      name = ActiveRecord::Migration.desired_migration_name 
      name = @migration_filed_name if name.blank?
      migration_name = input("\nEnter filename [#{name}]:").strip.gsub(' ', '_')
      migration_name = name if migration_name.blank?
    end  
#    migration_name = input("\nEnter filename [#@migration_name]:").strip.gsub(' ', '_')
    

    up = ActiveRecord::Migration.sexy_up + "    "
    down = ActiveRecord::Migration.sexy_down
      
    hints = <<HINT

# Hints on migrations syntax.
#
# add_column(table_name, column_name, type, options = {}) 
#	  Types are: :primary_key, :string, :text, :integer, :float, :datetime, :timestamp, :time, :date, :binary, :boolean. 
#
# Other stuff:
#   change_column(table_name, column_name, type, options = {}) - options as in add_column
#   change_column_default(table_name, column_name, default)
#   remove_column(table_name, column_name) 
#   rename_column(table_name, column_name, new_column_name) 
#
# Sample: Don't add a primary key column
#   create_table(:categories_suppliers, :id => false) do |t|
#     t.column :category_id, :integer
#     t.column :supplier_id, :integer
#   end
#
# Sample: reload columns for a model from DB
#   Person.reset_column_information
#
# More samples here: http://wiki.rubyonrails.com/rails/pages/UsingMigrations
HINT

    record do |m|
      m.migration_template 'migration.rb', 'db/migrate', 
                           :assigns => { :up => up, :down => down, :hints => hints, :migration_name => migration_name.camelize }, 
                           :migration_file_name => migration_name
      end
  end
  
  
  def input(prompt, options=nil)
    print(prompt + " ")
    if options
      while !(response = STDIN.readline.strip.downcase).in?(options); 
        print(prompt + " ")
      end
      response
    else
      STDIN.readline
    end
  end
  
end

