class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
<% for attribute in attributes -%>
      t.column :<%= attribute.name %>, :<%= attribute.type %>
<% end -%>
    t.column "cd_id",        :integer,                                 :null => false
    t.column "cd_structure", :binary,                  :default => "", :null => false
    t.column "cd_mol_file",  :text
    t.column "cd_smiles",    :text
    t.column "cd_formula",   :string,   :limit => 100
    t.column "cd_molweight", :float
    t.column "cd_hash",      :integer,                                 :null => false
    t.column "cd_flags",     :string,   :limit => 20
    t.column "cd_timestamp", :datetime,                                :null => false
    t.column "cd_fp1",       :integer,                                 :null => false
    t.column "cd_fp2",       :integer,                                 :null => false
    t.column "cd_fp3",       :integer,                                 :null => false
    t.column "cd_fp4",       :integer,                                 :null => false
    t.column "cd_fp5",       :integer,                                 :null => false
    t.column "cd_fp6",       :integer,                                 :null => false
    t.column "cd_fp7",       :integer,                                 :null => false
    t.column "cd_fp8",       :integer,                                 :null => false
    t.column "cd_fp9",       :integer,                                 :null => false
    t.column "cd_fp10",      :integer,                                 :null => false
    t.column "cd_fp11",      :integer,                                 :null => false
    t.column "cd_fp12",      :integer,                                 :null => false
    t.column "cd_fp13",      :integer,                                 :null => false
    t.column "cd_fp14",      :integer,                                 :null => false
    t.column "cd_fp15",      :integer,                                 :null => false
    t.column "cd_fp16",      :integer,                                 :null => false
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
