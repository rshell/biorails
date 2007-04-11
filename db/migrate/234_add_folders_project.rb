class AddFoldersProject < ActiveRecord::Migration
  def self.up
      Project.find(:all).each do |project|
          Study.find(:all).each do |study|
             project.folder(study)
          end
      end
      Project.find(:all).each do |project|
          Experiment.find(:all).each do |expt|
             folder = project.folder(expt)
             expt.tasks.each{|task|folder.folder(task)}
          end
      end
  end

  def self.down
  end
end
