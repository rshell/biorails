module Execute::ReportsHelper

 def column_header(report,column)
  if column.is_sortable 
   return link_to_remote( column.label,
         { :url =>  report_url( :action => 'refresh',:id =>report.id, :sort => "#{column.name}:#{column.next_direction}" , :page => nil )} ,
         { :class=>"#{column.sort_direction}" })
   else
       return column.label 
   end 
 end

 def column_filter(report,column)
      if column.is_filterible
        return "<input id='filter_#{column.name}' name='filter[#{column.name}]' size='8' value='#{column.filter}' type='text' />"
      end   
 end

end
