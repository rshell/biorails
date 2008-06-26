# == Schema Information
# Schema version: 306
#
# Table name: data_elements
#
#  id                 :integer(11)   not null, primary key
#  name               :string(50)    default(), not null
#  description        :string(1024)  default(), not null
#  data_system_id     :integer(11)   not null
#  data_concept_id    :integer(11)   not null
#  access_control_id  :integer(11)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  parent_id          :integer(11)   
#  style              :string(10)    default(), not null
#  content            :string(4000)  default()
#  estimated_count    :integer(11)   
#  type               :string(255)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#



###############################################################################################
# SQLType based in statement
# 
class SqlElement < DataElement
#
# Check the SQL is valid 
#
  def validate
    logger.info "Checkling sql #{content}"
    self.lookup('1')
    return (!self.system.nil?)
  rescue Exception => ex
    errors.add(:content,"Invalid SQL  '#{content}' error: #{ex.message}")
    return false
  end
##
# Get the constents as SQL select statement
  def statement
    return self.content
  end

  def to_array
     return self.values.collect{|v|v.name}
  end

##
#  List values for this element   
  def values
     self.system.reset_connection(DataValue)
     @values = DataValue.find_by_sql(sql_select) if !@values
     self.estimated_count = @values.size   
     return @values;  
  rescue Exception => ex
     logger.error "ERROR: lookup of #{name} failed, #{ex.message}"    
     []
  end    
  
  def sql_select
    sql = self.content
    sql = sql.gsub(/:user_id/,User.current.id.to_s)
    sql = sql.gsub(/:user_name/,User.current.login)
    sql = sql.gsub(/:project_id/,Project.current.id.to_s)
    sql = sql.gsub(/:project_name/,Project.current.name)
    return sql
#    if ProjectFolder.current
#      sql = sql.gsub(/:folder_id/,ProjectFolder.current.id.to_s)
#      sql = sql.gsub(/:folder_name/,ProjectFolder.current.name)
#    end 
  end
##
# Count the number of records returned with a select count(*) from (select ....)
# 
  def size
    return 0 unless (self.system.can_connect?)
    list = self.system.remote_connection.select_all("select count(*) num from ("+content+") x")
    return 0 unless list[0]
    list[0]["num"] 
  end

###
# Lookup to find value in a list
  def lookup(name)
    return nil unless (self.system.can_connect?)
    return  self.system.remote_connection.select_one("select * from (#{content}) x where x.name='"+name+"'")    
  rescue Exception => ex
     logger.error "ERROR: lookup of #{name} failed, #{ex.message}"    
     nil
  end

##
# Get by id  
# 
  def reference(id)
    return nil unless (self.system.can_connect?)
    self.system.remote_connection.select_one(" select * from (#{content}) x where  x.id='#{id}'")    
  rescue Exception => ex
     logger.error "ERROR: lookup of #{name} failed, #{ex.message}"    
     nil
  end
#
# @todo rjs not sure on portability and preformance of this should move windowing code to db driver
# 
# oracle: SELECT * FROM (SELECT ROWNUM as ROW_NUM, x.* FROM (content) xwhere x.name like 'xxx' order by x.name ) WHERE row_num BETWEEN 20 AND 40; 
# mysql/postgres: SELECT * FROM (Content) where name like 'xxx'  limit=20 start=0
#
  def like(name, limit=25, offset=0 )
    sql = ""
    return [{'name' => "<b>Error: no link</b>"}] unless (self.system.can_connect?)
    if (! defined?(ActiveRecord::ConnectionAdapters::OracleAdapter).nil? && self.system.remote_connection.class == ActiveRecord::ConnectionAdapters::OracleAdapter)
      sql = <<SQL
        select * from 
          (select x.*, ROWNUM row_num FROM (#{content}) x 
           where  lower(x.name) like '#{name.downcase}%' order by x.name ) 
        where row_num between #{offset} and #{(offset+limit)}
SQL
   else
      sql = <<SQL      
       select * from (#{content}) x where  lower(x.name) like '#{name.downcase}%' order by name limit #{limit} offset #{offset} 
SQL
   end
    self.system.remote_connection.select_all(sql)
 rescue Exception => ex
     logger.error "ERROR: lookup of #{name} failed, #{ex.message}"    
     []
  end
 
end
