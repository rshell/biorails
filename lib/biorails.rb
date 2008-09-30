# 
# biorails.rb
# 
# Created on 23-Aug-2007, 20:16:48
# 
# General High level changes done needed new version number:-
# 13/jul/2008 RJS   Moved inventory to plugin
# 14/jul/2008 RJS   Working on embedded Rdocs
# 28/sep/2008 RJS   Close to 3.1 lots of minor rhtml changes going in
# 30/sep/2008 RJS   Removed references to team and double checked acl code

 
module Biorails 
  
  TEMPLATE_MODELS = [UserRole,ProjectType,ProjectRole,User,Identifier,RolePermission,
    DataContext,DataConcept,DataSystem,ElementType,State,StateChange,
    ListElement,ModelElement,SqlElement,DataType,
    DataFormat,ParameterType,ParameterRole,AssayStage,ProjectType,
    Team,Project,Membership,
    Assay,AssayParameter,AssayQueue,
    AssayProcess,AssayWorkflow,
    ProcessInstance,ProcessFlow,ProcessStep,ProcessStepLink,  
    ParameterContext,Parameter]
  
  PROJECT_MODELS = [AccessControlList,AccessControlElement,Project,ProjectElement,Asset,Content,DbFile]

  RESULTS_MODELS = [Experiment,Task,TaskContext,TaskValue,TaskText,TaskReference]

  CATALOG_MODELS = [DataContext,DataConcept,DataSystem,
        ListElement,ModelElement,SqlElement,ElementType,State,StateChange,
        DataType,DataFormat,ParameterType,ParameterRole,AssayStage,ProjectType]

  ALL_MODELS = [UserRole,ProjectType,ProjectRole,User,Identifier,RolePermission,
    UserSetting,SystemSetting,
    DataContext,DataConcept,DataSystem,
    ListElement,ModelElement,SqlElement,ElementType,State,StateChange,    
    DataType,DataFormat,
    ParameterType,ParameterRole,AssayStage,ProjectType,
    AssayStage,
    Compound,Batch,
    Team,Project,Membership,
    AccessControlList,AccessControlElement,ProjectElement,Asset,Content,DbFile,
    Assay,
    AssayParameter,AssayQueue,
    AssayProcess,AssayWorkflow,
    ProcessInstance,ProcessFlow,ProcessStep,ProcessStepLink,
    ParameterContext,Parameter,
    List,ListItem,
    Request,RequestService,QueueItem,
    Report,ReportColumn,
    Experiment,Task,TaskContext,TaskValue,TaskText,TaskReference]
    
    def self.utf8_to_codepage(text)
      @@character_set ||= SystemSetting.character_set
      return text if  @@character_set == 'UTF-8'
      @@iconv ||= Iconv.new(@@character_set,'UTF-8')
      return @@iconv.iconv(text).to_s
    rescue 
      return text
    end
    ##
    # Get a List of all the Models
    #    
    class Dba
          #SET LOG LEVEL TO DEBUG TO SEE ANY FIXTURE LOAD ERRORS
          @@logger=Logger.new(STDOUT)
          @@logger.level=Logger::INFO
          @@active = false
          
          def self.logger
            return @@logger
          end

          def self.logger=(value)
            return @@logger=value
          end

          def self.importing?
            @@active
          end
          
          def importing=(value)
            @@active = value
          end
          
          def self.retrieve_db_info
            result = File.read "#{RAILS_ROOT}/config/database.yml"
            result.strip!
            config_file = YAML::load(ERB.new(result).result)
            return [  config_file[RAILS_ENV]['database'],
                      config_file[RAILS_ENV]['username'],
                      config_file[RAILS_ENV]['password']  ]
          end

          def self.mysql_execute(username, password, sql)
            system("/usr/bin/env mysql -u #{username} -p'#{password}' --execute=\"#{sql}\"")
          end

          def self.oracle_execute(username, password, sql)
            system("/usr/bin/env sqlplus #{username}/#{password}@#{database} #{sql}")
          end
          #
          # Backup database data for oracle,mysql or generic
          #
          def self.backup_db(database, user, password)
              datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")  
              month = Time.now.strftime("%Y-%m")  
              base_path = ENV["DIR"] || "db" 
              backup_folder = File.join(base_path, 'backup',month)
              File.makedirs(backup_folder)
              backup_file = File.join(backup_folder, "#{RAILS_ENV}_#{datestamp}_dump") 

              case database
              when 'oracle','oci8'
                puts "Using oracle export utility for backup"
                cmd = "/usr/bin/env exp #{username}/#{password}@#{database} file=#{backup_file}.dmp "
                puts cmd 
                system(cmd)
                return backup_file
              when 'mysql'
                puts "Using mysql dump utility for backup"
                cmd = "/usr/bin/env mysqldump --opt --skip-add-locks -u#{user} "
                puts cmd + "... [password filtered]"
                cmd += " -p'#{password}' " unless password.nil?
                cmd += " #{database} | gzip -c > #{backup_file}"
                system(cmd)
                return backup_file
              else
                backup_folder = File.join(base_path, 'backup',datestamp)
                File.makedirs(backup_folder)
                self.logger.info "Using default fixtures for backup"
                Biorails::ALL_MODELS.each do |model| 
                   filename = File.join(backup_folder,model.table_name + '.yml')
                   export_model(model,filename)
                end 
                return backup_folder
              end
          end
          #
          # Export a model as a yml text file for cross platform backup and export
          #
          def self.export_model(model,filename=nil)
            filename ||= File.join(RAILS_ROOT,'db','export',model.to_s.tableize + '.yml')
            File.open(filename, 'w' ) do |file|
              data = model.find(:all,:order => :id)
              file.write data.inject({}) { |hash, record|
                hash["%011d_#{record.class.name.underscore}" % record.id] = record
                hash
              }.to_yaml
            end
            self.logger.debug "Writen #{model.count} #{model.to_s} records exported to #{filename}"
          end

          #
          # Export a model from yml text file for cross platform backup and export
          #
          def self.import_model(item,filename=nil)
            @@active =true
            model = item
            if item.is_a? Symbol
              model = eval(item.to_s.singularize.camelcase)  
            end 
            filename ||= File.join(RAILS_ROOT,'test','fixtures',model.to_s.tableize + '.yml')
            success =0
            records = YAML::load( File.open(filename))
            self.logger.debug "Importing #{filename}"
            unless records.keys
              self.logger.info "Warning: No Records found in #{filename}"
              return
            end
            model.transaction do
              records.keys.sort.each do |key|
                begin
                  row = records[key]
                  if row.is_a?(Hash)
                    @new_item = model.new(row)
                    @new_item.id = row['id']
                  elsif row.class.is_a?(String)
                    @new_item = eval(row.class).new(row.ivars['attributes']) 
                    @new_item.id = row.ivars['attributes']['id']
                  else
                    @new_item = row.class.new(row.attributes) 
                    @new_item.id = row.id
                  end
                  #check for duplicates and move on silently if already loaded
                  unless model.exists?(@new_item.id)                  
                    if @new_item.save
                       success =  success + 1
                    else
                       self.logger.warn "Invalid [#{row.class}.#{row.id}] #{@new_item.errors.full_messages().to_sentence} "                       
                    end
                  else
                    self.logger.debug "#{model}.id=#{@new_item.id} already exists"      
                  end
                rescue Exception => ex
                  self.logger.error( "Error #{key} from #{filename}  #{ex.message} ") 
                  self.logger.info ex.backtrace.join("\n") 

                end
              end
              self.logger.info "Total #{success} out of #{records.size} #{model.to_s} records imported from #{filename}"
              @@active =false
              return success
            end
          end
      end 
  
  module Type
    TEXT =1
    NUMERIC = 2
    DATE = 3
    TIME = 4
    DICTIONARY = 5
    URL =6
    ASSET = 7
  end
       
  module Record
