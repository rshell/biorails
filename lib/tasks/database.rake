namespace :biorails do
 
  desc "Create database (using database.yml config as source of connection information)"
  task :create => :environment do
      database, user, password = retrieve_db_info
      if database=='mysql'
        sql = "CREATE DATABASE #{database};"
        sql += "GRANT ALL PRIVILEGES ON #{database}.* TO #{user}@localhost IDENTIFIED BY '#{password}';"
        mysql_execute(user, password, sql)
      else
        puts "Sorry must be done manually for this database"
      end
  end

  desc "Setup tables and load initials data set into the database "
  task :setup => :environment do
      file = ENV['SCHEMA'] || "db/schema.rb"
      load(file)
      require 'active_record/fixtures' 
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'bootstrap', '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures('db/bootstrap', File.basename(fixture_file, '.*'))
      end
  end

  desc 'Loads the database schema and the initial content'
  task :bootstrap => :environment do
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','bootstrap') )
    ActiveRecord::Base.establish_connection 
    ActiveRecord::Base.connection.
    Biorails::TEMPLATE_MODELS.each do |model| 
       filename = File.join(path,model.table_name + '.yml')
       import_model(model,filename) if File.exists? filename
    end 
  end

  desc 'Import all the catalogue information from another schema DIR=directory for set source' 
  task :import_catalog => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    Biorails::CATALOG_MODELS.each do |model| 
       filename = File.join(path,model.table_name + '.yml')
       import_model(model,filename) if File.exists? filename
    end 
  end 

  desc 'Export all the catalogue information for another schema  DIR=directory to set destination' 
  task :export_catalog => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    Biorails::CATALOG_MODELS.each do |model| 
       filename = File.join(path,model.table_name + '.yml')
       export_model(model,filename)
    end 
  end 

  desc 'Import Database Template (Structure without confedential data) DIR=directory for set source' 
  task :import_template => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    
    DataContext.establish_connection 
    Biorails::TEMPLATE_MODELS.each do |model| 
       filename = File.join(path,model.table_name + '.yml')
       import_model(model,filename) if File.exists? filename
    end 
  end 

  desc 'Export Database Template (Structure without confedential data) DIR=directory to set destination' 
  task :export_template => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    Biorails::TEMPLATE_MODELS.each do |model| 
       filename = File.join(path,model.table_name + '.yml')
       export_model(model,filename)
    end 
  end 
  
  desc "Rebuild all indexes"
  task :reindex => :environment do
      puts "Resorting folder..."
      ProjectElement.rebuild_sets
      puts "Free Text indexing Inventory tables"
      Project.rebuild_index(Compound,Batch,Plate,Container)
      puts "Feee Text indexing Projects"
      Project.rebuild_index(Study,StudyProtocol,StudyParameter,StudyQueue,Project,ProjectElement,Experiment,Task,Request,RequestService)
  end

  desc "Dump biorails database to a file"
  task :backup => :environment do
      database, user, password = retrieve_db_info
      backup_db(database, user, password)
  end 


  desc "Purge the Database of old data"
  task :purge => :environment do
      puts "Remove unlinked assets"
      puts "Remove old content versions"
      puts  "Remove completed requests"
      puts "Empty audit logs"
  end

private
  def retrieve_db_info
    result = File.read "#{RAILS_ROOT}/config/database.yml"
    result.strip!
    config_file = YAML::load(ERB.new(result).result)
    return [  config_file[RAILS_ENV]['database'],
              config_file[RAILS_ENV]['username'],
              config_file[RAILS_ENV]['password']  ]
  end
  
  def mysql_execute(username, password, sql)
    system("/usr/bin/env mysql -u #{username} -p'#{password}' --execute=\"#{sql}\"")
  end

  def oracle_execute(username, password, sql)
    system("/usr/bin/env sqlplus #{username}/#{password}@#{database} #{sql}")
  end

  def backup_db(database, user, password)
      datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")  
      base_path = ENV["DIR"] || "db" 
      backup_folder = File.join(base_path, 'backup')
      File.makedirs(backup_folder)
      backup_file = File.join(backup_folder, "#{RAILS_ENV}_#{datestamp}_dump") 
      p database
      case database
      when 'oracle','oci8'
        puts "Using oracle export utility for backup"
        cmd = "/usr/bin/env exp #{username}/#{password}@#{database} file=#{backup_file}.dmp "
        puts cmd 
        system(cmd)
      when 'mysql'
        puts "Using mysql dump utility for backup"
        cmd = "/usr/bin/env mysqldump --opt --skip-add-locks -u#{user} "
        puts cmd + "... [password filtered]"
        cmd += " -p'#{password}' " unless password.nil?
        cmd += " #{database} | gzip -c > #{backup_file}"
        system(cmd)
      else
        puts "Using default fixtures for backup"
        Biorails::ALL_MODELS.each do |model| 
           filename = File.join(backup_folder,model.table_name + '.yml')
           export_model_fixture(model,filename)
        end 
      end
  end
  
  def export_model(model,filename=nil)
    
    filename ||= File.join(RAILS_ROOT,'test','fixtures',model.table_name + '.yml')
    File.open(filename, 'w' ) do |file|
      data = model.find(:all)
      file.write data.inject({}) { |hash, record|
        hash["#{record.dom_id}"] = record
        hash
      }.to_yaml
    end
   p "Writen #{model.count} #{model.to_s} records exported to #{filename}"
  end

  def import_model(model,filename=nil)
   filename ||= File.join(RAILS_ROOT,'test','fixtures',model.tableize + '.yml')
   success =0
   records = YAML::load( File.open(filename))
    model.transaction do
      records.values.each do |row|
        begin
          if row.is_a?(Hash)
            @new_item = model.new(row)
            @new_item.id = row['id']
          else # is mapped to model object
            @new_item = row.class.new(row.attributes)
            @new_item.id = row.id
          end
          if @new_item.save
             success =  success + 1
          end
        rescue Exception => ex
            p "Error for [#{row.class}.#{row.id}] #{ex.message} " 
        end
      end
     p "Total #{success} out of #{records.size} #{model.to_s} records imported from #{filename}"
    end

   end
end


