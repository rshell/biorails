class CorrectEmptyStudyParameterDescription < ActiveRecord::Migration
  def self.up
   execute "update study_parameters set description = name where length(description)<1" 
  end

  def self.down
  end
end
