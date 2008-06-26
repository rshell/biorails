# AlcesHasFolder
##
# Copyright © 2006 Alces Ltd All Rights Reserved
# Author: Robert Shell
# 
# See license agreement for additional rights
##
#
#
#
module Alces
    module ActsAsFolder #:nodoc:
      
      VERSION='0.1.0'


                      
      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods

    # == Configuration options
    # This implements use of the object as a scheduled item with status in most cases a simple
    #    
    #      has_priorities :priority_id, :allowed => { 0=> :low, 1=>:normal, 2 =>:high } 
    #
    #
    # Its is expecting the following fields in the class for local audit information
    # 
    # 
        def acts_as_folder( root, options={} )
          include Alces::ActsAsFolder::InstanceMethods         
          extend Alces::ActsAsFolder::SingletonMethods
          belongs_to root, options  
          
          write_inheritable_attribute(:root_folder,   root|| :project  )
          class_inheritable_reader :root_folder
          
        end
      end
#######################################################################################
# Add to model class
# 
      module SingletonMethods
      ##
      # Finder for visible versions of the model for the scope of the current user
      #
        def visible(*args)
          self.with_scope( :find => {
               :conditions=> ["exists (select 1 from memberships m where m.user_id=? and m.team_id=#{self.table_name}.team_id)",User.current.id]
              })  do
             self.find(*args)
          end
        end
        
      end # module SingletonMethods
      

#######################################################################################
# Add to model Instance
# 
      module InstanceMethods
      #
      # rename the experiment
      #
        def rename(new_name)
          folder = self.folder
          folder.name = new_name
          self.name = new_name     
        end
        #
        # Create folder for experiment in its project
        #
        def after_create
          self.folder
        end
        #
        # rename folder to match
        #
        def before_update
            ref = self.folder
            if ref.name !=self.name
              ref.name = self.name
              ref.save!
            end
        end
        #
        # delete the folder when deleting this model
        #
        def before_destroy
           item = self.folder
           item.destroy if item and !item.new_record?
        end

        #
        # Get the folder for this object
        #
          def folder(item=nil)            
            folder = self.send(self.class.root_folder).folder(self)
            case item
            when ActiveRecord::Base
              return folder.folder(item) unless item.new_record?              
            when String  
              return folder.folder(item)
            else
              return folder
            end
            return nil
          end  

  
      end    
    end
end


