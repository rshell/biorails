# Workaround a problem with script/plugin and http-based repos.
# See http://dev.rubyonrails.org/ticket/8189
require "fileutils"

Dir.chdir(Dir.getwd.sub(/vendor.*/, '')) do

  FileUtils.copy( "db/schema.rb", "db/definition.rb" )

end