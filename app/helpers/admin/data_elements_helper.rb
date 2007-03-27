##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
module Admin::DataElementsHelper

  def values
    txt = table_from_array(@data_element.values)
    return txt
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
  end

#
# General a table for a set of Named Records  
# 
  def table_from_records(records)
       txt ='<table>' 
       txt += render :partial => 'shared/table_of_named',
       :locals => {:items => records, 
                   :controller => 'data_elements',
                   :edit => 'edit', 
                   :show => 'show' }
       txt +='</table>' 
       puts txt
       return txt
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      ex.message
  end

#
#  Generate table from a array of hashed records
#  
  def table_from_array(dataset)  
     txt ='<table class="sheet">' 
     txt += '<thead class="tableHeader">'
     txt += ' <th>id</th><th>name</th>'
     txt += ' </thead> <tbody>'  
     if dataset.size>300
        txt += table_row(dataset.first)
        txt +='<tr><td colspan="2"> '+ (dataset.size-2).to_s+ ' rows </td></tr>'
        txt += table_row(dataset.last)
     else                
      for row in dataset
        txt += table_row(row)
      end       end
     txt +='</tbody>'
     txt +='</table>'
     return txt 
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      ex.message
  end
 

  def table_row(row)
      txt = '<tr>'
      txt += '<th>'+ row['id'].to_s + '</th>' 
      txt += '<td>'+ row['name'].to_s + '</td>' 
      txt +='</tr>'
      return txt  
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")    
      ex.message
  end
end
