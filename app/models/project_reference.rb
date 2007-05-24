class ProjectReference < ProjectElement

  validates_associated :reference

  def description
    return path
  end

  def icon( options={} )
     '/images/model/note.png'
  end  
  
  def summary
     return path
  end
end
