class AddTypesToProject < ActiveRecord::Migration

  def self.up
    ProjectType.create(:id=>1,:name=>'project',:description=>'Default',:dashboard=>'project') unless ProjectType.exists?(1)
    ProjectType.create(:id=>2,:name=>'assay_group',:description=>'Assay Group',:dashboard=>'assay_group') unless ProjectType.exists?(2)
    
    add_column :projects,:project_type_id,:integer,:default => '1'
    
  end

  def self.down
    remove_column :projects,:project_type   
  end

end
