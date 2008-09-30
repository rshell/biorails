require 'rake/gempackagetask'

namespace :biorails do
  namespace :freeze do
    
    desc "Freeze third-party gems to 'vendor'"
    task :gems => :environment do
      gems = ENV['GEMS'] || 'activerecord-oracle-adapter crypt htmldoc icalendar mongrel mongrel_cluster  mongrel_status ntp mini_magick tzinfo uuid fastercsv builder'
      puts "Freezing #{gems}..."

      libraries = gems.split
      require 'rubygems'
      require 'find'
      require 'fileutils'
    
      libraries.each do |library|
        begin
          library_gem = Gem.cache.search(library).sort_by { |g| g.version }.last
          puts "Freezing #{library} for #{library_gem.version}..."
    
          # TODO Add dependencies to list of libraries to freeze
          #library_gem.dependencies.each { |g| libraries << g  }
        
          folder_for_library = File.join("vendor", "#{library_gem.name}-#{library_gem.version}")
          system "cd vendor; gem unpack -v '#{library_gem.version}' #{library_gem.name};"
    
          # Copy files recursively to vendor so .svn folders are maintained
          Find.find(folder_for_library) do |original_file|
            destination_file = "./vendor/#{library}/" + original_file.gsub(folder_for_library, '')
          
            if File.directory?(original_file)
              if !File.exist?(destination_file)
                Dir.mkdir destination_file
              end
            else
              cp(original_file, destination_file)
            end
          end
    
          rm_rf folder_for_library
        end
      end

    end
  end  
end

desc 'build gem'
task :build do
  PKG_VERSION = "3.0.0"
  PKG_NAME = "biorails"
  PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

  spec = Gem::Specification.new do |s|
    s.name = PKG_NAME
    s.version = PKG_VERSION
    s.summary = "biorails data managmenment application"
    s.description = "web based experiment data management"
    s.has_rdoc = false
    
    s.files = Dir.glob('**/*', File::FNM_DOTMATCH).reject do |f| 
       [ /\.$/, /config\/database.yml$/, /config\/database.yml-/, 
       /database\.sqlite/,
       /\.log$/, /^pkg/, /\.svn/, /^vendor\/rails/, /\~$/, 
       /\/\._/, /\/#/ ].any? {|regex| f =~ regex }
    end
    s.require_path = '.'
    s.author = "Robert Shell"
    s.email = "support@biorails.org"
    s.homepage = "http://www.biorails.com"  
    s.rubyforge_project = "biorails"
    s.platform = Gem::Platform::RUBY 
    s.executables = ['$APPNAME']
   
    s.add_dependency("rails", "= 2.0.2")
    s.add_dependency("crypt", ">= 1.2.0")
    s.add_dependency("builder", ">= 1.2.0")
    s.add_dependency("json", ">= 1.2.0")
    s.add_dependency("mime-types ", ">= 1.2.0")
    s.add_dependency("icalendar", ">= 1.2.0")
    s.add_dependency("tzinfo", ">= 1.2.0")
    s.add_dependency("ntp", ">= 1.2.0")
    s.add_dependency("sqlite3-ruby", ">= 1.2.0")
    s.add_dependency("ruby-net-ldap", ">= 1.2.0")
    s.add_dependency("rubyzip", ">= 1.2.0")
    #
    # Native builds
    #
    s.add_dependency("ferret", ">= 1.0")
    s.add_dependency("mongrel", ">= 1.0")
    s.add_dependency("mongrel_cluster", ">= 1.0")
    #
    # External apps
    #
    s.add_dependency("htmldoc", ">= 1.2.0")
    s.add_dependency("mini_magick", ">= 1.2.0")
    s.add_dependency("gnuplot", ">= 1.2.0")
    #
    # Development env
    #
    s.add_dependency("ZenTest", ">= 0.1.0")
    s.add_dependency("rspec", ">= 0.1.0")
    s.add_dependency("ruport", ">= 0.1.0")
    s.add_dependency("rails-app-installer", ">= 0.1.0")
  end
  
  Rake::GemPackageTask.new(spec) do |p|
    p.gem_spec = spec
    p.need_tar = false
    p.need_zip = false
  end 
  
end

desc 'release'
task :release do
# create installed directory structure  
  dist_dir  = "/opt/biorails/#{Biorails::Version::MAJOR}.#{Biorails::Version::MINOR}"
 system <<-SCRIPT 
  mkdir -p #{dist_dir}
  mkdir -p #{dist_dir}/bin
  mkdir -p #{dist_dir}/src
  mkdir -p #{dist_dir}/lib
SCRIPT

# copy current version
 system <<-SCRIPT 
  svn export --force .  #{tmp_dir}/site
SCRIPT

# Install application specific version of ruby
 system <<-SCRIPT 
  cd #{dist_dir}/src
  wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p22.tar.bz2 
  tar -xf ruby-1.8.7-p22.tar.bz2
  cd ruby-1.8.7-p22
  ./configure -prefix=#{dist_dir}
  make clean
  make DESTDIR=#{dist_dir}
  make install DESTDIR=#{dist_dir}
SCRIPT

end

desc 'Continuous build target'
task :cruise do
    out = ENV['CC_BUILD_ARTIFACTS']
    mkdir_p out unless File.directory? out if out
    task = Rake::Task['db:migrate'].invoke
    task = Rake::Task['asset:packager:build_all'].invoke
    ENV['SHOW_ONLY'] = 'models,lib,helpers,controllers'
    task = Rake::Task["test:biorails"].invoke
    #mv 'coverage/biorails', "#{out}/biorails test coverage" if out  
    Rake::Task["biorails:restart"].invoke
    task
end