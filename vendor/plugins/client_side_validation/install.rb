# Install hook code here

require 'fileutils'

here = File.dirname(__FILE__)

FileUtils.cp("#{here}/javascripts/validator.js", "#{RAILS_ROOT}/public/javascripts/")
FileUtils.cp("#{here}/javascripts/validators-en.js", "#{RAILS_ROOT}/public/javascripts/")
