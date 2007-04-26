module Alces # :nodoc:
  module Attachments # :nodoc:
    module Backends
      # Methods for DB backed attachments
      module BlobBackend
        def self.included(base) #:nodoc:
        end

        # Creates a temp file with the current db data.
        def create_temp_file
          write_to_temp_file current_data
        end
        
        # Gets the current data from the database
        def current_data
          self.content_data
        end
        
        protected
          # Destroys the file.  Called in the after_destroy callback
          def destroy_file
            
          end
          
          # Saves the data to the DbFile model
          def save_to_storage
            if save_attachment?
              self.content_data = temp_data
              self.save!
            end
            true
          end
      end
    end
  end
end