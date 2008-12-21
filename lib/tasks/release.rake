require 'rake/gempackagetask'

namespace :biorails do
  namespace :release do
    
    desc "Freeze third-party gems to 'vendor'"
    task :gems => :environment do
      gems = ENV['GEMS'] || 'activerecord-biorails_oracle-adapter crypt htmldoc icalendar mongrel mongrel_cluster  mongrel_status ntp mini_magick tzinfo uuid fastercsv builder'
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




    desc 'Build tar of curent source'
    task :tar => :environment do
      system("svn info")
      version = ENV['CC_BUILD_REVISION']||Biorails::Version::STRING
      puts "Archiving #{Biorails::Version::TITLE} #{version}"
      #
      # create zip file
      #
      archive_filename = File.join("#{Biorails::Version::TITLE}-#{version}")
      system("svn export #{RAILS_ROOT} /tmp/#{archive_filename}")
      system("cp public/javascripts/base_* /tmp/#{archive_filename}/public/javascripts/ ")
      system("cp public/stylesheets/base_* /tmp/#{archive_filename}/public/stylesheets/ ")
      system("tar -czf #{archive_filename}.tar.gz /tmp/#{archive_filename} ")

      rm_r("/tmp/#{archive_filename}",:force=>true)
      puts "created #{archive_filename}.tar.gz file"
      out = ENV['CC_BUILD_ARTIFACTS']
      if out
        mv "#{archive_filename}.tar.gz","#{out}/#{archive_filename}.tar.gz"
        puts "moved to #{out}"
      end
    end




    desc 'build gem'
    task :build do
      version = ENV['CC_BUILD_REVISION']||Biorails::Version::STRING
      PKG_FILE_NAME = "#{Biorails::Version::TITLE}-#{version}"

      spec = Gem::Specification.new do |s|
        s.name = Biorails::Version::TITLE
        s.version = version
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
        s.add_dependency("mongrel", ">= 1.0")
        s.add_dependency("mongrel_cluster", ">= 1.0")
        #
        # External apps
        #
        s.add_dependency("htmldoc", ">= 1.2.0")
        s.add_dependency("mini_magick", ">= 1.2.0")
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

    desc 'create all uml diagrams'
    task :create_uml  => :environment do
      for model in Biorails::ALL_MODELS
        image_file =  Biorails::UmlModel.create_model_diagram(File.join(RAILS_ROOT, "public/images"),model,{})
        unless image_file.nil?
          puts "Graphviz create #{image_file}"
        end
      end
    end

    task :build_apis  => :environment do
      Biorails::ALL_MODELS.each do |model|
        puts "class #{model} < ActionWebService::Struct"
        model.columns.each do |column|
          puts "   member :#{column.name} , :#{canonical_type_name(column.type)}, #{column.null} "
        end
        puts "end"
        puts ""
      end
    end
   
    def canonical_type_name(name) # :nodoc:
      name = name.to_sym
      case name
      when :int, :integer, :fixnum, :bignum
        :int
      when :string, :text
        :string
      when :base64, :binary
        :base64
      when :bool, :boolean
        :bool
      when :float, :double
        :float
      when :time, :timestamp
        :time
      when :datetime
        :datetime
      when :date
        :date
      else
        raise(TypeError, "#{name} is not a valid base type")
      end
    end
    
  end
end
