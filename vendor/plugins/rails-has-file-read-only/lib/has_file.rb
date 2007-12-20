# = Rails Plugin: has_file v0.1 =
#   
# || Website:   || http://code.google.com/p/rails-has-file                  ||
# || Author:    || John Wulff <johnw@orcasnet.com>                          ||
# || Copyright: || Copyright (c) 2007 John Wulff <johnw@orcasnet.com>       ||
# || License:   || MIT <http://www.opensource.org/licenses/mit-license.php> ||
#
# == SETUP ==
# {{{
#   class Node < ActiveRecord::Base
#     has_file :donkey
#   end
# }}}
#
# == BEHAVIOUR ==
# {{{
#   >> n = Node.new
#     => #<Node:0x2661e04 @attributes={"created_at"=>nil}, @new_record=true>
#   >> n.donkey = "secret donkey message"
#     => "secret donkey message"
#   >> n.donkey_file_path
#     => "/tmp/node-20123394-donkey"
#   >> n.donkey
#     => "secret donkey message"
#   >> n.save!
#     => true
#   >> n.donkey_file_path
#     => "/Users/jwulff/Development/rails/resources/node-4-donkey"
#   >> n.donkey
#     => "secret donkey message"
#   >> n.destroy
#     => #<Node:0x2661e04 @attributes={"created_at"=>"2007-05-08 15:07:47"}>
#   >> File.exists? "/Users/jwulff/Development/rails/resources/node-4-donkey"
#     => false
# }}}

module ActiveRecord; module Has; end; end
module ActiveRecord::Has::HasFile
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def has_file(field = :resource, root = File.join(RAILS_ROOT, 'resources'))
      
      # Write the passed object to the file.  If the object responds to the 
      # read method, write the returned value for read to the file.  Otherwise,
      # write the object's to_s.
      define_method("#{field}=") do |input|
        unless input.blank?
          Dir.mkdir(root) unless File.exists?(root)
          
          input = input.read if input.respond_to?(:read)
          x = File.open(self.send("#{field}_file_path"), 'w')
          x << input
          x.close
        end
      end
      
      # Return the contents of the file if the file exists.
      define_method(field) do
        if self.send("#{field}_exists?")
          File.read self.send("#{field}_file_path")
        else
          nil
        end
      end
      
      # Return a boolean describing weather or not a file exists.
      define_method("#{field}_exists?") do
        File.exists?(self.send("#{field}_file_path"))
      end
      
      # Generate the full path of the file putting the file in either the 
      # temporary directory or its permanent home depending on weather or not
      # the object is a new record.
      define_method("#{field}_file_path") do
        if self.new_record?
          base_path = Dir.tmpdir
        else
          base_path = root
        end
        File.expand_path(File.join(base_path, self.send("#{field}_file_name")))
      end
      
      # Generate the name of the file based on either the object id or database 
      # id depending on weather or not the object is a new record.
      define_method("#{field}_file_name") do
        if self.new_record?
          "#{self.class.to_s.underscore}-#{self.object_id}-#{field}"
        else
          "#{self.class.to_s.underscore}-#{self.id}-#{field}"
        end
      end
      
      # Move the file from the temporary directory to its permanent home.
      before_create do |record|
        if record.send("#{field}_exists?")
          record.instance_variable_set "@#{field}_tmp_file_path", record.send("#{field}_file_path")
        end
      end
      after_create do |record|
        if record.send("#{field}_exists?")
          FileUtils.mv record.instance_variable_get("@#{field}_tmp_file_path"),
                       record.send("#{field}_file_path")
        end
      end
      
      # Delete the file after the object is destroyed.
      after_destroy do |record|
        if record.send("#{field}_exists?")
          File.delete record.send("#{field}_file_path")
        end
      end
      
    end    
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Has::HasFile)