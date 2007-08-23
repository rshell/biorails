# Modified OracleAdaptor to own taste for column mapping to use
# BINARY_DOUBLE (>10g) for floating point numbers 
# 
# also added a high/low id for higher performance mass inserts
#
begin
  require_library_or_gem 'oci8' unless self.class.const_defined? :OCI8
  
  module ActiveRecord
    module ConnectionAdapters

      class OracleAdapter
      
          @@low_sequence = 0
          @@high_sequence = nil
          
          def native_database_types #:nodoc:
            {
              :primary_key => "NUMBER(11) NOT NULL PRIMARY KEY",
              :string      => { :name => "VARCHAR2", :limit => 255 },
              :text        => { :name => "VARCHAR2", :limit => 2048 },
              :integer     => { :name => "NUMBER", :limit => 11 },
              :float       => { :name => "BINARY_DOUBLE" },
              :decimal     => { :name => "DECIMAL" },
              :datetime    => { :name => "DATE" },
              :timestamp   => { :name => "TIMESTAMP" },
              :time        => { :name => "DATE" },
              :date        => { :name => "DATE" },
              :binary      => { :name => "BLOB" },
              :boolean     => { :name => "CHAR", :limit => 1 }
            }
          end
          
        
          def quoted_true
              "Y"
          end
      
          def quoted_false
              "N"
          end
      
          #
          # Create High/Low value based on a application sequence name. 
          # This is a simple round trip saver to the database two stop a dual trip for insert. 
          #
          def next_id_value
            if @@low_sequence == 0 
               @connection.exec("select biorails_app_seq.nextval id from dual") { |r| @@high_sequence = r[0].to_i }
            end
            @@low_sequence = ( @@low_sequence +1 ) % 256
            return  @@high_sequence*256  +  @@low_sequence 
          end
                
      end      
    end
  end
  
rescue LoadError
  # OCI8 driver is unavailable.
  module ActiveRecord # :nodoc:
    class Base
      @@oracle_error_message = "Oracle/OCI libraries could not be loaded: #{$!.to_s}"
      def self.oracle_connection(config) # :nodoc:
        # Set up a reasonable error message
        raise LoadError, @@oracle_error_message
      end
      def self.oci_connection(config) # :nodoc:
        # Set up a reasonable error message
        raise LoadError, @@oracle_error_message
      end
    end
  end
end
