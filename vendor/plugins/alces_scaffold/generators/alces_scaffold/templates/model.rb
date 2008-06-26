class <%= class_name %> < ActiveRecord::Base
  
  def path
    return self.name
  end
  
end
