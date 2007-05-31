require 'fileutils.rb'

puts "Copying file 'dtcontrols.js' to 'public/javascripts directory'..."
FileUtils.copy(File.join(File.dirname(__FILE__), 'lib', 'javascripts', 'dtcontrols.js'),
File.join(File.dirname(__FILE__), '..', '..', '..', 'public', 'javascripts'))

puts IO.read(File.join(File.dirname(__FILE__), 'README' ))