#
#  Define rules to link to actual database records for ROLES
# 
    DEFAULT_OWNER_ROLE = 5
    DEFAULT_PROJECT_ROLE = 2
    DEFAULT_USER_ROLE = 7
    
    DEFAULT_PROJECT_ID = 1
    DEFAULT_TEAM_ID = 1
    DEFAULT_GUEST_USER_ID = 1
  end
  
  module Version
    MAJOR  = 3
    MINOR  = 1
    TINY   = "$Rev$".split(" ")[1]
    URL    = "$HeadURL$"
    DATE   = "$Date$"
    STRING = [MAJOR, MINOR, TINY].join('.').freeze
    TITLE  = "Biorails".freeze
  end
      
end
#
# Json for home menu 
#
Biorails::Toolbar.add_menu(1,"Home ",'icon-home','/home') do |menu|
    menu.add_item("Dashboard",   'icon-home' ,'/home')
    menu.project_list
    menu.add_item("Recent News", 'icon-news' ,'/home/news'    )
    menu.add_item("Projects", 'icon-project' ,'/projects/list')
    menu.add_item("Todo",     'icon-todo'    ,'/home/todo'    )
    menu.add_item("Tasks",    'icon-task'    ,'/home/tasks'   )
    menu.add_item("Requests", 'icon-request' ,'/home/requests')
    menu.add_item("Calendar", 'icon-calendar','/home/calendar')
    menu.add_item("Timeline", 'icon-timeline','/home/gantt'   )
