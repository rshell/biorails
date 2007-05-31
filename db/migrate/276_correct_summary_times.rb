class CorrectSummaryTimes < ActiveRecord::Migration
  def self.up
    execute 'update experiments set started_at=(select min(tasks.started_at) from tasks where tasks.experiment_id=experiments.id), expected_at=(select max(tasks.expected_at) from tasks where tasks.experiment_id=experiments.id) '
    execute 'update studies set started_at=(select min(experiments.started_at) from experiments where experiments.study_id=studies.id),expected_at=(select max(experiments.expected_at) from experiments where experiments.study_id=studies.id)'
  end

  def self.down
  end
end
