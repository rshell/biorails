# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

namespace :biorails do

  desc "Install the the needed gem dependencies (will need root rights)"
  task :gems do   
    system('gem install rails -y')
    system('gem install tzinfo -y')
    system('gem install gnuplot -y')
    system('gem install mongrel -y')
    system('gem install mongrel_cluster -y')
    system('gem install icalendar -y')
    system('gem install mime-types -y ')
    system('gem install builder -y')
    system('gem install rmagick -y')
    system('gem install ruport -y')
  end

  desc "Create database (using database.yml config as source of connection information)"
  task :create => :environment do
      database, user, password = retrieve_db_info
    
      sql = "CREATE DATABASE #{database};"
      sql += "GRANT ALL PRIVILEGES ON #{database}.* TO #{user}@localhost IDENTIFIED BY '#{password}';"
      mysql_execute(user, password, sql)
  end

  desc "setup tables and load initials data set into the database "
  task :setup => :environment do
      file = ENV['SCHEMA'] || "db/schema.rb"
      load(file)
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'bootstrap', '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures('db/bootstrap', File.basename(fixture_file, '.*'))
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
      datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")  
      base_path = ENV["DIR"] || "db" 
      backup_folder = File.join(base_path, 'backup')
      backup_file = File.join(backup_folder, "#{RAILS_ENV}_#{datestamp}_dump.sql.gz") 
      File.makedirs(backup_folder)
      database, user, password = retrieve_db_info
    
      cmd = "/usr/bin/env mysqldump --opt --skip-add-locks -u#{user} "
      puts cmd + "... [password filtered]"
      cmd += " -p'#{password}' " unless password.nil?
      cmd += " #{database} | gzip -c > #{backup_file}"
      result = system(cmd)
    end
  
  desc "Load schema and data from an SQL file (/db/restore.sql)"
  task :restore => :environment do
      base_path = ENV["DIR"] || "db" 
      backup_folder = File.join(base_path, 'backup')   
      archive = "#{RAILS_ROOT}/db/restore.sql"
      database, user, password = retrieve_db_info
    
      cmd = "/usr/bin/env mysql -u #{user} #{database} < #{archive}"
      puts cmd + "... [password filtered]"
      cmd += " -p'#{password}'"
      result = system(cmd)
  end
  
  desc "Start Mongrel cluster"
  task :start => :environment do
    system('mongrel_rails cluster::start')  
  end

  desc "Restart Mongrel cluster"
  task :restart => :environment do
    system('mongrel_rails cluster::restart')  
  end

  desc "Stop Mongrel cluster"
  task :stop => :environment do
    system('mongrel_rails cluster::stop')  
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
    return [
      config_file[RAILS_ENV]['database'],
      config_file[RAILS_ENV]['username'],
      config_file[RAILS_ENV]['password']
    ]
  end
  
  def mysql_execute(username, password, sql)
    system("/usr/bin/env mysql -u #{username} -p'#{password}' --execute=\"#{sql}\"")
  end

  def import_model_fixture(model)
    filename = File.join(RAILS_ROOT,'test','fixtures',model.tableize + '.yml')
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
				p "Column not found" + column.to_s
			end
		end
	
	
		begin
		if @new_model.save
			success[model.to_sym] = (success[model.to_sym] ? success[model.to_sym] + 1 : 1)
		end
		rescue
			p "#{@new_model.class.to_s} failed to import: " + r.inspect
			p @new_model.errors.inspect
	   end
	end
	
	p "Total of #{success[model.to_sym]} #{@new_model.class.to_s} records imported successfully"
	end
    end

end


