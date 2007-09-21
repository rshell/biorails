# == Schema Information
# Schema version: 280
#
# Table name: reports
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  description        :text          
#  base_model         :string(255)   
#  custom_sql         :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  style              :string(255)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#  internal           :boolean(1)    
#  project_id         :integer(11)   
#  action             :string(255)   
#

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
