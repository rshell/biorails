namespace :biorails do
 namespace :mysql do
 
  desc "Create database (using database.yml config as source of connection information)"
  task :create => :environment do
      database, user, password = Biorails::Dba.retrieve_db_info
      sql = "CREATE DATABASE #{database};"
      sql += "GRANT ALL PRIVILEGES ON #{database}.* TO #{user}@localhost IDENTIFIED BY '#{password}';"
      Biorails::Dba.mysql_execute(user, password, sql)
  end

  desc "Dump biorails database to a file"
  task :backup => :environment do
      database, user, password = retrieve_db_info
      Biorails::Dba.backup_db(database, user, password)
  end 

 end
 
end


