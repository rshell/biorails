module ActiveRecord
  module ConnectionAdapters
    class JdbcAdapter
      def supports_views?
        true
      end
      
      def nonview_tables(name = nil)
        tables
      end
    end
  end
end