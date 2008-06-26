namespace :biorails do
  
  desc "Give all existing users a private key as a batch process"
  task :make_keys=> :environment do
    #quick hack so that lundbeck can update sandbox data
    users=User.find(:all)
    users.each do |user|
      if user.private_key.nil?
        user.private_key=OpenSSL::PKey::RSA.generate(4096).to_s
        
        user.save!
        p "Made a new key for #{user.name}"
      else
        p user.name + " has key already"
      end
    end
end
  
  desc "Install the the needed gem (will need root rights)"
  task :gems do   
    system('gem install rails ')
    system('gem install ntp ')
    system('gem install uuid ')
    system('gem install tzinfo ')
    system('gem install gnuplot ')
    system('gem install icalendar ')
    system('gem install mime-types ')
    system('gem install builder ')
    system('gem install rmagick ')
    system('gem install ruport ')
    system('gem install ZenTest ')
    system('gem install rspec ')
    system('gem install crypt ')
    system('gem install json ')
    system('gem install rubyzip ')
    system('gem install ruby-net-ldap ')
    system('gem install htmldoc ')
 #
 # Following build native libraries and can fail on some platforms
 #
    system('gem install ferret ')
    system('gem install mongrel ')
    system('gem install mongrel_cluster ')
  end
  
  desc "Sync with subversion and restart server"
  task :sync => :environment do
    system('svn update')  
    system('svn status')  
    system('svn info')  
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
  
  desc 'Check that we can access the network'
  task :check_network => :environment do
   unless Signature.time_source.equal? Signature::REMOTE_TIME_SERVER
     p 'The server cannot access the internet.  The local clock will be used.  If you want to use a remote time server, the server must have internet access'
 else
   p 'The network is up'
  end
  end
  
  task :check_gems => :environment do
    
  end
  
  desc 'Do Basic Check that all core models exists and actually link to database tables' 
  task :check_models => :environment do 
    ActiveRecord::Base.establish_connection  
    database, user, password = Biorails::Dba.retrieve_db_info
    p ''
    p 'Running model check'
    p "For [#{RAILS_ENV}] database #{database} as user #{user}"
    p "=================================================="
    emptytables=[]
    errors=[]
    Biorails::ALL_MODELS.each do |model| 
      begin
        print "model #{model.to_s}" 
        if model.table_exists?
          print "\t has #{model.columns.size} columns "
          item = model.find(:first)
          if item.nil?
            emptytables << model
            print "\t is empty"
          else
            print "\t starts at #{item.id}"
          end
          print "\n"
        else
          errors << model
          print '[Failed] has no database table !'
        end
        
     rescue Exception => ex
        print "[Failed] Exception on #{model}: #{ex.message}"
        errors << "#{model} error #{ex.message}"
      end
    end
    puts ''
    unless errors.empty? 
      puts "ERRORS encountered #{errors.join(", ")} do not have tables in the database!!"
    else
      puts "Models check passed OK "
      puts "#{emptytables.join(", ") } have no data in them yet"
    end 
  end 
  task :check=>[:check_gems,:check_network, :check_models]
end
