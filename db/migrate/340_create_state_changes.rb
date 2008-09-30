class CreateStateChanges < ActiveRecord::Migration
  def self.up
    State.create(:id=>1,:name=>'new',:description=>'New'              ,:level=>0) unless State.exists?(1)
    State.create(:id=>2,:name=>'accepted',:description=>'Accepted'    ,:level=>1) unless State.exists?(2)
    State.create(:id=>3,:name=>'pending', :description=>'Pending'     ,:level=>2) unless State.exists?(3)
    State.create(:id=>4,:name=>'processing',:description=>'Processing',:level=>3) unless State.exists?(4)
    State.create(:id=>5,:name=>'validated',:description=>'Validation' ,:level=>3) unless State.exists?(5)
    State.create(:id=>6,:name=>'completed',:description=>'Completed'  ,:level=>4) unless State.exists?(6)
    State.create(:id=>7,:name=>'published',:description=>'Published ' ,:level=>5) unless State.exists?(7)
    State.create(:id=>8,:name=>'reject',   :description=>'Rejected'   ,:level=>-1) unless State.exists?(8)
    State.create(:id=>9,:name=>'abort',    :description=>'Aborted'    ,:level=>-1) unless State.exists?(9)

    create_table :state_changes do |t|
      t.integer :old_state_id,  :null => false
      t.integer :new_state_id,  :null => false
      t.string :flow, :default=>'default'
      t.column "lock_version",        :integer,                 :default => 0,  :null => false
      t.column "created_at",          :datetime,                                :null => false
      t.column "updated_at",          :datetime,                                :null => false
      t.column "updated_by_user_id",  :integer,                 :default => 1,  :null => false
      t.column "created_by_user_id",  :integer,                 :default => 1,  :null => false   
    end
  end

  def self.down
    drop_table :state_changes
  end
end

