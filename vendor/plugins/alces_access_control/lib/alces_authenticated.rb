##
#This is setup for the  acts_as_authenticated method
#
# class User < ActiveRecord::Base
#   acts_as_authenticated
# end
#
# Generates:-
#
#  * username
#  * username=
#  * password
#  * set_password( new_password )
#  * authenticate( username, password )
#  * password?(value)
#  * signature( data_block )
#  * check_signature( data_block, hash )
#  
#
module Alces
  module AccessControl
    module AuthenticationModel

      def self.included(base)
        base.extend(ClassMethods)
      end
        
##------------------------------------------------------------------------------------------------------------------------------      
      module ClassMethods
##
# Add authonrization meth to model class
#      
        def access_authenticated(options = {})
          write_inheritable_attribute(:acts_as_authenticated_options, {:username =>  options[:username] || "username",
                                                                       :password => options[:password] || "password_hash",
                                                                       :password_salt => options[:password_salt] || "password_salt"})
          class_inheritable_reader :acts_as_authenticated_options
          include Alces::AccessControl::AuthenticationModel::InstanceMethods
          extend  Alces::AccessControl::AuthenticationModel::SingletonMethods
        end
      end

##------------------------------------------------------------------------------------------------------------------------------      
##
# User Password Verification Methods
#       
      module SingletonMethods
##
# get the user for a username
#       
        def for_username(username)
           user = find(:first, :conditions => ["#{acts_as_authenticated_options[:username]}=?", username])
           logger.info "User #{user.name} found..."  
           return user        
        end
##
# authenticate a user and return the user object or nil if is unknown
#        
        def authenticate(username, password)
          user =  for_username(username)
          if user and user.password?(password)
              logger.info "User #{user.name} authenticate..."    
              return user
          else    
              logger.info "User #{user.name} not authenticate..."    
          end
          return nil
        end
      end

##--------------------------------------------------------Acts----------------------------------------------------------------------      
      module InstanceMethods
        ##
        # reset the password
        #
        def set_password(value)
          @attributes[acts_as_authenticated_options[:password].to_s] = self.encrypt(value)
        end
        ##
        # test if the password is correct
        #  
        def password?(value)
          (self.password_hash ==  encrypt(value|| ""))
        end
        ##
        # get the username 
        # 
        def username
          @attributes[acts_as_authenticated_options[:username].to_s]
        end 
        ##
        # set the username 
        #
        def username=(value)
          @attributes[acts_as_authenticated_options[:username].to_s] = value
        end 
        ##
        # sign a block of data
        #
        def signature(block)
          Digest::SHA1.hexdigest("--#{block}--#{self.id}--#{self.password_salt}--")        
        end
        ##
        # check in the block is signed correctly
        #
        def check_signature(block,signature_hash)
          return ( signature_hash == Digest::SHA1.hexdigest("--#{block}--#{self.id}--#{self.password_salt}--")  )      
        end
        ##
        # get a password salt
        #        
        def generate_salt
           password_salt = Digest::SHA1.hexdigest("--#{Time.now.to_s.split(//).sort_by {rand}.join}--#{self.username}--")
        end
        
        def password_salt=(value)
            @attributes[acts_as_authenticated_options[:password_salt]] = value
        end
        
        def password_salt
            @attributes[acts_as_authenticated_options[:password_salt]]
        end
        
    	##           
        # Encrypts the password with the user salt
        # 
        def encrypt(value)
          generate_salt if password_salt.nil? 
          Digest::SHA1.hexdigest("--#{self.password_salt}--#{value}--")
        end
        
      end
    end
  end
end