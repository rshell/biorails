class CreateSignatures < ActiveRecord::Migration
  def self.up
    create_table :signatures do |t|
      t.column :content_hash, :string #a hash of the content that has been signed
      t.column :user_id, :integer #foreign key to user
      t.column :public_key, :string #public key of signer
      t.column :signature_format , :string #sha1, sha512
      t.column :signature_role, :string #author, witness
      t.column :signature_state, :string  #pending, signed, abandoned
      t.column :reason, :string  #why a sig was abandoned - reassigned, declined
      t.column :requested_date, :datetime
      t.column :signed_date, :datetime
      t.column :project_element_id, :integer #foreign key to asset or content
      t.column :lock_version,       :integer,              :default => 0,    :null => false
      t.column :created_at,         :datetime,             :null => false
      t.column :created_by_user_id, :integer,              :default => 1,  :null => false      
      t.column :updated_at,         :datetime,             :null => false
      t.column :updated_by_user_id, :integer,              :default => 1,  :null => false
    end
  end

  def self.down
    drop_table :signatures
  end
end
