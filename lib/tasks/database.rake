namespace :biorails do
  namespace :db do
 
    desc 'Loads the database schema and the initial content from db/bootstrap'
    task :bootstrap => :environment do
      path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','bootstrap') )
      ActiveRecord::Base.establish_connection 
      puts "Adding template......"
      Biorails::TEMPLATE_MODELS.each do |model|
        filename = File.join(path,model.to_s.tableize + '.yml')
        n = Biorails::Dba.import_model(model,filename) if File.exists? filename
        p "imported #{n} from #{filename}"
      end
      puts "Adding content......"
      Biorails::PROJECT_MODELS.each do |model|
        filename = File.join(path,model.to_s.tableize + '.yml')
        n = Biorails::Dba.import_model(model,filename) if File.exists? filename
        p "imported #{n} from #{filename}"
      end
      Rake::Task['biorails:oracle:reset_sequences'].invoke if Biorails::Check.oracle?
    end
  
    desc "Dump biorails database to a file"
    task :backup => :environment do
      database, user, password = Biorails::Dba.retrieve_db_info
      Biorails::Dba.backup_db(database, user, password)
    end 
   
    desc 'Import all the catalogue information from another schema DIR=directory for set source' 
    task :import_catalog => :environment do 
      path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','export') )
      ActiveRecord::Base.establish_connection 
      Biorails::CATALOG_MODELS.each do |model| 
        filename = File.join(path,model.to_s.tableize + '.yml')
        Biorails::Dba.import_model(model,filename) if File.exists? filename
      end 
      Rake::Task['biorails:oracle:reset_sequences'].invoke if Biorails::Check.oracle?
      Rake::Task['biorails:db:catalog_repopulate'].invoke
    end 

    desc 'Report number of rows in every table'
    task :dbsize => :environment do 
      path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','export') )
      ActiveRecord::Base.establish_connection 
      database, user, password = Biorails::Dba.retrieve_db_info
      p "For [#{RAILS_ENV}] database #{database} as user #{user}"
      p "=================================================="
      Biorails::ALL_MODELS.each do |model| 
        p "   #{model} has #{model.count} records"
      end 
    end 

    desc 'Export all models for move another schema  DIR=directory to set destination' 
    task :export => :environment do 
      path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','export') )
      ActiveRecord::Base.establish_connection 
      Biorails::ALL_MODELS.each do |model| 
        filename = File.join(path,model.to_s.tableize + '.yml')
        Biorails::Dba.export_model(model,filename)
      end 
    end 

    desc 'Import all models from a another schema DIR=directory for set source' 
    task :import => :environment do 
      path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','export') )
      ActiveRecord::Base.establish_connection 
      Biorails::ALL_MODELS.each do |model| 
        filename = File.join(path,model.to_s.tableize + '.yml')
        Biorails::Dba.import_model(model,filename) if File.exists? filename
      end 
      Rake::Task['biorails:oracle:reset_sequences'].invoke if Biorails::Check.oracle?
      Rake::Task['biorails:db:catalog_repopulate'].invoke
    end 

    desc 'Export all the catalogue information for another schema  DIR=directory to set destination' 
    task :export_catalog => :environment do 
      path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','export') )
      ActiveRecord::Base.establish_connection 
      Biorails::CATALOG_MODELS.each do |model| 
        filename = File.join(path,model.to_s.tableize + '.yml')
        Biorails::Dba.export_model(model,filename)
      end 
    end 

    desc 'Import Database Template (Structure without confedential data) DIR=directory for set source' 
    task :import_template => :environment do 
      path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','export') )
    
      DataContext.establish_connection 
      Biorails::TEMPLATE_MODELS.each do |model| 
        filename = File.join(path,model.to_s.tableize + '.yml')
        Biorails::Dba.import_model(model,filename) if File.exists? filename
      end
      Rake::Task['biorails:oracle:reset_sequences'].invoke if Biorails::Check.oracle?
      Rake::Task['biorails:db:catalog_repopulate'].invoke
    end 

    desc 'Export Database Template (Structure without confedential data) DIR=directory to set destination' 
    task :export_template => :environment do 
      path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','export') )
      ActiveRecord::Base.establish_connection 
      Biorails::TEMPLATE_MODELS.each do |model| 
        filename = File.join(path,model.to_s.tableize + '.yml')
        Biorails::Dba.export_model(model,filename)
      end 
    end 

    desc "Repopulate List Element children "
    task :catalog_repopulate => :environment do
       list = ListElement.find(:all)
       puts "Repopulating ListElement from from parent csv list"
       puts "=================================================="
       for element in list
         puts " ListElement #{element.name} => #{element.content}"
         begin
           element.populate
           puts "  children => "+ element.children.collect{|i|i.name}.join(",")
         rescue Exception => ex
            puts "    failed #{ex.message}"
         end
       end
    end
    desc "Rebuild all application managed indexes"
    task :reindex => [:reindex_trees]

    desc "Rebuild all indexes, balances tree for folder,task rows etc s"
    task :reindex_trees => :environment do
      puts "Recaching Roles..."
      Role.rebuild_all
      puts "Resorting folder..."
      ProjectElement.rebuild_sets
      puts "Resorting Parameter context..."
      ParameterContext.rebuild_sets
      puts "Resorting Text Content versions..."
      Content.rebuild_sets
      puts "Resorting Task rows..."
      TaskContext.rebuild_sets
    end

    desc "Purge the Database of old data"
    task :purge => :environment do
      puts "Remove unlinked assets"
      puts "Remove old content versions"
      puts  "Remove completed requests"
      puts "Empty audit logs"
    end  
  end
end


