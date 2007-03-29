##
# Internal report types
# 
class SystemReport < Report
##
# Default report to build if none found in library
#    
  def self.list_for_model(model,name = nil)
    name ||= "List_of_#{model}"
    report = SystemReport.find(:first,:conditions=>['name=? and base_model=?',name,model.class.to_s])
    unless report
        Report.transaction do
          report = SystemReport.new
          report.name = name 
          report.description = "Default reports for display as /#{model.to_s}/list"
          report.save
          report.model= model
          report.column('id').is_visible = false
          if report.has_column?('name')
             report.column('name').is_filterible = true
          end
          unless report.save
             logger.warn("failed to save report:"+report.errors.full_messages().join("\n"))
             #logger.debug(report.to_yaml)             
          end
        end
    end
    return report
  end

##
# Generate a default report to display all the reports in the list of types
  def self.reports_on_models(list,name = nil)
   list = list.collect{|i|i.to_s}
   name ||= "List_for_#{list.join('_')}"
   report = SystemReport.find(:first,:conditions=>['name=? and base_model=?',name,'Report'])
   unless report
     report = SystemReport.new
     report.model = Report
     report.name = name
     report.description = "#{name} list of all #{list.join(',')} based reports on the system"
     report.column('custom_sql').is_visible=false
     report.column('id').is_visible = false
     column = report.column('base_model')
     column.filter_operation = 'in'
     column.filter_text = "("+list.join(",")+")"
     column.is_filterible = false
     report.save
   end
   return report
  end
end