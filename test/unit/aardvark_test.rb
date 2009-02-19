require File.dirname(__FILE__) + '/../test_helper'

# The weird name is to make it run first, before other tests

class AardvarkTest < BiorailsTestCase
  def setup
     @@logger=Logger.new(STDOUT)
     @required=[]
     dir= Dir.open(File.dirname(__FILE__) + "/../../app")
     search(dir)
   end
   
  # This will fail unless run via rake. That is expected behaviour.
  def test_should_raise_exception_on_console_output
   # assert_raises(OutputNotAllowed) { puts 'x' }
  #  assert_raises(OutputNotAllowed) { print 'x' }
  #  assert_raises(OutputNotAllowed) { p 'x' }
  end
  
 def test_dev_server_is_running
  api = ActionWebService::Client::Soap.new(BiorailsApi,"http://127.0.0.1:3000/biorails/api")    
begin
  key = api.login('rshell','y90125') 
rescue Exception=>e
 @@logger.warn 'WARNING: The biorails server does not appear to be running. Web services tests expect the development server to be up and running on http://127.0.0.1:3000.  Other tests should still pass'
end
end
  #
  ## This test simply goes through all the controllers and views and uses a regex to match the
  ## required gems and plugins.  It then tries to load them, and records any exceptions
  ##
  def test_dependencies
    @required.each do |req|
      assert_nothing_raised(){ "require "+req } 
    end
  end
  
  private 
  def search(dir)
   dir.each {|file|
     unless file.match(/^\./)
       if File.directory?(dir.path+File::SEPARATOR+file)
         search(Dir.open(dir.path+File::SEPARATOR+file))
       else
         File.open(dir.path+File::SEPARATOR+file,"r") do |f|
           while line=f.gets
             if line.match(/require '(.+)'/)
               @required << ($1)
             elsif line.match(/def\s/)
               break
             end
           end
         end
       end
     end
     }
  end
end