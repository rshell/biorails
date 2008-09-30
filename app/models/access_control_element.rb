# == Schema Information
# Schema version: 359
#
# Table name: access_control_elements
#
#  id                     :integer(4)      not null, primary key
#  access_control_list_id :integer(4)
#  owner_id               :integer(4)
#  owner_type             :string(255)
#  role_id                :integer(4)
#

##
# == Description
#  Access Control Element representing a rule granting a owner a
#  role related to access to a entry.
#
# == Copyright
#
# Copyright � 2008 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#
class AccessControlElement < ActiveRecord::Base
  belongs_to :role
  belongs_to :access_control_list
  belongs_to :owner, :polymorphic => true

  validates_presence_of :access_control_list_id
  validates_presence_of :role_id
  validates_presence_of :owner_id
  validates_presence_of :owner_type 
  
  after_create :update_list_checksum
  
  def role_name
    self.role.name if role
  end
  
  def owner_name
    self.owner.to_s if owner
  end

  def to_s
    "#{owner_name} => #{role_name}"  
  end
  
  def breakdown
    case owner
    when User
      l("direct")
    when Team
      owner.memberships.collect{|member|
        member.user.name
        (member.owner? ? "<b>#{member.user.name}</b>" : "#{member.user.name}") 
      }.join(" , ")
    else
      l("custom")
    end
  end

protected  

  def update_list_checksum
    access_control_list.calculate_checksum if access_control_list
  end

end
