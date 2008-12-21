class SetStatusIdNullable < ActiveRecord::Migration
 def self.execute_ignore_error(sql)
    execute sql
  rescue  Exception => ex
     puts 'Ignoring SQL error'+ex.message
  end
  def self.up
    change_column :teams,:status_id,:integer,:null => true,:default=>0
    change_column :projects,:status_id,:integer,:null => true,:default=>0
    change_column :assays,:status_id,:integer,:null => true,:default=>0
    change_column :experiments,:status_id,:integer,:null => true,:default=>0
    change_column :tasks,:status_id,:integer,:null => true,:default=>0
    change_column :requests,:status_id,:integer,:null => true,:default=>0
    change_column :request_services,:status_id,:integer,:null => true,:default=>0
    change_column :queue_items,:status_id,:integer,:null => true,:default=>0
    change_column :queue_items,:project_element_id,:integer,:null => true
    if Biorails::Check.oracle?
      puts " work arround problem with in oracle and set nullable directly"
      execute_ignore_error "alter table PROJECTS modify STATUS_ID null"
      execute_ignore_error "alter table TASKS modify STATUS_ID null"
      execute_ignore_error "alter table TEAMS modify STATUS_ID null"
      execute_ignore_error "alter table ASSAYS modify STATUS_ID null"
      execute_ignore_error "alter table EXPERIMENTS modify STATUS_ID null"
      execute_ignore_error "alter table REQUESTS modify STATUS_ID null"
      execute_ignore_error "alter table REQUEST_SERVICES modify STATUS_ID null"
      execute_ignore_error "alter table QUEUE_ITEMS modify STATUS_ID null"
      execute_ignore_error "alter table QUEUE_ITEMS modify PROJECT_ELEMENT_ID null"
    end
  end

  def self.down
    change_column :teams,:status_id,:integer,:null => false
    change_column :projects,:status_id,:integer,:null => false
    change_column :assays,:status_id,:integer,:null => false
    change_column :experiments,:status_id,:integer,:null => false
    change_column :tasks,:status_id,:integer,:null => false
    change_column :requests,:status_id,:integer,:null => false
    change_column :request_services,:status_id,:integer,:null => false
    change_column :queue_items,:status_id,:integer,:null => false
    change_column :queue_items,:project_element_id,:integer,:null => false
  end
end
