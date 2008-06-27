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

desc 'Continuous build target'
task :cruise do
    out = ENV['CC_BUILD_ARTIFACTS']
    mkdir_p out unless File.directory? out if out
    task = Rake::Task['asset:packager:build_all'].invoke
    ENV['SHOW_ONLY'] = 'models,lib,helpers,controllers'
    task = Rake::Task["test:biorails:rcov"].invoke
    mv 'coverage/biorails', "#{out}/biorails test coverage" if out  
    task
end