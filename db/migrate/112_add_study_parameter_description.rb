##
# Ok minor rev up for parameters added units and descriptions
# Unit have three roles 
#   * [storage_unit] storage (for searching) decided globally       (eg. M)
#   * [display_unit] display (for viewing) decided at study level   (eg. mM)
#   * [data_unit] entry (for typing) decided at entry type       (eg nM)
#   
class AddStudyParameterDescription < ActiveRecord::Migration
  def self.up
    add_column     :study_parameters, "description", :string, :limit => 1024, :default => "", :null => false
    rename_column  :study_parameters, "default_name", "name"
    add_column     :study_parameters, "display_unit", :string
    add_column     :parameter_types, "storage_unit", :string
    add_column     :task_values,      "storage_unit", :string
    rename_column  :task_values,      "data_unit", "display_unit"
     ##
     # Default description is the parameter_type description
     # 
    execute "update study_parameters s set s.description = (select p.description from parameter_types p where p.id=s.parameter_type_id) "    
  end

  def self.down
    remove_column  :study_parameters, "description"
    rename_column  :study_parameters,  "name","default_name"
    remove_column  :study_parameters, "default_unit"
    remove_column  :parameter_types, "storage_unit" 
    remove_column  :task_values,      "storage_unit"
    rename_column  :task_values,     "display_unit", "data_unit"
  end
end
