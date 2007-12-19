require 'ntp'
require 'digest/md5'
require 'openssl'
require 'base64'
#require 'digest/sha2'
# :content_hash, :string #a hash of the content that has been signed
 # :signer, :integer #foreign key to user
 # :public_key, :string #public key of signer
 # :signature_format , :string #sha1, sha512
 # :signature_role, :string #author, witness
 # :signature_state, :string  #pending, signed, abandoned
 # :reason, :string  #why a sig was abandoned - reassigned, declined
 # :requested_date, :datetime
 # :signed_date, :
 
class Signature < ActiveRecord::Base
  belongs_to :project_element
  belongs_to :asset
  belongs_to :user
  belongs_to :article
############################################################################
#       CLASS METHOD TO GET TIME FROM REMOTE TIME SERVER
#        (has to come before the defaults are set up)
############################################################################
  def self.set_signature_time
     ntp=NET::NTP.get_ntp_response
     return Time.at(ntp['Originate Timestamp']).utc
   end
 
  defaults :signature_format=>SystemSettings.get('hash_format').text, :signed_date=> set_signature_time
  Statuses= %w{PENDING, SIGNED, ABANDONED}
  SignatureRoles=%w{AUTHOR, WITNESS}
  SignatureFormats=%w{SHA1, SHA512, MD5}
  
    validates_inclusion_of :signature_state,  :in => Statuses
    validates_inclusion_of :signature_role,   :in => SignatureRoles
    validates_inclusion_of :signature_format, :in => SignatureFormats
  
 ###########################################################################
 #      INSTANCE METHODS
 #
 ###########################################################################
  def before_save
    pub_key=OpenSSL::PKey::RSA.new(public_key)
    content_hash=Base64.encode64(public_key.public_encrypt(text_to_sign))
  end
  def text_to_sign
    signed_text=[]
    signed_text << generate_checksum
    signed_text << asserted_text
    signed_text << signed_date
    signed_text << get_previous_signature
    signed_text.collect{|i| i.to_s}.join(',')   
  end
  
  def get_latest_signature
    Signature.find(:all, :order=>'id desc', :limit=>1)
  end
  
  def get_previous_signature
    last_two_sigs=Signature.find(:all, :order=>'id desc', :limit=>2)
    if last_two_sigs.size == 2
      return last_two_sigs[1] 
    else
      return 'First Signature'
    end
  end
  
  def generate_checksum  
      filename = self.asset.filename ||=''
      title=self.asset.title ||=''
      created=self.asset.created_at.to_s
      data = 'file:' << filename << '~~'<< title << '~~' << created
    begin
      case self.signature_format
        when 'SHA512'
          begin
          OpenSSL::Digest::SHA512.new
          return OpenSSL::Digest::SHA512.hexdigest(data)
        rescue
          return false
        end
        when 'SHA1'
          return OpenSSL::Digest::SHA1.hexdigest(data)
        when 'MD5'
          return Digest::MD5.hexdigest(data)
        end 
    rescue Exception => e
      p e.message
      return nil
    end
  end  
end

 
