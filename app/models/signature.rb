# == Schema Information
# Schema version: 306
#
# Table name: signatures
#
#  id                 :integer(11)   not null, primary key
#  user_id            :integer(11)   
#  public_key         :string(2048)  
#  signature_format   :string(255)   
#  signature_role     :string(255)   
#  signature_state    :string(255)   
#  reason             :string(255)   
#  requested_date     :datetime      
#  signed_date        :datetime      
#  project_element_id :integer(11)   
#  asserted_text      :string(255)   
#  filename           :string(255)   
#  title              :string(255)   
#  comments           :string(255)   
#  time_source        :integer(11)   
#  created_at         :datetime      
#  created_by_user_id :integer(38)   
#  updated_at         :datetime      
#  updated_by_user_id :integer(38)   
#  content_hash       :string(2048)  
#
#
##http://www.biorails.org/lundbeck/ticket/210
# Copyright © 2006 Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

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

  validates_associated  :project_element
  validates_presence_of :project_element_id
  validates_presence_of :filename
  validates_presence_of :asserted_text
  validates_presence_of :user_id

  
  REMOTE_TIME_SERVER=0 unless defined?(REMOTE_TIME_SERVER) 
  SERVER_CLOCK=1 unless defined?(SERVER_CLOCK) 
  $BUFLEN=1024 
  @@time_source = -1

  belongs_to :project_element

  belongs_to :creator, :class_name=>"User", :foreign_key=>"created_by_user_id"

  belongs_to :signer, :class_name=>"User", :foreign_key=>"user_id"
  
