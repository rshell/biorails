# == Schema Information
# Schema version: 359
#
# Table name: data_elements
#
#  id                 :integer(4)      not null, primary key
#  name               :string(50)      default(""), not null
#  description        :string(1024)    default(""), not null
#  data_system_id     :integer(4)      not null
#  data_concept_id    :integer(4)      not null
#  access_control_id  :integer(4)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  parent_id          :integer(4)
#  style              :string(10)      default(""), not null
#  content            :string(4000)    default("")
#  estimated_count    :integer(4)
#  type               :string(255)
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# DataElement linked back to defined Model in Rails. This is a simple dynamic link to 
# a model class which used all the standard finder methods etc
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class ModelElement < DataElement
#
# Check the SQL is valid 
#
  def validate
    logger.info "Checking model #{content}"
    self.estimated_count = self.model.count
    return  true #super.validate
  rescue Exception => ex
    errors.add(:content,"Invalid Model #{content} error: #{ex.message}")
    return false
  end
  
  def model
    return eval(self.content)
  end

  def to_array
     return self.values.collect{|v|v.name}
  end

#
#  List values for this element   
#    
  def values
   @values = self.model.find(:all,:limit=>1000) unless @values
   estimated_count = @values.size
   return @values
  rescue Exception=>ex
    logger.error "Lookup lookup failed for #{content}.#{name} : #{ex.message}"
    return []    
  end    

  def size
    return self.model.count
  end
###
# Lookup to find value in a list
# 
  def lookup(name)
    if self.model.respond_to?(:lookup)
       self.model.lookup(name)
    else
       self.model.find_by_name(name)
    end
  rescue Exception=>ex
    logger.error "Lookup lookup failed for #{content}.#{name}: #{ex.message}"
    return nil    
  end
##
# Get by id  
# 
  def reference(id)
    if self.model.respond_to?(:reference)
       self.model.reference(id)
    else
       self.model.find(id)
    end
  rescue Exception=>ex
    logger.error "Reference lookup failed for #{content}.#{id} : #{ex.message}"
    return nil    
  end

###
# find values like 
#  
  def like(name,limit=25,offset=0)
    if self.model.respond_to?(:like)
       self.model.like(name,limit,offset)
    elsif name.blank?
       self.model.find(:all,:limit=>100,:order=>'name', :limit=>limit, :offset=>offset)
    else
       self.model.find(:all, :conditions=>['lower(name) like ?',name.downcase+'%'], :order=>'name', :limit=>limit, :offset=>offset)
    end
  rescue Exception=>ex
    logger.error "Lookup lookup failed for #{content}.#{name} : #{ex.message}"
    return []  
  end

end
