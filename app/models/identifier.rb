# == Schema Information
# Schema version: 239
#
# Table name: identifiers
#
#  id                 :integer(11)   not null, primary key
#  name               :string(255)   
#  prefix             :string(255)   
#  postfix            :string(255)   
#  mask               :string(255)   
#  current_counter    :integer(11)   default(0)
#  current_step       :integer(11)   default(1)
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# This is a simple table based identifier generator to filling in the name field for 
# new records. If is based on lookup on the model/name passed.
# Identifiers are based on three elements prefix,sequence and postfix
#  <prefix><sequence><postfix>
#  
class Identifier < ActiveRecord::Base

##
# Generate a Id based on the current record
# 
  def next_id
     self.current_counter = self.current_counter + self.current_step
     my_id = "#{self.prefix}#{self.current_counter}#{self.postfix}"
     my_id = eval(self.mask)  if self.mask
     self.save
     return my_id
  end

##
# Generate a name for a model class
#   
  def self.next_id(model)
     Identifier.transaction do
       generator = Identifier.find_by_name(model.to_s)
       unless generator
           generator = Identifier.new
           generator.name = model.to_s
           generator.prefix = "#{model}-"
           generator.postfix = ""
           generator.save
       end
       return generator.next_id
     end
  end

end
