class MoveCurrentProjectAssets < ActiveRecord::Migration
  def self.up
    #
    # Change each Asset into a Content item
    # 
    ProjectContent.transaction do
      items = ProjectAsset.find(:all)
      items.each do |element|
        unless Content.exists?(['db_file_id=?',element.asset.db_file_id])
          new_content = Content.new(
            :project_id => element.project_id,
            :name       => element.name,
            :title      => element.asset.title,
            :db_file_id => element.asset.db_file_id,
            :content_size => element.asset.size_bytes,
            :content_type => element.asset.content_type
          )
          new_content.save!
          new_content.body_html = element.asset.image_tag
          new_content.body = element.asset.db_file.data
          new_content.save!
          element.content = new_content
          element.save
        end
      end
    end
  end

  def self.down
    #
    # Remove created Content items
    # 
    ProjectContent.transaction do
      items = ProjectAsset.find(:all)
      items.each do |element|
        content = Content.find(:first,:conditions=>['db_file_id=?',element.asset.db_file_id])
        content.save!
        element.content = nil
        element.save
      end
      execute "delete from project_contents where db_file_id is not null "  
    end
  end

end
