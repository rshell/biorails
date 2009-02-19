ENV["RAILS_ENV"] = "test"

require 'rubygems'
require 'actionpack'
require 'activerecord'

require 'test/unit'
require '../lib/action_web_service'
require 'action_controller'
require 'action_controller/test_process'

# Show backtraces for deprecated behavior for quicker cleanup.
ActiveSupport::Deprecation.debug = true


ActionController::Base.logger = Logger.new("debug.log")
ActionController::Base.ignore_missing_templates = true

begin
  require "active_record/fixtures" 
rescue LoadError => e
  fail "\nFailed to load activerecord: #{e}"
end

ActiveRecord::Base.configurations = {
  'mysql' => {
    :adapter  => "mysql",
    :username => "root",
    :encoding => "utf8",
    :database => "actionwebservice_unittest"
  }
}

ActiveRecord::Base.establish_connection 'mysql'

# restore default raw_post functionality
class ActionController::TestRequest
  def raw_post
    super
  end
end
