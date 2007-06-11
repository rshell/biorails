class ProjectRole < Role

  def self.subjects
    Permission.subjects(:current_project)
  end

end
