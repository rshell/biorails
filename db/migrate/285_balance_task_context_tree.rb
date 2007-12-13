class BalanceTaskContextTree < ActiveRecord::Migration
  def self.up
    TaskContext.transaction do
      TaskContext.rebuild_sets
    end
  end

  def self.down
  end
end
