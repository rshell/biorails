# == Schema Information
# Schema version: 123
#
# Table name: users
#
#  id            :integer(11)   not null, primary key
#  name          :string(255)   default(), not null
#  password      :string(40)    default(), not null
#  role_id       :integer(11)   not null
#  password_salt :string(255)   
#  fullname      :string(255)   
#  email         :string(255)   
#

require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  attr_accessor :clear_password
  attr_accessor :confirm_password

  def role
    if self.role_id
      @role ||= Role.find(self.role_id)
    end
    return @role
  end
    
  def before_save
    if self.clear_password  # Only update the password if it has been changed
      self.password_salt = self.object_id.to_s + rand.to_s
      self.password = Digest::SHA1.hexdigest(self.password_salt +
                                             self.clear_password)
    end
  end

  def after_save
    self.clear_password = nil
  end

  def check_password(clear_password)
    self.password == Digest::SHA1.hexdigest(self.password_salt.to_s +
                                                 clear_password)
  end
    
end
