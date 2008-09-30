class AddVersionToSignature< ActiveRecord::Migration
  def self.up
    add_column :signatures,:file_version,:integer,:default=>0,:null=>false
  end

  def self.down
    remove_column :signatures,:file_version
  end
end