############################################################################
#       CLASS METHOD TO GET TIME FROM REMOTE TIME SERVER
#        (has to come before the defaults are set up)
############################################################################
 
  #find all witness signatures this user was asked to sign
  def self.find_published_for_project(project_id,count=100)
    find(:all,
      :include=>[:project_element],
      :order=>"signatures.signed_date desc",
      :conditions=>{"project_elements.project_id"=>project_id,
                    :signature_role=>'WITNESS',
                    :signature_state=>'SIGNED'},
      :limit=>count)   
  end

  def self.find_signed_for_project(project_id,count=100)
    find(:all,
      :include=>[:project_element],
      :order=>"signatures.signed_date desc",
      :conditions=>{"project_elements.project_id"=>project_id,
                    :signature_role=>'AUTHOR',
                    :signature_state=>'SIGNED'},
      :limit=>count)   
  end
  
    
  def self.find_witness_by(user_id,count=100)
    find(:all,
          :include=>[:project_element],
          :order=>"project_elements.project_id,project_elements.left_limit,signatures.signed_date",
          :conditions=>{:signature_role=>'WITNESS',:user_id=>user_id},
          :limit=>count)   
  end

  #find all author signatures this user created
  def self.find_authored_by(user_id,count=100)
    find(:all,
         :include=>[:project_element],
         :order=>"project_elements.project_id,project_elements.left_limit,signatures.signed_date",
         :conditions=>{:signature_role=>'AUTHOR',:user_id=>user_id},
         :limit=>count)   
  end

  #find all witness signatures pending by this user
  def self.find_pending_witness_by(user_id,count=100)
    find(:all,
        :include=>[:project_element],
        :order=>"project_elements.project_id,project_elements.left_limit,signatures.signed_date",
        :conditions=>{:signature_role=>'WITNESS', :signature_state=>'PENDING',:user_id=>user_id},
        :limit=>count)    
  end
  #find all witness signatures pending for this user
  def self.find_pending_witness_for(user_id,count=100)
    find(:all,
        :include=>[:project_element],
        :order=>"project_elements.project_id,project_elements.left_limit,signatures.signed_date",
        :conditions=>{:signature_role=>'WITNESS', :signature_state=>'PENDING',:created_by_user_id=>user_id},
        :limit=>count)    
  end


  #
  # Get correct network time 
  #
  def self.set_signature_time
    begin
      ntp_server = SystemSetting.ntp_server
      unless ntp_server.nil? || ntp_server == 'localhost' || @@time_source == SERVER_CLOCK

        logger.debug "Lookup NTP server: #{ntp_server}"
        response = NET::NTP.get_ntp_response(ntp_server,"ntp")

        @@time_source=REMOTE_TIME_SERVER
        return Time.at( response['Originate Timestamp']).utc
      end
    rescue Timeout::Error => e
      logger.error 'WARNING: NTP clock signal lost swapped to server clook'
    rescue SocketError => e
      logger.error 'WARNING: NTP server is off line'
    end  
    @@time_source= SERVER_CLOCK
    return Time.now.utc
  end
  
   ############################################################################
   #       CLASS METHOD TO GENERATE CHECKSUM 
   #       (also used to generate checksum for contents and elements - so better as a class method )
   ############################################################################
  def self.hashfunc
    case SystemSetting.hash_format
       when 'SHA512' then  return OpenSSL::Digest::SHA512.new
       when 'SHA1' then    return OpenSSL::Digest::SHA1.new
       when 'MD5'  then    return OpenSSL::Digest::MD5.new
       end 
   rescue Exception => e
     logger.warn "Missing the correct Hash generator #{SystemSetting.hash_format}"
     logger.warn e.message
     return nil
  end
  
  def self.generate_checksum(data)
    case SystemSetting.get("hash_format").value
       when 'SHA512' then   return Digest::SHA512.hexdigest(data)
       when 'SHA1' then     return Digest::SHA1.hexdigest(data)
       when 'MD5' then      return Digest::MD5.hexdigest(data)
    end 
   rescue Exception => e
     logger.warn e.message
     return nil
   end
  
   def self.get_latest_signature
     find(:first, :order=>'id desc')
   end
   
   #this method tells the tests whether the ntp server is accessible, and so avoids
    #testing the ntp server when the machine is offline
    def self.time_source
       return @@time_source
    end
     
  validates_inclusion_of :signature_state,  
                        :in =>%w( PENDING SIGNED ABANDONED REFUSED ),
                         :message =>'Invalid signature status'
  validates_inclusion_of :signature_role,   
                         :in => %w( AUTHOR WITNESS ),
                         :message =>'Invalid signature role '
  validates_inclusion_of :signature_format, 
                         :in => %w( SHA1 SHA512 MD5 ),
                         :message =>'Invalid signature format hash function '

 ###########################################################################
 #      INSTANCE METHODS
 #
 ###########################################################################
 
  
  def before_create
    #create_content_hash(text_to_sign) #this was the original method - now deprecated
    self.sign_the_digest
  end
  
  def sign_the_digest(text=text_to_sign)
    self.content_hash=Base64.encode64(get_private_key.sign(Signature.hashfunc,  text ))
  end
  
  def verify_the_digest(text=text_to_sign)
    unless text.nil?
       get_public_key.verify(Signature.hashfunc,Base64.decode64(content_hash), text)
    else
       nil
    end
  end
  
  def get_private_key
    return User.find(user_id).private_key
  end
  
  def get_public_key
    return User.find(user_id).public_key
  end
  
  def create_content_hash(text=text_to_sign)
    self.content_hash=Base64.encode64(get_private_key.private_encrypt(text))
  end
  
  #use the public key to decode the content hash - this will be used to
  #check the signature has been generated by the person
  def decode_content_hash
    public_key=User.find(user_id).public_key
    public_key.public_decrypt(Base64.decode64(content_hash))
  end
  #
  # full os file path
  #
  def file_full_path
    File.join(project_element.folder_filepath,self.filename)
  end
  #
  # file url for use in web links
  # 
  def file_url
    File.join("",SystemSetting.published_folder,project_element.project.dom_id,self.filename)
  end

  def zip_url
    File.join("",SystemSetting.published_folder,project_element.project.dom_id,self.filename)
  end
  
  def create_sig
    sig_file=File.open(File.join(self.file_full_path+"#{self.signature_role.downcase}_signature.xml"),"w")
    sig_file.write(self.to_xml())
    sig_file.close
    save!
    return self.id
  end
  #
  # Initialize option with changable defaults 
  #
  def initialize(options={})
      super( { :signature_format=>SystemSetting.hash_format, 
               :signed_date=> Signature.set_signature_time, 
               :time_source=>@@time_source}.merge(options))         
  end
  #
  # Initialize option with fixed defaults for author
  #
  def self.new_author(options={})
      Signature.new( options.merge({ :signature_role=> 'AUTHOR', 
                                     :asserted_text=>SystemSetting.author_assert_text}))

  end
  #
  # Initialize option with fixed defaults  for witness
  #
  def self.new_witness(options={})
      Signature.new(options.merge({ :signature_role=> 'WITNESS', 
                                    :asserted_text=>SystemSetting.witness_assert_text}))

  end
  #
  # Create a witness request had send it out
  #
  def witness_by_request( user)
    sign = Signature.new_witness(
                       :public_key=>User.current.public_key.export,
                       :signature_state=>"PENDING",
                       :user_id=>user.id, 
                       :created_by_user_id=>User.current.id,
                       :filename=>self.filename,
                       :project_element_id=>self.project_element_id)
    sign.create_sig
    begin  
       Notification.deliver_witness_request(signature) 
    rescue Exception => ex
       logger.warn "Cant currently Send Email out for #{self.dom_id}"
       logger.debug ex.backtrace.join("\n")  
    end  
      return sign      
   end
  #
  # Get a list of people who may act as witness of this signature
  #
   def allowed_witness_list
       User.find(:all,:conditions => ['email is not null and id !=?',self.created_by_user_id])
   end  
   #
   # requested request on this signature
   #
   def refused_request(reason)
     self.refused(reason)
     begin
        Notification.deliver_signature_refused(signature) 
     rescue Exception => ex
        logger.warn "Cant currently Send Email out for #{self.dom_id}"
        logger.debug ex.backtrace.join("\n")  
    end  
  end
  #
  # Change status to signed
  #
  def signed(comment)
      self.comments = comment
      self.signature_state='SIGNED'
      self.save    
  end
  #
  # Change status to refused
  #
  def refused(reason)
     self.reason=reason
     self.signature_state='REFUSED'
     self.save
  end 
  
  #
  # Abandon all signatures attached to this object
  #
  def abandon(reason)
    self.reason=reason
    self.save!
    self.related.each do |other|
      other.reason=reason
      other.signature_state='ABANDONED'
      other.save!
    end
  end
  #
  # Generate text string for signature process
  #
  def text_to_sign 
    filehash=read_file(File.join(RAILS_ROOT,"public",SystemSetting.published_folder,self.filename+".zip"))
    if filehash
      signed_text=[]
      signed_text << filehash
      signed_text << asserted_text
      signed_text << signed_date
      signed_text << get_previous_signature
      return signed_text.collect{|i| i.to_s}.join(',')   
    else
      return ''
    end
  end
  
  def get_previous_signature
    if new_record? && Signature.get_latest_signature
      return Signature.get_latest_signature.content_hash 
    else
      begin
          return Signature.find(id-1).content_hash
      rescue
        return 'First record'
      end
    end
  end
  
  # Compute hash code
 def read_file(filename)
  	  @hashfunc=Signature.hashfunc
  	  begin
  		open(filename, "r") do |io|
  			counter = 0
  			while (!io.eof)
  				readBuf = io.readpartial($BUFLEN)
  				putc '.' if ((counter+=1) % 3 == 0)
  				@hashfunc.update(readBuf)
  			end
  		end
  		return @hashfunc.hexdigest
		rescue		  
          logger.warn "#{self.dom_id} file is missing"
		  return nil
	  end
  	end
  #
  # Find signatures related to the same filename
  #
  def related(state=nil)
    if state
        Signature.find(:all, :conditions=>{:signature_state=>state,:filename=>self.filename})
    else
        Signature.find(:all, :conditions=>{:filename=>self.filename})
    end
  end
  #
  # Name of the signature
  #  
  def name
    self.project_element.name if self.project_element_id
  end
  #
  # Path for the signature
  #  
  def path
    self.project_element.path if self.project_element_id
  end
  #
  # Get the project this signature relates to
  #
  def project
    return self.project_element.project if self.project_element_id
    return Project.current
  end
  
  def to_xml(options = {})
        xml = Builder::XmlMarkup.new(:indent => 0)
        xml.signature do
          xml.tag!(:asserted_text, asserted_text)
          xml.tag!(:content_hash, content_hash)
          xml.tag!(:created_at, created_at)
          xml.tag!(:comments, comments)
          xml.tag!(:created_by_user_id, created_by_user_id)
          xml.tag!(:filename, filename)
          xml.tag!(:project_element_id, project_element_id)
          xml.tag!(:public_key, public_key)
          xml.tag!(:reason, reason)
          xml.tag!(:requested_date, requested_date)
          xml.tag!(:signature_format, signature_format)
          xml.tag!(:signature_role, signature_role)
          xml.tag!(:signature_state, signature_state)
          xml.tag!(:signed_date, signed_date)
          xml.tag!(:time_source, time_source)
          xml.tag!(:title, title)
          xml.tag!(:user_id, user_id)
          xml.tag!(:updated_at, updated_at)
          xml.tag!(:updated_by_user_id, updated_by_user_id)
        end
      end
  end

 
