namespace :biorails do
   namespace :db do
 
  desc 'Loads the database schema and the initial content from db/bootstrap'
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
    path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','export') )
    ActiveRecord::Base.establish_connection 
    Biorails::CATALOG_MODELS.each do |model| 
       filename = File.join(path,model.to_s.tableize + '.yml')
       Biorails::Dba.import_model(model,filename) if File.exists? filename
    end 
  end 

  desc 'Export all models for move another schema  DIR=directory to set destination' 
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
  
  desc "Rebuild all indexes"
  task :reindex => :environment do
      puts "Resorting folder..."
      ProjectElement.rebuild_sets
      puts "Free Text indexing Inventory tables"
      Project.rebuild_index(Compound,Batch,Plate,Container)
      puts "Feee Text indexing Projects"
      Project.rebuild_index(Study,StudyProtocol,StudyParameter,StudyQueue,Project,ProjectElement,Experiment,Task,Request,RequestService)
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


