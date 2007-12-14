class CreateSignatures < ActiveRecord::Migration
  def self.up
    create_table :signatures do |t|
      t.column :content_hash, :string #a hash of the content that has been signed
      t.column :signer, :integer #foreign key to user
      t.column :public_key, :string #public key of signer
      t.column :signature_format , :string #sha1, sha512
      t.column :signature_role, :string #author, witness
      t.column :signature_state, :string  #pending, signed, abandoned
      t.column :reason, :string  #why a sig was abandoned - reassigned, declined
      t.column :requested_date, :datetime
      t.column :signed_date, :datetime
      t.column :project_element, :integer #foreign key to asset or content
    end
  end

  def self.down
    drop_table :signatures
  end
end
