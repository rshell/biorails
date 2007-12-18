# Modified OracleAdaptor to own taste for column mapping to use
# BINARY_DOUBLE (>10g) for floating point numbers 
# 
# also added a high/low id for higher performance mass inserts
#
module ActiveRecord
  module ConnectionAdapters
      
      class OracleColumn < Column #:nodoc:

        def type_cast(value)
          return guess_date_or_time(value) if type == :datetime && OracleAdapter.emulate_dates
          super
        end

        private

# convert something to a boolean
# Allow 1 T and Y to be mapped as a true
#
        def self.value_to_boolean(value)
          if value == true || value == false
            value
          else
            %w(true t 1 y).include?(value.to_s.downcase)
          end
        end

#
# Assume all CHAR fields are mapped to boolean and VAR
#
       def simplified_type(field_type)
          return :boolean if OracleAdapter.emulate_booleans && field_type == 'NUMBER(1)'
          return :boolean if OracleAdapter.emulate_booleans && field_type == 'CHAR(1)'
          case field_type
            when  'NUMBER' then :float
            when /date|time/i then :datetime
            else super
          end
        end

      
        def guess_date_or_time(value)
          (value.hour == 0 and value.min == 0 and value.sec == 0) ?
            Date.new(value.year, value.month, value.day) : value
        end
      end

    class OracleAdapter

        @@low_sequence = 0
        @@high_sequence = nil

        def native_database_types
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
            :boolean     => { :name => "CHAR" }
          }
        end
        

        def quoted_true
          "1"
        end

        def quoted_false
          "0"
        end

        # Returns the next sequence value from a sequence generator. Not generally
        # called directly; used by ActiveRecord to get the next primary key value
        # when inserting a new database record (see #prefetch_primary_key?).
        def next_sequence_value(sequence_name)
          id = 0
          @connection.exec("select #{sequence_name}.nextval id from dual") { |r| id = r[0].to_i }
          id
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
