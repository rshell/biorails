class AddDefaultElementTypes < ActiveRecord::Migration
  def self.up
    ElementType.create(:id=>1,:name=>'html',:class_name=>'ProjectContent',:description=>'text/html') unless ElementType.exists?(1)
    ElementType.create(:id=>2,:name=>'file',:class_name=>'ProjectAsset',:description=>'file reference') unless ElementType.exists?(2)
    ElementType.create(:id=>3,:name=>'reference',:class_name=>'ProjectReference',:description=>'model reference') unless ElementType.exists?(3)
    ElementType.create(:id=>4,:name=>'folder',:class_name=>'ProjectFolder',:description=>'folder') unless ElementType.exists?(4)
    ElementType.create(:id=>5,:name=>'wiki',:class_name=>'ProjectWiki',:description=>'text/textile') unless ElementType.exists?(5)
  end

  
  def self.down
    execute "delete from element_types where id in (1,2,3,4,5)"
  end
end
