class Admin::DatabaseController < ApplicationController

  use_authorization :dba,
                    :actions => [:backup,:recover,:initialize],
                    :rights => :current_user
                    
   def reindex
     Project.rebuild_index(Compound,Batch,Plate,Container)
     Project.rebuild_index(Study,StudyProtocol,StudyParameter,StudyQueue,Project,ProjectElement,Experiment,Task,Request,RequestService)
   end
     
##
# Backup the databases 
#
  def backup
    @messages = []    
      sql = "SELECT * FROM %s" 
      skip_tables = ["schema_info"] 
      ActiveRecord::Base.establish_connection 
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name| 
        File.open("#{RAILS_ROOT}/db/backup/#{table_name}.yml", 'w' ) do |file| 
          write_yaml_fixtures_to_file(sql % table_name, table_name, file)
        end 
      end     
  end

##
# Recover the database from a pervious backup
#
  def recover
    @messages = []    
    ActiveRecord::Base.establish_connection
    Dir.glob(File.join(RAILS_ROOT,'db','backup',"*.yml")).each do |f|
      table_name = f.gsub(File.join(RAILS_ROOT,'test','fixtures', ''), '').gsub('.yml', '')
      import_table_fixture(table_name,f)
    end
  end

##
# Initialize new database
#
  def initialize
    @messages = []    
    ActiveRecord::Base.establish_connection
    Dir.glob(File.join(RAILS_ROOT,'db','bootstrap',"*.yml")).each do |f|
      table_name = f.gsub(File.join(RAILS_ROOT,'test','fixtures', ''), '').gsub('.yml', '')
      import_table_fixture(table_name,f)
    end    
  end
  
protected

def import_table_fixture(table,filename)
  success = Hash.new
  records = YAML::load( File.open(filename))

  records.sort.each do |r|
    row = r[1]
    columns = []
    values = []
  
    row.each_pair do |column, value|
      if column.to_sym
        columns << ActiveRecord::Base.connection.quote_column_name(column)
        values << ActiveRecord::Base.connection.quote(value)
      else
        @messages << "Column not found" + column.to_s
      end
    end
    
    insert_sql = "INSERT INTO #{table} (" + columns.join(', ') + ") VALUES (" + values.join(', ') + ")"

      begin
        if ActiveRecord::Base.connection.execute(insert_sql)
          success[table.to_sym] = (success[table.to_sym] ? success[table.to_sym] + 1 : 1)
        end
      rescue
        @messages << "#{table} failed to import: " + insert_sql
      end
  end

  @messages << "Total of #{success[table.to_sym]} #{table} records imported successfully"
end


 def import_model_fixture(model,filename)
   success = Hash.new
   records = YAML::load( File.open(filename))
    @model = Class.const_get(model)
    @model.transaction do
      records.sort.each do |r|
        row = r[1]
        @new_model = @model.new

        row.each_pair do |column, value|
          if column.to_sym
            @new_model.send(column + '=', value)
          else
            @messages << "Column not found" + column.to_s
          end
        end


        begin
          if @new_model.save
            success[model.to_sym] = (success[model.to_sym] ? success[model.to_sym] + 1 : 1)
          end
        rescue
            @messages << "#{@new_model.class.to_s} failed to import: " + r.inspect
            @messages << @new_model.errors.inspect
        end
      end

      @messages << "Total of #{success[model.to_sym]} #{@new_model.class.to_s} records imported successfully"
    end
  end

  def write_yaml_fixtures_to_file(sql, fixture_name,file)
    i = "000"
    data = ActiveRecord::Base.connection.select_all(sql)
    file.write data.inject({}) { |hash, record|
        hash["#{fixture_name}_#{i.succ!}"] = record
        hash
    }.to_yaml
  end
    
end
