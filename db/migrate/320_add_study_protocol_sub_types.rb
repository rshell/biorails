class AddStudyProtocolSubTypes < ActiveRecord::Migration
  def self.up
    add_column :study_protocols,:type,:string,:default => 'StudyProcess' ,:null => false
  end

  def self.down
    remove_column :study_protocols,:type   
  end

end
