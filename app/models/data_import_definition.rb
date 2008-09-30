# == Schema Information
# Schema version: 359
#
# Table name: data_import_definitions
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)     not null
#  description          :string(255)     not null
#  default_folder_path  :string(255)     default("."), not null
#  file_format          :string(255)     default("--- :csv\n"), not null
#  file_header_count    :integer(4)      default(0), not null
#  data_header_count    :integer(4)      default(0), not null
#  data_header_name_row :integer(4)      default(0), not null
#  data_header_name_col :integer(4)      default(0), not null
#  data_areas_count     :integer(4)      default(0), not null
#  data_areas_across    :boolean(1)      not null
#  data_start_col       :integer(4)      default(0), not null
#  data_col_count       :integer(4)      default(0), not null
#  data_row_count       :integer(4)      default(0), not null
#  data_read_across     :boolean(1)      not null
#  file_footer_count    :integer(4)      default(0), not null
#  lock_version         :integer(4)      default(0), not null
#  created_at           :time
#  created_by_user_id   :integer(4)      default(1), not null
#  updated_at           :time
#  updated_by_user_id   :integer(4)      default(1), not null
#

class DataImportDefinition < ActiveRecord::Base
  
end