end
#
# Json for home menu 
#
Biorails::Toolbar.add_menu(2,"Project",'icon-project','/projects/show') do |menu|
    menu.add_item("Dashboard", 'icon-home'     ,'/projects/show')
    menu.add_item("Calendar",  'icon-calendar' ,'/projects/calendar')
    menu.add_item("Timeline",  'icon-timeline' ,'/projects/gantt')
    menu.add_item("Folders",   'icon-folder'   ,'/folders')
    menu.add_item("Assay Definitions", 'icon-assay' ,'/assays')
    menu.add_item("Experiments",  'icon-experiment' ,'/experiments')
    menu.add_item("Queries",      'icon-report' ,'/reports')
    menu.add_item("Signed Documents", 'icon-sign','/signatures/list')
end
#
# Json for home menu 
#
Biorails::Toolbar.add_menu(3,'Design','icon-assay','assays') do |menu|
     menu.add_item("Assays",    'icon-home' ,'/assays')       
     menu.add_item("Services",  'icon-service' ,'/queues'   )
     menu.add_item("Processes", 'icon-protocol' ,'/processes')
     menu.add_item("Recipes", 'icon-workflow' ,'/workflows')
end

Biorails::Toolbar.add_menu(10,'Administration' 'icon-catalogue','/admin/catalogue') do |menu|
    menu.add_item("Catalogue",   'icon-catalogue' ,   '/admin/catalogue')
    menu.add_item("System Reports", 'icon-report' ,   '/execute/reports/internal' )
    menu.add_item("System Settings", 'icon-settings' ,'/admin/system_settings/list' )
    menu.add_item("Data Sources",'icon-data_system' , '/admin/system' )
    menu.add_item("Data Types", 'icon-data_type' ,    '/admin/data' )
    menu.add_item("Data Formats",'icon-data_format' , '/admin/format' )
    menu.add_item("Project Types",'icon-project' ,    '/admin/project_types' )
    menu.add_item("Assay Stage",'icon-assay_stage' ,  '/admin/stage')
    menu.add_item("Parameter Types",'icon-parameter_type' ,'/admin/parameters')
    menu.add_item("Parameter Roles",'icon-parameter_role' ,'/admin/usage')
    menu.add_item("Teams",'icon-team' ,'/admin/teams')
    menu.add_item("Roles",'icon-role' ,'/admin/role')
    menu.add_item("Users",'icon-user' ,'/admin/users')
end
