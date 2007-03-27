class CreateAuthenticationSystems < ActiveRecord::Migration
  def self.up
    create_table :authentication_systems do |t|
    t.column "name",              :string,   :limit => 50, :default => "",            :null => false
    t.column "description",       :text
    t.column "type",              :string,                 :default => "DataConcept", :null => false
    t.column "host",              :string,  :limit => 60
    t.column "port",              :integer
    t.column "account",           :string,  :limit => 60
    t.column "account_password",  :string,  :limit => 60
    t.column "base_dn",           :string
    t.column "attr_login",        :string,  :limit => 30
    t.column "attr_firstname",    :string,  :limit => 30
    t.column "attr_lastname",     :string,  :limit => 30
    t.column "attr_mail",         :string,  :limit => 30
    t.column "lock_version",      :integer,                :default => 0,             :null => false
    t.column "created_by",        :string,   :limit => 32, :default => "sys",         :null => false
    t.column "created_at",        :datetime,                                          :null => false
    t.column "updated_by",        :string,   :limit => 32, :default => "sys",         :null => false
    t.column "updated_at",        :datetime,                                          :null => false
    end
  end

  def self.down
    drop_table :authentication_systems
  end
end
