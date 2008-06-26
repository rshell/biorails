module ActiveRecord
 module ConnectionAdapters
   class OracleAdapter
     # Returns true as this adapter supports views.
     def supports_views?
       true
     end

     def tables(name = nil) #:nodoc:
       select_all("SELECT TABLE_NAME FROM USER_TABLES").collect{|r|r['table_name']}
     end

     def views(name = nil) #:nodoc:
       select_all("SELECT VIEW_NAME FROM USER_VIEWS").collect{|r|r['table_name']}
     end

     # Get the view select statement for the specified table.
     def view_select_statement(view, name=nil)
       row = select_all("SELECT TEXT FROM USER_VIEWS WHERE VIEW_NAME = '#{view}'").each do |row|
         return row['text']
       end
       raise "No view called #{view} found"
     end
   end
 end
end