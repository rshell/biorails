require 'ntp'
require 'digest/md5'
#require 'digest/sha2'
# :content_hash, :string #a hash of the content that has been signed
 # :signer, :integer #foreign key to user
 # :public_key, :string #public key of signer
 # :signature_format , :string #sha1, sha512
 # :signature_role, :string #author, witness
 # :signature_state, :string  #pending, signed, abandoned
 # :reason, :string  #why a sig was abandoned - reassigned, declined
 # :requested_date, :datetime
 # :signed_date, :datetime
class Signature < ActiveRecord::Base
  belongs_to :project_element
  belongs_to :asset
  belongs_to :user
  belongs_to :article

  
  Statuses= %w{PENDING, SIGNED, ABANDONED}
  SignatureRoles=%w{AUTHOR, WITNESS}
  SignatureFormats=%w{SHA1, SHA512, MD5}
  
  validates_inclusion_of :signature_state,  :in => Statuses
  validates_inclusion_of :signature_role,   :in => SignatureRoles
  validates_inclusion_of :signature_format, :in => SignatureFormats
  
  def generate_signature(affirmed_wording)
    signed_text=[]
    signed_text << generate_checksum
    signed_text << affirmed_wording
    signed_text << signature_time
    signed_text << get_previous_signature
    digest=signed_text.collect{|i| i.to_s}.join(',')
    return self.signature(digest)
  end
  
  def set_signature_time
    ntp=NET::NTP.get_ntp_response
    return self.signed_date=Time.at(ntp['Originate Timestamp']).utc
  end
  
  def get_latest_signature
    Signature.find(:all, :order=>'id desc', :limit=>1)
  end
  
  def get_previous_signature
    last_two_sigs=Signature.find(:all, :order=>'id desc', :limit=>2)
    return last_two_sigs[1] if last_two_sigs.count == 2
  end
  
  
  
  
  
  def generate_checksum
    #content = File.open(filename)  
    
    begin
      case self.signature_format
        when 'SHA512'
          begin
          OpenSSL::Digest::SHA512.new
          return OpenSSL::Digest::SHA512.hexdigest(self.asset.to_s)
        rescue
          return false
        end
        when 'SHA1'
          return OpenSSL::Digest::SHA1.hexdigest(self.asset.to_s)
        when 'MD5'
          return Digest::MD5.hexdigest(self.asset.to_s)
        end 
    rescue
      return nil
    end
  end  
end
