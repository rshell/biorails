require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'
require 'signature'

class NotificationTest < Test::Unit::TestCase

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
    User.current = User.find(4)
    Project.current = Project.find(2)
    @signature=Signature.new(:user_id=>3)
    @signature.asserted_text='hello author'
    @signature.project_element = Project.current.home
    @signature.signed_date=Time.now
    @signature.creator = User.find(3)
    @signature.signer = User.find(4)
    @signature.signature_state="SIGNED"
    @signature.signature_role="AUTHOR"
    @signature.expects(:filename).at_least_once.returns("testzip")
    @signature.expects(:read_file).with(File.join(RAILS_ROOT,'public','test','testzip.zip')).returns("hello world")
    assert_nothing_raised(Exception){@signature.create_sig}
  end
  
  def test_setup_ok
    assert @signature.valid?
    assert  @signature.creator
    assert  @signature.signer
    assert  @signature.creator.email
    assert  @signature.signer.email
  end


  def test_signature_refused
    assert Notification.deliver_signature_refused(@signature)
  end
  
  def test_signature_refused
    assert Notification.deliver_excessive_login_failures(User.current)
  end
  

end
