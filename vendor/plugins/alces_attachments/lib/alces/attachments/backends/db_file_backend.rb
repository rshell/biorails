module Alces # :nodoc:
  module Attachments # :nodoc:
    module Backends
      # Methods for DB backed attachments
      module DbFileBackend
        def self.included(base) #:nodoc:
          Object.const_set(:DbFile, Class.new(ActiveRecord::Base)) unless Object.const_defined?(:DbFile)
          base.belongs_to  :db_file, :class_name => '::DbFile', :foreign_key => 'db_file_id'
        end

        # Gets the full path to the filename in this format:
        #
        #   # This assumes a model name like MyModel
        #   # public/#{table_name} is the default filesystem path 
        #   RAILS_ROOT/public/my_models/5/blah.jpg
        #
        # Overwrite this method in your model to customize the filename.
        # The optional thumbnail argument will output the thumbnail's filename.
        def full_filename(thumbnail = nil)
          file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
          File.join(RAILS_ROOT, file_system_path, *partitioned_path(thumbnail_name_for(thumbnail)))
        end
      
        # Used as the base path that #public_filename strips off full_filename to create the public path
        def base_path
          @base_path ||= File.join(RAILS_ROOT, 'public')
        end
      
        # The attachment ID used in the full path of a file
        def attachment_path_id
          ((respond_to?(:parent_id) && parent_id) || id).to_i
        end
      
        # overrwrite this to do your own app-specific partitioning. 
        # you can thank Jamis Buck for this: http://www.37signals.com/svn/archives2/id_partitioning.php
        def partitioned_path(*args)
          ("%08d" % attachment_path_id).scan(/..../) + args
        end
      
        # Generated a Cached images file in the public folder to match the database image
        # 
        def public_filename(thumbnail = nil)
          my_filename =  full_filename(thumbnail)
          unless File.exists?(my_filename)
            logger.info "caching image #{my_filename} #{self.id}"
            FileUtils.mkdir_p(File.dirname(my_filename))
            file = File.open(my_filename,"w") do |f|
                f.binmode
                if thumbnail
                f.write find_or_initialize_thumbnail(thumbnail).current_data
                else
                f.write self.current_data
                end
                f.close
            end
            File.chmod(attachment_options[:chmod] || 0644, my_filename)
          end  
          my_filename.gsub(%r(^#{Regexp.escape(base_path)}) ,'')
        end
        
        # Creates a temp file with the current db data.
        def create_temp_file
          write_to_temp_file current_data
        end
        
        # Gets the current data from the database
        def current_data
          self.db_file.data
        end
        
        protected
          # Destroys the file.  Called in the after_destroy callback
          def destroy_file
            db_file.destroy if db_file
          end
          
          # Saves the data to the DbFile model
          def save_to_storage
            if save_attachment?
              (db_file || build_db_file).data = temp_data
              db_file.save!
              self.class.update_all ['db_file_id = ?', self.db_file_id = db_file.id], ['id = ?', id]
            end
            true
          end
      end
    end
  end
end