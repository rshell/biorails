namespace :biorails do
  namespace :db do
 
    desc 'Loads the database schema and the initial content from db/bootstrap'
    task :bootstrap => :environment do
      path = (ENV['DIR'] ? ENV['DIR'] : File.join(RAILS_ROOT,'db','bootstrap') )
      ActiveRecord::Base.establish_connection 
      Biorails::TEMPLATE_MODELS.each do |model| 
        filename = File.join(path,model.to_s.tableize + '.yml')
        n = Biorails::Dba.import_model(model,filename) if File.exists? filename
        p "imported #{n} from #{filename}"
      end 
    end
  
    desc "Dump biorails database to a file"
    task :backup => :environment do
      database, user, password = retrieve_db_info
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
  
    desc "Rebuild all indexes, balances tree for folder,task rows etc and rebuild ferret free text indexes"
    task :reindex => :environment do
      puts "Resorting folder..."
      ProjectElement.rebuild_sets
      puts "Resorting Parameter context..."
      ParameterContext.rebuild_sets
      puts "Resorting Text Content versions..."
      Content.rebuild_sets
      puts "Resorting Task rows..."
      TaskContext.rebuild_sets
      puts "Free Text indexing Inventory tables"
      Project.rebuild_index(Compound,Batch,Plate,Container)
      puts "Feee Text indexing Projects"
      Project.rebuild_index(Assay,AssayProtocol,AssayParameter,AssayQueue,Project,ProjectElement,Experiment,Task,Request,RequestService)
    end

    desc "Rebuild html cached versions of task,experiments etc"
    task :recache => :environment do
      puts "Pre calculating and caching html for references"
      for item in ProjectElement.find(:all,:conditions=>'reference_type is not null')  
        unless item.content_id
          item.cache_html 
          item.save
        end
      end   
    end

    desc "Purge the Database of old data"
    task :purge => :environment do
      puts "Remove unlinked assets"
      puts "Remove old content versions"
      puts  "Remove completed requests"
      puts "Empty audit logs"
    end
  
    desc "Delete and recreate assay,experiment folders"
    task :folder_reset_linked => :environment do
      puts "Moving references under correct heading"
      for project in Project.find(:all)
        puts " "
        puts "Project[#{project.id}] #{project.name}"
        puts "============================================="
        puts "Rebuilding tree indexes....."
        project.folder.rebuild_set
        ProjectElement.transaction do

          puts "Assays "
          for assay in project.assays
            puts "assay #{assay.folder.path}"
            puts "parameters #{assay.parameters.collect{|i|i.folder.name}.join(",")}"
            for protocol in assay.protocols
              puts "protocol #{protocol.folder.path}"
              for process in protocol.versions
                puts "version #{process.folder.path}"
              end
            end
            puts "queues " << assay.queues.collect{|i|i.folder.name}.join(",")
          end
          
          puts "Experiments "
          for experiment in project.experiments
            puts "experiment #{experiment.folder.path}"
            for task in experiment.tasks
              puts "task #{task.folder.path}"
            end
          end

          puts "Requests "
          for request in project.requests
            puts "request #{request.folder.path}"
          end

          puts "report "
          for report in project.reports
            puts "report #{report.folder.path}"
          end

        end 
      end     
    end
    
    desc "Sort out folder references and cache html copies"
    task :folder_cleanup => :environment do
      puts "Moving references under correct heading"
      for project in Project.find(:all)
        puts " "
        puts "Project[#{project.id}] #{project.name}"
        puts "============================================="
        puts "Rebuilding tree indexes....."
        project.folder.rebuild_set
        ProjectElement.transaction do
          puts "Assays "
          folder = project.folder(:assays)       
          folder_references_group_under(folder,Assay)

          puts "Experiments "
          folder = project.folder(:experiments)       
          folder_references_group_under(folder,Experiment)

          puts "Requests "
          folder = project.folder(:requests)       
          folder_references_group_under(folder,Request)

          puts "Reports "
          folder = project.folder(:reports)       
          folder_references_group_under(folder,Report)
        end 
      end
    end

    def folder_references_group_under(folder,klass)
      ProjectElement.transaction do
        project = folder.project
        for item in project.folders_for(klass)
          if item.parent_id != folder.id
            if folder.folder?(item.name)
              puts " duplicate folder for [#{item.id}] #{item.path}"
            else
              puts " moved [#{item.id}] #{item.path} below [#{folder.id}] #{folder.path}"
              item.move_to_child_of(folder)
            end
          end             
        end   
      end      
    end
  end
end


