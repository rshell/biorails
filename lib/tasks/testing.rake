namespace :test do
#
# Test of helpers has been separated from standard units as tedn to used
# routes ahd other controller released functions
#
desc 'Test Of Helpers'
Rake::TestTask.new(:helpers => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/helper/**/*_test.rb'
    t.verbose = true
end
Rake::Task['test:helpers'].comment = "Run the unit tests in test/helper"

desc 'Cleanup after tests'
task :cleanup => :environment do
      #
      # Clean out test data
      #
      FileUtils.rm_r(File.join(RAILS_ROOT,'public','test','*'),:force=>true)
      system("svn update #{File.join('public','test')}")
 end
#
# Run main internal test suite, units, helpers, and functions
#
desc 'Test all units helpers and controllers'
Rake::TestTask.new(:biorails => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/{helper,unit,functional}/**/*_test.rb'
    t.verbose = true
end
Rake::Task['test:biorails'].comment = "Run the unit,helper,controller tests "


end

namespace :biorails do
  namespace :qc do
  require 'erb'
  require 'open3'
  require 'yaml'

  task :check_syntax => [:check_ruby, :check_erb, :check_yaml]

  task :all => [:stats,:check_ruby, :check_erb, :check_yaml,:check_code_quality]

  desc ' Syntax check all the erb files in the installation '
  task :check_erb do
    puts "==========================================================="
    puts " Checking syntax of all erb templates"
    puts "=========================================================="
    (Dir["**/*.erb"] + Dir["**/*.rhtml"]).each do |file|
      next if file.match("vendor/rails")
      Open3.popen3('ruby -c') do |stdin, stdout, stderr|
        stdin.puts(ERB.new(File.read(file), nil, '-').src)
        stdin.close
        if error = ((stderr.readline rescue false))
          puts file + error[1..-1]
        end
        stdout.close rescue false
        stderr.close rescue false
      end
    end
    puts "Erb syntax Ok"
  end

  desc ' Syntax check all the ruby files in the installation '
  task :check_ruby do
    puts "==========================================================="
    puts " Checking syntax of rb files"
    puts "=========================================================="
    Dir['**/*.rb'].each do |file|
      next if file.match("vendor/rails")
      next if file.match("vendor/plugins/.*/generators/.*/templates")
      Open3.popen3("ruby -c #{file}") do |stdin, stdout, stderr|
        if error = ((stderr.readline rescue false))
          puts error
        end
        stdin.close rescue false
        stdout.close rescue false
        stderr.close rescue false
      end
    end
    puts "Ruby syntax Ok"
  end

  desc ' Syntax check all the yml files in the installation '
  task :check_yaml do
    puts "==========================================================="
    puts " Checking syntax of all yaml data files"
    puts "=========================================================="
    Dir['**/*.yml'].each do |file|
      next if file.match("vendor/rails")
      next if file.match("vendor/plugins/alces_scaffold/generators/alces_scaffold/templates/fixtures.yml")
      next if file.match("vendor/plugins/will_paginate/test/fixtures/users.yml")
      begin
        YAML.load_file(file)
      rescue => e
        puts "#{file}:#{(e.message.match(/on line (\d+)/)[1] + ':') rescue nil} #{e.message}"
      end
    end
    puts "Yaml syntax Ok"
  end

  desc "Check the quality of our /app code against some metrics (may be meanless)"
  task :check_code_quality  => :environment do
    puts "==========================================================="
    puts " Automated code quality report help find complex sections"
    puts "=========================================================="
    puts "Checking application code"
    puts "=========================================================="
    system "roodi -config=#{File.join(RAILS_ROOT,'config','roodi_rules.yml')} '#{File.join(RAILS_ROOT,'app','**','*.rb')}'"
    puts "Checking Library code"
    puts "=========================================================="
    system "roodi -config=#{File.join(RAILS_ROOT,'config','roodi_rules.yml')} '#{File.join(RAILS_ROOT,'lib','**','*.rb')}'"
    puts "=========================================================="
  end

  desc "Check the quality of our /app code against some metrics (may be meanless)"
  task :check_code_quality_plugins  => :environment do
    puts "==========================================================="
    puts " Automated code quality report help find complex sections"
    puts "=========================================================="
    puts "Checking Plugin code"
    puts "=========================================================="
    system "roodi -config=#{File.join(RAILS_ROOT,'config','roodi_rules.yml')} '#{File.join(RAILS_ROOT,'vendor','plugins','**','*.rb')}'"
    puts "=========================================================="
  end

  end
end
