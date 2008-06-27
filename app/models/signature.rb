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
# Copyright © 2006 Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class Signature < ActiveRecord::Base

  validates_associated  :project_element
  validates_presence_of :project_element_id
  validates_presence_of :filename
  validates_presence_of :asserted_text
  validates_presence_of :user_id


  belongs_to :project_element

  belongs_to :creator, :class_name=>"User", :foreign_key=>"created_by_user_id"

  belongs_to :signer, :class_name=>"User", :foreign_key=>"user_id"
  
     
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

 
