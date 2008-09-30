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
    
    VERSION='0.2.0'
    
    
    
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end
    
    module ClassMethods
      #
      # This haves as a folder with a attached list of access_control_list
      #
      def acts_as_folder
        extend  Alces::ActsAsFolder::FolderClassMethods
        include Alces::ActsAsFolder::CommonInstanceMethods                 
      end
      # == Configuration options
      # This implements use of the object as a scheduled item with status in most cases a simple
      #    
      #     acts_as_folder_linked :project    
      #
      # Its is expecting the following fields in the class for local audit information
      # 
      def acts_as_folder_linked( root=nil, options={} )
        
        belongs_to :project_element

        if root
          include Alces::ActsAsFolder::ChildInstanceMethods   

          write_inheritable_attribute(:root_folder,   root  )
          write_inheritable_attribute(:root_folder_under, options[:under]  )
        else  
          include Alces::ActsAsFolder::RootInstanceMethods          

          write_inheritable_attribute(:root_folder,   nil  )
          write_inheritable_attribute(:root_folder_under, nil  )
        end

        extend  Alces::ActsAsFolder::LinkedClassMethods
        include Alces::ActsAsFolder::CommonInstanceMethods   

        class_inheritable_reader :root_folder
        class_inheritable_reader :root_folder_under
        #
        # Create folder for experiment in its project
        #
        after_create   :after_create_generate_folder
        before_update  :before_update_rename_folder
        before_destroy :before_destroy_delete_folder
       
      end
    end

    #######################################################################################
    # Methods when the class is a actual folder
    # 
    #######################################################################################
    module FolderClassMethods

      #
      # Filtered Find with only published, owned or accessable records returned
      #   * Is published
      #   * If current user is a member of the team owning the record
      #   * If current user was the last author of the object.
      #
      def find_visible(*args)
        if User.current.admin?
          return self.with_scope( :find => {:include=>[:access_control_list,:state]})  do
            self.find(*args)
          end
        end
        items = []
        acl_sql = <<-SQL
