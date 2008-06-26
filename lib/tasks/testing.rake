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

