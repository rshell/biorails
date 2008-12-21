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

  desc 'Installation verification scripts'


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
    system('gem install mini_magick')
    #
    # Following build native libraries and can fail on some platforms
    #
    system('gem install mongrel ')
    system('gem install mongrel_cluster ')
    system('gem install mocha')
    system('gem install chronic')
    system('gem install roodi')

  end
  
  desc "Sync with subversion and restart server"
  task :sync => :environment do
    system('svn info')
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
  
  desc "Start Mongrel cluster  production server"
  task :start => :environment do
    puts "Package all css and javascript.."
    Rake::Task['asset:packager:build_all'].invoke
    system('mongrel_rails cluster::start')  
  end

  desc "Restart Mongrel cluster production server"
  task :restart => :environment do
    Rake::Task['asset:packager:build_all'].invoke
    system('mongrel_rails cluster::restart')  
  end

  desc "Stop Mongrel cluster production server"
  task :stop => :environment do
    system('mongrel_rails cluster::stop')  
  end
   
end
