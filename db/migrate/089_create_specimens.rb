##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateSpecimens < ActiveRecord::Migration
  def self.up
    create_table :specimens do |t|
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "description", :text      
      t.column "weight", :float
      t.column "sex", :string
      t.column "birth", :datetime
      t.column "age", :datetime
      t.column "taxon_domain", :string      
      t.column "taxon_kingdom", :string      
      t.column "taxon_phylum", :string      
      t.column "taxon_class", :string      
      t.column "taxon_family", :string      
      t.column "taxon_order", :string      
      t.column "taxon_family", :string      
      t.column "taxon_genus", :string      
      t.column "taxon_species", :string      
      t.column "taxon_subspecies", :string      
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :specimens
  end
end
