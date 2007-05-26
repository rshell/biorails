class CreateAssets < ActiveRecord::Migration
  def self.up
    execute "update project_elements set type='ProjectAsset' where asset_id is not null and type='ProjectElement'"
  end

  def self.down
    execute "update project_elements set type='ProjectElement' where asset_id is not null and type='ProjectAsset'"
  end
end
