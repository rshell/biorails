class AddMissingFolders < ActiveRecord::Migration
 REMOVED_UNLINKED_CHILDREN = <<SQL
select * from project_elements 
where not exists (select 1 from project_elements e
              where e.id = project_elements.parent_id)
SQL

  def self.up
    puts "Removing Invalid Elements (Parent missing)....."
    for item in ProjectElement.find_by_sql(REMOVED_UNLINKED_CHILDREN)
       puts "Remove #{item.id} #{item.path}"
      item.destroy
    end
    puts "Checking studies folders....."
    Study.find(:all).each do |item|
       puts "#{item.id} #{item.name}"
       folder = item.folder
       if folder.id.nil?
          puts "adding #{folder.id} #{folder.path}"
          folder.save 
       end
    end
    puts "Checking protocols folders....."
    StudyProtocol.find(:all).each do |item|
       puts "#{item.id} #{item.name}"
       folder = item.folder
       if folder.id.nil?
          puts "adding #{folder.id} #{folder.path}"
          folder.save 
       end
    end

    puts "Checking experiments folders....."
    for item in Experiment.find(:all)
       puts "#{item.id} #{item.name}"
       folder = item.folder
       if folder.id.nil?
          puts "adding #{folder.id} #{folder.path}"
          folder.save 
       end
    end

    puts "Checking tasks folders....."
    for item in Task.find(:all)
       puts "#{item.id} #{item.name}"
       folder = item.folder
       if folder.id.nil?
          puts "adding #{folder.id} #{folder.path}"
          folder.save 
       end
    end

end

  def self.down
  end
end
