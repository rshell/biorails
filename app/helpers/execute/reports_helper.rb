##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##



module Execute::ReportsHelper
  #
  # used to generate sortable header in reports show
  #
  def column_header(report,column)
    if column.is_sortable 
      return link_to_remote( column.label,
                            { :url =>  report_url( :action => 'show',:id =>report.id, :sort => "#{column.name}:#{column.next_direction}" , :page => nil )} ,
      { :class=>"#{column.sort_direction}" })
    else
      return column.label 
    end 
  end
  
  #
  # used to generate filter header in reports show
  #
  def column_filter(report,column)
    if column.is_filterible
      return "<input id='filter_#{column.name}' name='filter[#{column.name}]' size='8' value='#{column.filter}' type='text' />"
    end   
  end
  
  def data_json(report)
    data = report.run({:page=>report.page,:per_page => report.limit})
    items = []
    for data_row in data
      row = {:id => data_row.id ,
             :url => object_to_url(data_row)}
      report.columns.each do  |column| 
         row[column.id] = [column.value(data_row)].flatten.join("\n") 
      end
      items << row
    end
    return {:items => items,:report_id=>self.id,:id=>'id',:total=>data.total_entries }.to_json
  end
  # 
  # Generate a Level in the tree of columns for a report.
  #
  def columns_to_json(report,model=nil,path="")
    model ||= report.model
    items =[]
    model.content_columns.each do |rec| 
      items << {
        :id => "#{report.model}~#{path}#{rec.name}",
        :text => rec.name,
        :icon =>  "/images/enterprise/data_columns/#{rec.type}.png", 
        :iconCls=> "icon-#{rec.type}",
        :name => rec.name,
        :allowDrag => true,
        :allowDrop => false,	
        :leaf => true,
        :qtip => "#{rec.name} is #{rec.type} field with a #{rec.limit} size"	
      }
    end 
    for relation in model.reflections.values.sort{|a,b| a.macro.to_s <=> b.macro.to_s}
      unless relation.options[:polymorphic] or (report.base_model==relation.class_name) or (relation.macro==:has_many and path.size>2) 
        items << {
          :id => "#{@path}#{relation.name}",
          :icon => "/images/enterprise/data_columns/#{relation.macro}.png",
          :iconCls=>"icon-#{relation.macro}",
          :text => relation.name,           
          :allowDrag => false,
          :allowDrop => false,	
          :leaf => false,
          :qtip => "#{model.class} #{relation.macro} #{relation.options[:class_name]||relation.name} via #{relation.options[:foreign_key]||relation.primary_key_name}"	
        }
      end
    end    
    items.to_json      
  end  
  
end
