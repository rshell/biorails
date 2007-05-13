##
# Remove context values no values
#
# 
class CleanUpTaskContexts < ActiveRecord::Migration
  def self.up
    execute <<SQL
delete from task_contexts 
where not exists (select 1 from task_values where task_values.task_context_id=task_contexts.id)
AND not exists (select 1 from task_texts where task_texts.task_context_id=task_contexts.id)
AND not exists (select 1 from task_references where task_references.task_context_id=task_contexts.id)
SQL

  end

  def self.down
  end
end
