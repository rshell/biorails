namespace :biorails do
 
  desc "Create database (using database.yml config as source of connection information)"
  task :create => :environment do
      database, user, password = Biorails::Dba.retrieve_db_info
      sql = "CREATE DATABASE #{database};"
      sql += "GRANT ALL PRIVILEGES ON #{database}.* TO #{user}@localhost IDENTIFIED BY '#{password}';"
      Biorails::Dba.mysql_execute(user, password, sql)
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
    Biorails::TEMPLATE_MODELS.each do |model| 
       filename = File.join(path,model.to_s.tableize + '.yml')
       Biorails::Dba.import_model(model,filename) if File.exists? filename
    end 
  end

  desc 'Import all the catalogue information from another schema DIR=directory for set source' 
  task :import_catalog => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    Biorails::CATALOG_MODELS.each do |model| 
       filename = File.join(path,model.to_s.tableize + '.yml')
       Biorails::Dba.import_model(model,filename) if File.exists? filename
    end 
  end 

  desc 'Export all models for move another schema  DIR=directory to set destination' 
  task :dbsize => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    database, user, password = Biorails::Dba.retrieve_db_info
    p "For [#{RAILS_ENV}] database #{database} as user #{user}"
    p "=================================================="
    Biorails::ALL_MODELS.each do |model| 
       p "   #{model} has #{model.count} records"
    end 
  end 

  desc 'Export all models for move another schema  DIR=directory to set destination' 
  task :check => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    database, user, password = Biorails::Dba.retrieve_db_info
    p "For [#{RAILS_ENV}] database #{database} as user #{user}"
    p "=================================================="
    Biorails::ALL_MODELS.each do |model| 
       o = model.find(:first)
       if o
         model.columns.each{|c| v = o.send(c.name) }
         p "   #{model} appears ok"
       else
         p "   #{model} appears empty"
       end
    end 
  end 

  desc 'Export all models for move another schema  DIR=directory to set destination' 
  task :export => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    Biorails::ALL_MODELS.each do |model| 
       filename = File.join(path,model.to_s.tableize + '.yml')
       Biorails::Dba.export_model(model,filename)
    end 
  end 

  desc 'Import all models from a another schema DIR=directory for set source' 
  task :import => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    Biorails::ALL_MODELS.each do |model| 
       filename = File.join(path,model.to_s.tableize + '.yml')
       Biorails::Dba.import_model(model,filename) if File.exists? filename
    end 
  end 

  desc 'Export all the catalogue information for another schema  DIR=directory to set destination' 
  task :export_catalog => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    Biorails::CATALOG_MODELS.each do |model| 
       filename = File.join(path,model.to_s.tableize + '.yml')
       Biorails::Dba.export_model(model,filename)
    end 
  end 

  desc 'Import Database Template (Structure without confedential data) DIR=directory for set source' 
  task :import_template => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    
    DataContext.establish_connection 
    Biorails::TEMPLATE_MODELS.each do |model| 
       filename = File.join(path,model.to_s.tableize + '.yml')
       Biorails::Dba.import_model(model,filename) if File.exists? filename
    end 
  end 

  desc 'Export Database Template (Structure without confedential data) DIR=directory to set destination' 
  task :export_template => :environment do 
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'test','fixtures') )
    ActiveRecord::Base.establish_connection 
    Biorails::TEMPLATE_MODELS.each do |model| 
       filename = File.join(path,model.to_s.tableize + '.yml')
       Biorails::Dba.export_model(model,filename)
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
      Biorails::Dba.backup_db(database, user, password)
  end 


  desc "Purge the Database of old data"
  task :purge => :environment do
      puts "Remove unlinked assets"
      puts "Remove old content versions"
      puts  "Remove completed requests"
      puts "Empty audit logs"
  end

end


