class UserRole < Role

  def self.subjects
    Permission.subjects(:current_user)
  end

end
