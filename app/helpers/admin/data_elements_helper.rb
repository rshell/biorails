##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
module Admin::DataElementsHelper

  def values
    list = @data_element.values
    if list
       table_from_array(list) 
    end
  rescue 
      ""
  end


#
#  Generate table from a array of hashed records
#  
  def table_from_array(dataset)  
     txt ='<table class="report">' 
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
  rescue
      ""
  end
 

  def table_row(row)
      txt = '<tr>'
      txt += '<th>'+ row['id'].to_s + '</th>' 
      txt += '<td>'+ row['name'].to_s + '</td>' 
      txt +='</tr>'
      return txt  
  rescue
    ""
  end
end
