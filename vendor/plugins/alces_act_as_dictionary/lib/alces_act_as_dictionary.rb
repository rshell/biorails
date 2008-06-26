# AlcesActAsDictionary
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
    module ActAsDictionary #:nodoc:

      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods

    # == Configuration options
    # This implements use of the object as a scheduled item with status in most cases a simple
    #    
    #      acts_as_dictionary 
    #
    #
    # Its is expecting the following fields in the class for local audit information
    # 
    # 
        def acts_as_dictionary( options={} )
          include Alces::ActAsDictionary::InstanceMethods         
          extend Alces::ActAsDictionary::SingletonMethods

        end
      end
#######################################################################################
# Add to model class
# 
      module SingletonMethods
           ##
          # Overide context_columns to remove all the internal system columns.
          # 
            def content_columns
                  @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ || c.name == inheritance_column }
            end

            #
            # Defined Like method for use in a lookup
            #
            def like(name,limit = 20,offset=0)
              self.find(:all, :conditions=>['name like ? ',name+'%'], :limit=>limit, :offset=>offset)
            end

            #
            # Defined Like method for use in a lookup
            #
            def lookup(name)
              self.find(:first,    :conditions=>['name = ? ',name])
            end
      end # module SingletonMethods
      

#######################################################################################
# Add to model Instance
# 
      module InstanceMethods

        def to_s
          return "#{self.name}"
        end        
        
      end    
    end
end
