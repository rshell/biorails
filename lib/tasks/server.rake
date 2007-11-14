namespace :biorails do
  desc "Install the the needed gem (will need root rights)"
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
    system('gem install rjb -y')
  end
  
  desc "Sync with subversion and restart server"
  task :sync => :environment do
    system('svn info')  
    system('svn update')  
    system('mongrel_rails cluster::restart')  
  end

  desc "Identify any differences between local copy and master copy from biorails.org"
  task :diff => :environment do
    system('svn diff ')  
    system('svn info')  
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

  desc 'Do Basic Check that all core models exists and actual link to database tables' 
  task :check => :environment do 
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

end