exists ( select 1 from access_control_elements 
  where access_control_elements.access_control_list_id = project_elements.access_control_list_id 
  and (access_control_elements.owner_type='User' and access_control_elements.owner_id = ?
   or (access_control_elements.owner_type='Team' and 
        exists (select 1 from memberships 
                where memberships.team_id=access_control_elements.owner_id 
                and memberships.user_id=? ))
    )) 
        SQL
        items << [acl_sql,[User.current.id,User.current.id]]
        items << ["#{State.table_name}.level_no  = ?",State::PUBLIC_LEVEL]
        items << ["#{self.table_name}.updated_by_user_id  = ?",User.current.id]
        items << ["#{self.table_name}.created_by_user_id  = ?",User.current.id]
        conditions = []
        values = []
        items.each do |item|
          conditions <<  item[0]
          values << item[1]
        end
        self.with_scope( :find => {:include=>[:access_control_list,:state],
            :conditions=> [conditions.join(" or "),values].flatten } )  do
          self.find(*args)
        end
      rescue Exception => ex
        logger.info "Failed to find object "+ex.message
        return nil
      end  
      
      #
      # search for items inside of the scope of the passed folder
      #
      def within_scope_of(folder)
        folder ||= self
        with_scope(:find =>{  :conditions=>
              ["(project_elements.left_limit > ?) and (project_elements.right_limit < ?) and project_elements.project_id= ?" ,
              folder.left_limit, folder.right_limit, folder.project_id]}) do
          yield
        end
      end
      #
      # search for items outside of the scope of the passed folder
      #
      def outside_scope_of(folder)
        folder ||= self
        with_scope(:find =>{  :conditions=> 
              ["not ((project_elements.left_limit > ?) and (project_elements.right_limit < ?) and project_elements.project_id= ?)" ,
              folder.left_limit, folder.right_limit, folder.project_id]}) do
          yield
        end    
      end
      #
      # Filtered Find with only published, owned or accessable records returned
      #   * Is published
      #   * If current user is a member of the team owning the record
      #   * If current user was the last author of the object.
      #
      def load(id)
        self.find_visible(id,:include=>[:access_control_list,:state])
      end
      #
      # List all the items in the current project of the type
      #
      def list(*args)
        self.find_visible(*args)
      end  

    end
    #######################################################################################
    # Add to model class
    # 
    #######################################################################################
    module LinkedClassMethods
      
      #
      # Filtered Find with only published, owned or accessable records returned
      #   * Is published
      #   * If current user is a member of the team owning the record
      #   * If current user was the last author of the object.
      #
      def find_visible(*args)
        if User.current.admin?
          return self.with_scope( :find => {:include=>[:project_element=>[:access_control_list,:state]]})  do
            self.find(*args)
          end
        end
        items = []
        acl_sql = <<-SQL
  exists (
    select 1 from access_control_elements
    where access_control_elements.access_control_list_id = project_elements.access_control_list_id
    and (access_control_elements.owner_type='User' and access_control_elements.owner_id = ?
         or (access_control_elements.owner_type='Team'
             and exists (select 1 from memberships
                  where memberships.team_id=access_control_elements.owner_id
                  and memberships.user_id=? )
            )
        )
    )
        SQL
        items << [acl_sql,[User.current.id,User.current.id]]
        items << ["#{State.table_name}.level_no  = ?",State::PUBLIC_LEVEL]
        items << ["#{self.table_name}.updated_by_user_id  = ?",User.current.id] if self.columns.any?{|c|c.name =='updated_by_user_id'}
        items << ["#{self.table_name}.assigned_to_user_id = ?",User.current.id] if self.columns.any?{|c|c.name =='assigned_to_user_id'}
        items << ["#{self.table_name}.created_by_user_id  = ?",User.current.id] if self.columns.any?{|c|c.name =='created_by_user_id'}
        conditions = []
        values = []
        items.each do |item|
          conditions <<  item[0]
          values << item[1]
        end
  
        self.with_scope( :find => {:include=>[:project_element=>[:access_control_list,:state]],
            :conditions=> [conditions.join(" or "),values].flatten } )  do
          self.find(*args)
        end
      rescue Exception => ex
        logger.info "Failed to find object "+ex.message
        return nil
      end  
      #
      # search for items inside of the scope of the passed folder
      #
      def within_scope_of(folder)
        folder ||= self.project_element
        with_scope(:find =>{ :include=>[:project_element=>[:access_control_list,:state]], :conditions=>
              ["(project_elements.left_limit > ?) and (project_elements.right_limit < ?) and project_elements.project_id= ?" ,
              folder.left_limit, folder.right_limit, folder.project_id]}) do
          yield
        end
      end
      #
      # search for items outside of the scope of the passed folder
      #
      def outside_scope_of(folder)
        folder ||= self.project_element
        with_scope(:find =>{  :include=>[:project_element=>[:access_control_list,:state]],:conditions=>
              ["not ((project_elements.left_limit > ?) and (project_elements.right_limit < ?) and project_elements.project_id= ?)" ,
              folder.left_limit, folder.right_limit, folder.project_id]}) do
          yield
        end
      end
      #
      # Filtered Find with only published, owned or accessable records returned
      #   * Is published
      #   * If current user is a member of the team owning the record
      #   * If current user was the last author of the object.
      #
      def load(id)
        self.find_visible(id)
      end  
      #
      # List all the items in the current project of the type
      #
      #
      def list(*args)
        self.find_visible(*args)
      end
      
    end # module SingletonMethods

      
    #######################################################################################
    # Add to model Instance
    # 
    #######################################################################################
    module RootInstanceMethods
      #
      # Get the folder for this object
      #
      def folder(item=nil)            
        after_create_generate_folder unless self.project_element
        unless item
          self.project_element
        else
          self.project_element.folder(item)
        end
      end  


      def after_create_generate_folder
        if self.respond_to?(:parent_id) and self.parent_id          
          self.project_element = ProjectFolder.find(:first,
            :conditions=>["name =? and parent_id is not null and project_id=? and reference_type='Project'",self.name, self.id])
          self.project_element = parent.project_element.add_folder(self.name,self)
        else
          self.project_element = ProjectFolder.find(:first,
            :conditions=>["name =? and parent_id is null and project_id=? and reference_type='Project'", self.name, self.id])
          self.project_element = ProjectFolder.add_root(self)
        end
        self.save!
      end
      
    end
    #######################################################################################
    # Child instance methods to find/create a folder 
    #
    #######################################################################################
    module ChildInstanceMethods
      #
      # Get the folder for this object
      #
      def folder(item=nil) 
        root = self.send(self.class.root_folder)
        if root
          root = root.folder(self.class.root_folder_under) unless self.class.root_folder_under.blank?
          @folder = root.folder(self)
          return @folder if item.blank?
          @folder.folder(item)
        end
      end  

      def after_create_generate_folder
        root = self.send(self.class.root_folder)
        root = root.folder(self.class.root_folder_under) if root and self.class.root_folder_under
        self.project_element = root.folder(self) if root
        self.save!
      end
    end

    #######################################################################################
    # Common methods for a folder or a item linked to a folder
    #
    #######################################################################################
    module CommonInstanceMethods
      #
      # rename folder to match
      #
      def before_update_rename_folder
        if project_element and (project_element.name !=self.name)
          project_element.name = self.name
          project_element.save!
        end
      end
      #
      # delete the folder when deleting this model
      #
      def before_destroy_delete_folder
        for  item in ProjectElement.references(self)
          item.destroy
        end
      end  
      # 
      # Owner folder of this record
      #
      def owner
        self.project_element
      end
      #
      # Get a root folder my name
      # 
      def folder?(item)
        return nil unless project_element and item
        return project_element.folder?(item)
      end    
      #
      # List of projects in models in scope of this project
      #
      def contained(klass= Project,limit=10)
         items = self.project_element.find_within(:all,:conditions=>{:reference_type=>klass.class_name}).collect{|i|i.reference_id}
         klass.find(:all,
                :include=>[:project_type,:project_element],
                :conditions=>["#{klass.table_name}.id in (?)",items],
                :limit=>limit)
      end

      #
      # rename the experimentrhtml
      #
      def rename(new_name)
        folder = self.folder
        folder.name = new_name
        self.name = new_name     
      end
      ##
      # check the permission to do stuff
      # 
      #  @param user a valid user to check the firsts of
      #  @param subject sybmol/string for area
      #  @param action symbol/string for the action to check
      #  @return true/false to passing check
      #
      def permission?(user,subject,action)  
        return true unless self.project_element
        user.current.admin || self.project_element.permission?(user,subject,action)
      end
      #
      # Is owner
      #
      def owner?(user=nil)
        user||=User.current
        return ( self[:created_by_user_id]==user[:id])
      end
      #
      # Check whether object should be visible in this context
      #   * Is published
      #   * If current user is a member of the team owning the record
      #   * If current user was the last author of the object.
      #
      def visible?    
        return true if self.new_record?
        return (
          (self[:assigned_to_user_id] == User.current.id) ||
            (self[:created_by_user_id] == User.current.id) ||
            (self[:updated_by_user_id] == User.current.id) || 
            !self.project_element || self.project_element.visible? )
      end
      #
      # See if record is fixed in the current context
      #
      def changable?
        return true if self.new_record?
        return allow?(:data,:update)
      end
      #
      # Check whether a action is allowed in the context of a 
      #   * Is published
      #   * If current user is a member of the team owning the record
      #   * If current user was the last author of the object.
      #
      def allow?(scope ='project', action = 'show' )
        return self.permission?(User.current, scope, action )
      end
      
    end    
  end
end
