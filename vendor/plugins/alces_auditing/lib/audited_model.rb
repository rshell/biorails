##
# Copyright © 2006 Alces Ltd All Rights Reserved
# Author: Robert Shell
# See license agreement for additional rights
##
#
#
#
module Alces
    # This implements auditing with a model table to fill audits
    #
    #   class User < ActiveRecord::Base
    #     acts_as_audited
    #   end
    #
    # Its is expecting the following fields in the class for local audit information
    # 
    #  t.column "lock_version", :integer, :default => 0, :null => false
    #  t.column "created_by_user_id", :integer, :default => 1, :null => false
    #  t.column "created_at", :datetime, :null => false
    #  t.column "updated_by_user_id", :integer, :default => 1, :null => false
    #  t.column "updated_at", :datetime, :null => false
    # 
    # 
    module AuditedModel #:nodoc:

      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        # == Configuration options
        #
        # * <tt>except</tt> - Excludes fields from being saved in the audit log.
        #   By default, acts_as_audited will audit all but these fields: 
        # 
        #     [self.primary_key, inheritance_column, 'lock_version', 'created_at', 'updated_at']
        #
        #   You can add to those by passing one or an array of fields to skip.
        #
        #     class User < ActiveRecord::Base
        #       acts_as_audited :except => :password
        #     end
        # 
        def acts_as_audited(audit_collection = :audits, options = {})
          # don't allow multiple calls
          return if self.included_modules.include?(Alces::AuditedModel::InstanceMethods)
          include Alces::AuditedModel::InstanceMethods         
          class_eval do
            extend Alces::AuditedModel::SingletonMethods

            write_inheritable_attribute(:auditing_enabled,  options[:auditing_enabled] || true )
            class_inheritable_reader :auditing_enabled
 
            write_inheritable_attribute(:auditing_collection_name,  audit_collection || :audits )
            class_inheritable_reader :auditing_collection_name
 
            belongs_to :created_by_user, :class_name=>'User', :foreign_key => 'created_by_user_id'
            belongs_to :updated_by_user, :class_name=>'User', :foreign_key => 'updated_by_user_id'

            has_many audit_collection ,{
            :class_name => 'Audit',    :as => :auditable, :order =>'id desc'}.merge(options)
            
            ##
            # add reference to say this is a audited model to the Audit class 
            # 
            Audit.audited_classes << self unless Audit.audited_classes.include?(self)

            ##
            #
            before_create :audit_populate_on_create
            before_update :audit_populate_on_update
            after_create  :audit_create
            after_update  :audit_update
            after_destroy :audit_destroy
            after_save    :clear_changed_attributes

          end
        end
      end
    
#######################################################################################
# Add to model Instance
# 
      module InstanceMethods
      
          ##
          # helper to simply get a user.name
          # 
          def created_by
            self.created_by_user.name
          end
          ##
          # helper to simply get a user.name
          # 
          def updated_by
            self.updated_by_user.name  
          end
          ##
          # Output a summary of audit status of the the object
          #
          def audit_summary
             out = " created by "
             out << created_by
             out << " on "
             out << created_at.strftime("%d-%m-%Y %H:%M")
             out << " last changed by "
             out << updated_by
             out << " on "
             out << updated_at.strftime("%d-%m-%Y %H:%M")
             out << " with "
             out << audits.size
             out << " changed logged"
             out.to_s
          end
          
          # Temporarily turns off auditing while saving.
          def save_without_auditing
            without_auditing { save }
          end
          
          # Executes the block with the auditing callbacks disabled.
          #
          #   @foo.without_auditing do
          #     @foo.save
          #   end
          #
          def without_auditing(&block)
            self.class.without_auditing(&block)
          end

          # If called with no parameters, gets whether the current model has changed.
          # If called with a single parameter, gets whether the parameter has changed.
          def changed?(attr_name = nil)
            @changed_attributes ||= {}
            attr_name ? @changed_attributes.include?(attr_name.to_s) : !@changed_attributes.empty?
          end
  

      private
        
          ##
          # fill in user information
          # 
          def audit_populate_on_create
            self.created_by_user_id = User.current.id 
            self.updated_by_user_id = User.current.id 
          end
          ##
          # fill in user information
          # 
          def audit_populate_on_update
            self.updated_by_user_id = User.current.id
          end
          
          # Creates a new record in the audits table if applicable
          def audit_create
            write_audit(:create)
          end
  
          def audit_update
            write_audit(:update) if changed?
          end
  
          def audit_destroy
 #            write_audit(:destroy)            
          end
        
          def write_audit(action = :update)
            if self.auditing_enabled 
              self.send(self.auditing_collection_name).create :changes => @changed_attributes, :action => action.to_s, :user_id => User.current.id
            end
          end


          # clears current changed attributes.  Called after save.
          def clear_changed_attributes
            @changed_attributes = {}
          end
          
          # overload write_attribute to save changes to audited attributes
          # 
          def write_attribute(attr_name, attr_value)
            attr_name = attr_name.to_s
            @changed_attributes ||= {}
            # get original value
            old_value = @changed_attributes[attr_name] ? @changed_attributes[attr_name].first : self[attr_name]
            super(attr_name, attr_value)
            new_value = self[attr_name]            
            @changed_attributes[attr_name] = [old_value, new_value] if new_value != old_value
          end

      end # InstanceMethods
      
#######################################################################################
# Add to model class
# 
      module SingletonMethods
          # Executes the block with the auditing callbacks disabled.
          #
          #   Foo.without_auditing do
          #     @foo.save
          #   end
          #
          def without_auditing(&block)
            auditing_was_enabled = auditing_enabled
            returning(block.call) { enable_auditing if auditing_was_enabled }
          end

      end # module SingletonMethods
      
    end
end
