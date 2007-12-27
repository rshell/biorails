require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'
require 'ntp'
require 'author_signature'
class SignatureTest < Test::Unit::TestCase
  
  ## TODO - LOOK AT WHY NTP CALLED WHEN NO NETWORK AND TESTS FAIL
  #fixtures :signatures
  def test_that_signature_is_created
    sig=Signature.new
    assert_not_nil sig
  end
  def test_create_signature_should_set_up_defaults
    
    sig=Signature.new(:signed_date=>Time.parse('Wed Dec 12 19:25:02 UTC 2007'))
    assert_equal 'MD5', sig.signature_format
    assert_equal 'Wed Dec 12 19:25:02 UTC 2007', sig.signed_date.to_s
  end
  def test_author_signature_should_have_author_role
    sig=AuthorSignature.new
    assert_equal 'AUTHOR', sig.signature_role
    assert_equal 'I assert that the document below is my work and affirm this by attaching my electronic signature', sig.asserted_text
  end
  def test_witness_signature_should_have_witness_role
    sig=WitnessSignature.new
    assert_equal 'WITNESS',sig.signature_role
    assert_equal 'I witness that the document below is the work of the signing author(s) and  affirm this by attaching my electronic signature', sig.asserted_text
  end

  def test_invalid_with_wrong_attributes
    sig=AuthorSignature.new
    sig.asset=Asset.new
    sig.signature_state="SOMETHING"
    sig.signature_format="SOMETHING"
    sig.signature_role="SOMETHING"
    assert !sig.valid?
    assert_equal 'is not included in the list',sig.errors[:signature_role]
    assert_equal 'is not included in the list',sig.errors[:signature_format]
    assert_equal 'is not included in the list',sig.errors[:signature_state]
  end
  
  def test_signature_time_should_be_based_on_utc_time_from_ntp_server
    NET::NTP.expects(:get_ntp_response).returns({'Originate Timestamp'=>1197487502.17188})    
    assert_equal 'Wed Dec 12 19:25:02 UTC 2007', Signature.set_signature_time.to_s
  end
  
  def test_signed_text_should_be_as_expected
    sig=AuthorSignature.new(:signed_date=>Time.parse('Wed Dec 12 19:25:02 UTC 2007'))
    sig.asset=Asset.new
    sig.asset.filename ='none'
    assert_equal "3f8694003becf8eb45141de04a876e19,I assert that the document below is my work and affirm this by attaching my electronic signature,Wed Dec 12 19:25:02 UTC 2007,First Signature", sig.text_to_sign
  end
  
  def test_should_generate_hash_when_signature_has_asset
     puts 'using open SSL version ', OpenSSL::OPENSSL_VERSION
    sig=Signature.new
    sig.signature_format='MD5'
    sig.asset = Asset.new
    sig.asset.title="tests"
    sig.asset.filename="myfile"
    sig.asset.created_at= Time.parse('Wed Dec 12 19:25:02 UTC 2007')
     assert_equal '05554be36b14d030b11272ddb9754a8f',sig.generate_checksum   
      sig.signature_format='SHA1'
       assert_equal '980112ae2620f069edda5a4733c2cdc41603c309', sig.generate_checksum
       sig.signature_format='MD5'
       assert_equal '05554be36b14d030b11272ddb9754a8f', sig.generate_checksum
       #cant get this to work on my machine - need at least openssl 0.9.8 I think
       sig.signature_format='SHA512'
       begin
         #do not test SHA512 if the system doesn't have it installed
         OpenSSL::Digest::SHA512.new #will throw error if no SHA512 digest available
         assert_equal '2a726b171e5dab70e2fc0190261e7b6838972064', sig.generate_checksum
         p 'tested sha512'
       rescue
         assert !sig.generate_checksum
         p 'SHA512 not present'
       end
  end
end
