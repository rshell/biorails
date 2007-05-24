class ProjectReference < ProjectElement

  validates_associated :reference

  def summary
    if reference
      out = "#{self.reference_type} ["
      out << self.reference.name if reference.respond_to?(:description)
      out << "]"
      return  out
    end
    return path
  end

  def description
    if reference
      out = "#{self.reference_type} ["
      out << self.reference.name if reference.respond_to?(:description)
      out << "]"
      out << self.reference.description if reference.respond_to?(:description)
      return out
    end
    return path
  end

  def icon( options={} )
     '/images/model/note.png'
  end  
  
  def to_html
    if reference
      out = "<h4> #{self.reference_type} ["
      out << self.reference.name if reference.respond_to?(:description)
      out << "] </h4><p>"
      out << self.reference.description if reference.respond_to?(:description)
      out << "</p>"
      return out
    end
    return path
  end
  
end
