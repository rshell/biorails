# == Schema Information
# Schema version: 280
#
# Table name: project_elements
#
#  id                     :integer(11)   not null, primary key
#  parent_id              :integer(11)   
#  project_id             :integer(11)   not null
#  type                   :string(32)    default(ProjectElement)
#  position               :integer(11)   default(1)
#  name                   :string(64)    default(), not null
#  reference_id           :integer(11)   
#  reference_type         :string(20)    
#  lock_version           :integer(11)   default(0), not null
#  created_at             :datetime      not null
#  updated_at             :datetime      not null
#  updated_by_user_id     :integer(11)   default(1), not null
#  created_by_user_id     :integer(11)   default(1), not null
#  asset_id               :integer(11)   
#  content_id             :integer(11)   
#  published_hash         :string(255)   
#  project_elements_count :integer(11)   default(0), not null
#  left_limit             :integer(11)   default(0), not null
#  right_limit            :integer(11)   default(0), not null
#

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
      return reference.to_html if reference.respond_to?(:to_html)
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
