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
# This is a SQL based sub type of a DataElement. Its content is a SQL statement
# returning id,name and description fields for values of a DataElement. Its
# used for addition of external inventories to biorails.
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class SqlElement < DataElement
#
# Check the SQL is valid 
#
  def validate
    logger.info "Checking sql #{sql_select}"
    self.lookup('1')
    return (!self.system.nil?)
  rescue Exception => ex
    errors.add(:content,"Invalid SQL  '#{sql_select}' error: #{ex.message}")
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
    unless Biorails::Dba.importing?
        sql = sql.gsub(/; *$/,'')  # remove final sql separator
        sql = sql.gsub(/"/,"'")  # convert " to correct '
        sql = sql.gsub(/:user_id/,User.current.id.to_s)
        sql = sql.gsub(/:user_name/,User.current.name)
        sql = sql.gsub(/:user_login/,User.current.login)
        sql = sql.gsub(/:project_id/,Project.current.id.to_s)
        sql = sql.gsub(/:project_folder_id/,Project.current.folder.id.to_s)
        sql = sql.gsub(/:folder_id/,ProjectFolder.current.id.to_s)
        sql = sql.gsub(/:project_name/,Project.current.name)
        if TaskContext.current
          TaskContext.current.self_and_ancestors.each do |context|
            context.items.each do |key,item|
              sql = sql.gsub(":column_#{item.name}",item.to_s)
              sql = sql.gsub(":reference_#{item.data_type}",item.data_id.to_s) if item.is_a?(TaskReference)
            end
          end
        end
    end
    return sql
  end
##
# Count the number of records returned with a select count(*) from (select ....)
# 
  def size
    return 0 unless (self.system.can_connect?)
    list = self.system.remote_connection.select_all("select count(*) num from ("+sql_select+") x")
    return 0 unless list[0]
    list[0]["num"] 
  end

###
# Lookup to find value in a list
  def lookup(name)
    return nil unless (self.system.can_connect?)
    self.system.reset_connection(DataValue)
    item = DataValue.find_by_sql("select * from (#{sql_select}) x where x.name='"+name+"'")[0]
    item ||= DataValue.find_by_sql("select * from (#{sql_select}) x where x.name='"+name.to_s.downcase+"'")[0]
    item ||= DataValue.find_by_sql("select * from (#{sql_select}) x where x.name='"+name.to_s.upcase+"'")[0]
    return item    
  rescue Exception => ex
     logger.error "ERROR: lookup of #{name} failed, #{ex.message}"    
     nil
  end

##
# Get by id  
# 
  def reference(id)
    return nil unless (self.system.can_connect?)
    self.system.reset_connection(DataValue)
    DataValue.find_by_sql(" select * from (#{sql_select}) x where  x.id='#{id}'")[0]
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

    case self.system.remote_connection.class.to_s
    when /Oracle/
      sql = <<SQL
        select * from
          (select x.*, ROWNUM row_num FROM (#{sql_select}) x
           where  lower(x.name) like '#{name.downcase}%' order by x.name )
        where row_num between #{offset} and #{(offset+limit)}
SQL
   else
      sql = <<SQL      
       select * from (#{sql_select}) x where  lower(x.name) like '#{name.downcase}%' order by name limit #{limit} offset #{offset}
SQL
   end
   self.system.reset_connection(DataValue)
   DataValue.find_by_sql(sql)
 rescue Exception => ex
     logger.error "ERROR: lookup of #{name} failed, #{ex.message}"
     []
  end
 
end
