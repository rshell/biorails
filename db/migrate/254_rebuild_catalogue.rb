class RebuildCatalogue < ActiveRecord::Migration
  def self.up
     DataElement.transaction do
       for element in ListElement.find(:all)
          element.updated_at = DateTime.now
          element.save
       end
     end
  end

  def self.down
  end
end
