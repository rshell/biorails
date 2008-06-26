module ActiveRecord
  module ConnectionAdapters
    class SQLite3Adapter
      # Returns true as this adapter supports views.
      def supports_views?
        true
      end
      # Create a view.
      # The +options+ hash can include the following keys:
      # [<tt>:check_option</tt>]
      #   Specify restrictions for inserts or updates in updatable views. ANSI SQL 92 defines two check option
      #   values: CASCADED and LOCAL. See your database documentation for allowed values.
      def create_view(name, select_query, options={})
         if options[:force]
            drop_view(name) rescue nil
          end
          execute "CREATE VIEW #{name} AS #{select_query}"
      end
      
      def tables(name = nil) #:nodoc:
        sql = <<-SQL
          SELECT name
          FROM sqlite_master
          WHERE type = 'table' AND NOT name = 'sqlite_sequence'
        SQL
        select_all(sql).collect{|row|row['name']}
      end

      def views(name = nil) #:nodoc:
        sql = <<-SQL
          SELECT name
          FROM sqlite_master
          WHERE type = 'view' AND NOT name = 'sqlite_sequence'
        SQL
        select_all(sql).collect{|row|row['name']}
      end
      
      # Get the view select statement for the specified table.
      def view_select_statement(view, name=nil)
        begin
          sql = " SELECT sql FROM sqlite_master WHERE type = 'view' AND name = '#{view}'"
          rows = select_all(sql)
          return convert_statement(rows[0]['sql']) if rows[0]
	  puts "no data found for row #{sql}"
        rescue ActiveRecord::StatementInvalid => e
          raise "No view called #{view} found"
        end
      end
      
      private
      def convert_statement(s)
        sql = s.gsub(/\n/, ' ').gsub(/\t/, ' ')
        sql.sub(/^CREATE.* as.* (select .*)/i, '\1')
      end
      
    end
  end
end