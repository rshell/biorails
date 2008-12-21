# == Schema Information
# Schema version: 359
#
# Table name: reports
#
#  id                 :integer(4)      not null, primary key
#  name               :string(128)     default(""), not null
#  description        :string(1024)    default(""), not null
#  base_model         :string(255)
#  custom_sql         :string(255)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  style              :string(255)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  internal           :boolean(1)
#  project_id         :integer(4)
#  action             :string(255)
#  project_element_id :integer(4)
#

# == Description
# Internal report types
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class SystemReport < Report

    def initialize(options={})
    super(options)
    self.internal=true
    self.style ='System'
  end

##
# Default report to build if none found in library
#
    def self.internal_report( name, model, &block)
      name ||= "Biorails::List #{model}"
      Report.transaction do
        report = SystemReport.find(:first,:conditions=>['name=? and base_model=?',name.to_s, model.to_s])
        if report.nil?
          ActiveRecord::Base.logger.info " Generating default report #{name} for model #{model}"
          report = SystemReport.new
          report.name = name
          report.description = "Default reports for display as /#{model.to_s}/list"
          report.model= model
          report.internal=true
          report.style ='System'
          report.lock_version=0
          report.save!
          if block_given?
            yield report
          else
            for col in model.content_columns
              report.column(col.name)
            end
            report.column('id').is_visible = false
          end
        else
          ActiveRecord::Base.logger.info " Using current report #{name} for model #{model.class_name}"
          yield report if block_given?
        end #built report
        report.save!
        return report
      end # commit transaction
    end


end
