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
# 13/oct/2008 RJS   merged back some changes from oracle specific testing
# 14/oct/2008 RJS   update javascript to ext 2.2
# 14/oct/2008 RJS   added work arrounds for IE6 to stytle sheet
# 14/oct/2008 RJS   issue'10676 turned off data formating in grid only work in opera
# 14/oct/2008 RJS   lots of minor UI issues
# 15/oct/2008 RJS   new prototype.js version and fixes to process javascript
# 15/oct/2008 RJS   change to show bread crumb on project header
# 15/oct/2008 RJS   fixed task template copy and some other flow issues
# 15/oct/2008 RJS   final checking cleaned up flow for organization and execution
# 19/oct/2008 RJS   IE6 corrections to report/edit and more user of reports for lists
# 19/oct/2008 RJS   Javascript correcton for row index on 3rd level tables
# 22/oct/2008 RJS   GLOC Label set updated 
# 22/oct/2008 RJS   Controller access control improved
# 22/oct/2008 RJS   minor changes to teams and fixes to sql for oracle
# 22/oct/2008 RJS   lots of minor hide/show of items by rights
# 22/oct/2008 RJS   cascaded publishing rules check self and children
# 24/oct/2008 RJS   loads of show/hide logic in html to links added
# 26/OCT/2008 RJS   separated system and project reports controllers
# 28/oct/2008 RJS   fixed a number of minor issues request, and flows
# 30/oct/2008 RJS   issue#10866 , issue#10846 issue#10890, issue#10885 , issue#10889, issue#10886
# 30/oct/2008 RJS   updated UI for status changing
# 30/oct/2008 RJS    removed folder tab from show on task,assay,experiment for consistency
# 30/oct/2008 RJS   issue#10897 correct forms for service queue
# 31/oct/2008 RJS   lots of UI finishing and consistency changes
#  2/nov/2008 RJS   added search filter to reports
#  3/nov/2008 RJS   updated bootstrap data and version to 367
#  3/nov/2008 RJS   correction to state flow
#  4/nov/2008 RJS   lots of minors to clear bug lists
#  5/nov/2008 RJS   lots of change to add custom properties to projects
#  5/nov/2008 RJS   linked references to projects
#  5/nov/2008 RJS   critical fix to teams admin to allow grant on acl
#  6/nov/2008 RJS   lots of bugs fixes consolidated in
#  7/nov/2008 RJS   issue#5001 have added basic formula langauge for default values
#  9/nov/2008 RJS   javascript update to pass complete row on cell_value calls
# 10/nov/2008 RJS   lots of minor fixes to project dashboard layouts
# 10/nov/2008 RJS    disabled multiple cell update as effects edit of next cell
# 12/nov/2008 RJS   3.1 release build
# 12/nov/2008 RJS   3.1 release build attempt to missed some new files
# 13/nov/2008 RJS   added rake tasks to cleanup after tests and create tar archive of code 
# 15/nov/2008 RJS   checking unit/functional test to >80% per file >90% total automated coverage
# 18/nov/2008 RJS   more test fill in and some extras cleanup of projects
# 18/nov/2008 RJS   improved team UI to allow add of whole team to another
# 24/nov/2008 RJS   added group-n to formats for output and corrected issue 11003
# 24/nov/2008 RJS   issue 11018 adeded linked combos to task sheet
# 24/nov/2008 RJS   add reworked project dashboards.
# 25/nov/2008 RJS   added fixtures for each project dashboard type
# 25/nov/2008 RJS   linked combos support ancestors of context in tree
# 25/nov/2008 RJS   issue#11002 added nbsp so empty cells display better
# 26/nov/2008 RJS   corrected linked combo events for forms
# 27/nov/2008 RJS   integrated state_flow and signatures for public states
# 27/nov/2008 RJS   added ability to withdraw published data if a admin
#  1/dec/2008 RJS   integrated Ted & my changes and sort character set problems
#  1/dec/2008 RJS   corrected reordering or parameters in process
#  2/dec/2008 RJS    checked for 3.1.x releasde
#  4/dec/2008 rjs    issue#11071,issue#11073,issue#11074  added circe specific validation rule to sample present and some catalogue fixes
#  4/dec/2008 rjs   issue#11070 done
#  4/dec/2008 rjs   folder tree stays open
#  5/dec/2008 rjs   cross bugs fixed #11091
#  8/dec/2008 rjs   issue 11085, 11086, 11061, 11087 fixed updated version number
#  8/dec/2008 rjs   issue 11085 added display of current status to cross tab
#  9/dec/2008 rjs   issue 11082 state flow rules change to cascade changes to lower states
#  9/dec/2008 rjs   issue #11104 changes add select_data_element_tag
#  9/dec/2008 rjs   issue #11057 changed add rows to accept number of rows
#  9/dec/2008 rjs   issue #11096 addec experiment and project to crosstab table
#  9/dec/2008 rjs   issue #11098 removed empty rows from cross tab table
#  9/dec/2008 rjs   issue #11058 fixed IE7 errors
#  9/dec/2008 rjs   issue #11092 buttets in content now display
#  9/dec/2008 rjs   issue #11080 checked state changes cascade rules
#  9/dec/2008 rjs   issue #11101 data content removel on project destroy
#  9/dec/2008 rjs   issue #11095 changed column order to match process definition
#  9/dec/2008 rjs   issue #11108 fixed file combo to show file in task folder 
# 10/dec/2008 rjs   issue #11110 #10963 corrected assigned team ion experiment/task
# 10/dec/2008 rjs   issue #11107 added tiff to list of image formats
# 10/dec/2008 rjs   issue #11114 edited en.yml to change of case
# 10/dec/2008 rjs   issue #11113 order of context in cross tabe changed to project,experiment,task
# 10/dec/2008 rjs   issue #11089 cookie remembers the width of side panels now
# 10/dec/2008 rjs   issue #11091 cleaned up by process and by alias
# 10/dec/2008 rjs   issue #11111 IE specific edit form problems fixed
# 10/dec/2008 rjs   issue #11061 minor changes to attempt to stop red initial cell on use
# 10/dec/2008 rjs   issue #11120 change dashboard to either tema or parent project shows.
# 11/dec/2008 rjs   issue #11112 added warning and more information to state flow show to help
# 11/dec/2008 rjs   issue #11131 reorder ALL_TABLE to match order of import_template
# 11/dec/2008 rjs   issue #11132 added fix to get call to projects/create
# 12/dec/2008 rjs   issue #11090 add cls style "x-tree-selected" to selected node
# 12/dec/2008 rjs   issue #11132 added sequence reset after import
# 12/dec/2008 rjs   issue #11133 added missing team for root domains
# 12/dec/2008 rjs   issue #11134 added fixed access to read only domains
# 12/dec/2008 rjs   issue #11124 changed to 500ms delay type ahead
# 12/dec/2008 rjs   issue #11119 changed to order view by row_no like task sheet
# 12/dec/2008 rjs   issue #10996 fixed cancel option on sign move to folders/show of item
# 12/dec/2008 rjs   issue #10970 Default Task Report - selection not saved for new version
# 12/dec/2008 rjs   issue #11027 adding links appears ok
# 12/dec/2008 rjs   issue #11010 in removed combo for lookup parameter types
# 13/dec/2008 th    issue #11066 Removed status information from assay_group dashboard
# 13/dec/2008 rjs   issue #11139 Minor sheet UI change typeAhead: false set
# 13/dec/2008 rjs   issue #11137 Masked problems with witness select
# 13/dec/2008 rjs   issue #11138 created_by user allowed to delete the project
# 13/dec/2008 rjs   issue #11127 task_import now raises exception on cell errors to poor data
# 13/dec/2008 rjs   issue #11140 added member management to user controller
# 13/dec/2008 rjs   issue #11110 removed hidden field which stopped team changing
# 13/dec/2008 rjs   issue #11053 Paste from HTML into summary causes error fixed
# 13/dec/2008 rjs   issue #11099 attempt to cleanup problem with LDAP users data
# 13/dec/2008 rjs   issue #11136 rake biorails:fix:issue_11136 added
# 13/dec/2008 rjs   issue #11130 rake biorails:db:catalog_repopulate added to fix child items for lookup
# 15/dec/2008 rjs   issue #11152 Added extra to check to save of [None] to create a new task_reference so does attempt to lookup value and fail.
# 16/dec/2008 rjs   issue #11161 changes how teams used with project creation to better seperate roles
# 16/dec/2008 rjs   issue #11161 corrected for creaton of new study as root
# 16/dec/2008 rjs   issue #11156 changed to old simple javascript free select for roles and added checks for role and type objects present
# 16/dec/2008 rjs   issue #11158 stoped signatures counter incrementing twice.
# 16/dec/2008 rjs   issue #11155 linked model validation to underlying database field limits
# 17/dec/2008 rjs   issue #11154 changed context code to allow creation of child contexts from labels
# 17/dec/2008 rjs   issue #11159 Added Delete button for references to other project elements
# 17/dec/2008 rjs   issue #11162 corrected folder_element_list service
# 18/dec/2008 th    issue #11144 Resquests rather than requests, #11146 signing and withdraw made consistent
# 18/dec/2008 rjs   issue #11173 circe search methods fixed change of get_all_analyse method tom 2=>3 parameters
# 18/dec/2008 rjs   ipsen #11166 moved setting field selectors to project_helper and fixed default user on new project
# 18/dec/2008 rjs   ipsen #11116 I have removed compounds as work is batch base
# 18/dec/2008 rjs    turned of automated oracle unique key  to model validation rule builder as no slow
# 18/dec/2008 rjs   issue #11178 changed initial state to cascade from parent
# 18/dec/2008 rjs   issue  #11179 created now uses project_type_id from new form to set project type as goto correct dashboard
# 18/dec/2008 rjs   ipsen #11176 changed to ether batch or sample missing is a error
# 
# 19/dec/2008 rjs   ipsen #11180 sat down with Ted and fixed the dashboard
# 19/dec/2008 rjs   issue #11185 cascade to/from a level -1 state no cascading
# 19/dec/2008 rjs   added messages display for state and reworded edit forms
# 19/dec/2008 rjs   issue #10506 validate default value is parsable to a value for the parameter
# 
# 22/dec/2008 rjs   issue #11188 corrected type on session helper stopping display of admin menu to managers
# 22/dec/2008 rjs   issue #11106 minor corrections to improve useability of add parameters to assay.
# 22/dec/2000 rjs   issue #11190 minor change menu only show name of project not path as was pushing menu beyond 1024 screen size
# 22/dec/2000 rjs   issue #10970 copying attributes to new version of process also added a quick link to test a process
# 29/dec/2008 rjs   issue #11196 changed error text
# 29/dec/2008 rjs   issue #11232 updated folder controll to tests for frozen folder on copy items
# 05/jan/2009 rjs   issue #11236 corrected validation rules on process version to remove updated_by
# 05/jan/2009 rjs   issue #10931 converted spools to remove speak marks.
# 08/jan/2009 rjs   issue #11244 change forms to be consistent
# 08/jan/2009 rjs   issue #11247 fixed state combo for queue items display
# 09/jan/2009 rjs   html preview for folder changed slightly
# 09/jan/2009 rjs   cross tabe crossed to save filters on edit and handle units correctly
# 13/jan/2009 rjs   issue #11172 bug in .visible? checker only worked for owners and direct access.
# 13/jan/2009 rjs   issue #11253 correct problem with missing reset of current project in web API
# 14/jan/2009 rjs   issue #11256 cross tab snapshot fixed
# 14/jan/2009 rjs   issue #11250 fixed so 1st item in list displayed
# 14/jan/2009 rjs   issue #11257 changed default to low not sure if this is full solution
# 14/jan/2009 rjs   issue #11265 corrected html for opera on
# 15/jan/2009 rjs   issue #11265 general cleanup of request status code.
# 16/jan/2009 rjs   issue #11164 process creation calls added to SOAP API
# 16/jan/2009 rjs   issue #11193 folder filters  calls added to SOAP API
# 20/jan/2009 rjs   Changed to open office for document conversion

module Biorails 
  
  TEMPLATE_MODELS = [
    UserRole,
    ProjectType,
    ProjectRole,
    User,
    Identifier,
    RolePermission,
    State,
    StateFlow,
    StateChange,
    DataContext,
    DataConcept,
    DataSystem,
    ElementType,
    ListElement,
    ModelElement,
    SqlElement,
    DataType,
    DataFormat,
    ParameterType,
    ParameterTypeAlias,
    ParameterRole,
    AssayStage, 
    AccessControlList,
    Team,
    Project,
    AccessControlElement,
    Membership,
    Assay,
    AssayParameter,
    AssayQueue,
    AssayProcess,
    AssayWorkflow,
    ProcessInstance,
    ProcessFlow,
    ProcessStep,
    ProcessStepLink,
    ParameterContext,
    Parameter,
    ProjectElement]

  PROJECT_MODELS = [
    Project,
    ProjectElement,
    Asset,
    Content,
    DbFile]

  RESULTS_MODELS = [
    Experiment,
    Task,
    TaskContext,
    TaskValue,
    TaskText,
    TaskReference]

  CATALOG_MODELS = [
    DataContext,
    DataConcept,
    DataSystem,
    ListElement,
    ModelElement,
    SqlElement,
    ElementType,
    State,StateFlow,
    StateChange,
    DataType,
    DataFormat,
    ParameterType,
    ParameterTypeAlias,
    ParameterRole,
    AssayStage,
    ProjectType]

  ALL_MODELS = [
    UserRole,
    ProjectType,
    ProjectRole,
    User,
    UserSetting,
    Identifier,
    RolePermission,
    State,
    StateFlow,
    StateChange,
    DataContext,
    DataConcept,
    DataSystem,
    ElementType,
    ListElement,
    ModelElement,
    SqlElement,
    DataType,
    DataFormat,
    ParameterType,
    ParameterTypeAlias,
    ParameterRole,
    AssayStage,
    AccessControlList,
    Team,
    Membership,
    AccessControlElement,
    Project,
    ProjectSetting,
    Assay,
    AssayParameter,
    AssayQueue,
    AssayProcess,
    AssayWorkflow,
    ProcessInstance,
    ProcessFlow,
    ProcessStep,
    ProcessStepLink,
    ParameterContext,
    Parameter,
    ProjectElement,
    Asset,
    Content,
    DbFile,
    List,
    ListItem,
    Request,
    RequestService,
    QueueItem,
    Report,
    ReportColumn,
    CrossTab,
    CrossTabColumn,
    CrossTabFilter,
    CrossTabJoin,
    Experiment,
    Task,
    TaskContext,
    TaskValue,
    TaskText,
    TaskReference]
    
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
          
    def self.importing=(value)
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

    def self.retrieve_db_adapter
      result = File.read "#{RAILS_ROOT}/config/database.yml"
      result.strip!
      config_file = YAML::load(ERB.new(result).result)
      return config_file[RAILS_ENV]['adapter']
    end
    
    def self.mysql_execute(username, password, sql)
      system("/usr/bin/env mysql -u #{username} -p'#{password}' --execute=\"#{sql}\"")
    end

    def self.oracle_execute(username, password, sql)
      Biorails::Check.run("sqlplus #{username}/#{password}@#{database}","#{sql}; exit;")
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
      backup_file = File.join(backup_folder, "biorails_#{RAILS_ENV}_#{datestamp}")

      if Biorails::Check.oracle?
        puts "Using oracle export utility for backup"
        cmd = "exp #{user}/#{password}@#{database} file=#{backup_file}_export.dmp "
        puts cmd
        system(cmd)
        puts "Backup done to #{backup_file}}_export.dmp "
        return backup_file
      elsif Biorails::Check.mysql?
        puts "Using mysql dump utility for backup"
        cmd = "/usr/bin/env mysqldump --opt --skip-add-locks -u#{user} "
        puts cmd + "... [password filtered]"
        cmd += " -p'#{password}' " unless password.nil?
        cmd += " #{database} | gzip -c > #{backup_file}.sql.gz"
        system(cmd)
        puts "Backup done to #{backup_file}.sql.gz "
        return backup_file
      else
        backup_folder = File.join(base_path, 'backup',datestamp)
        File.makedirs(backup_folder)
        self.logger.info "Using default fixtures for backup into #{backup_folder}"
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
            self.logger.error( "Warning #{model}.#{key} failed with #{ex.message} ")
          end
        end
        self.logger.info "Total #{success} out of #{records.size} #{model} records imported from #{filename}"
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

    DEFAULT_NAME_MASK =  /^[A-Z,a-z,0-9,_,\.,\-,+,\$,\&, ,:,#]*$/
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

  module Check

    def self.oracle?
      Biorails::Dba.retrieve_db_adapter =~ /oracle/
    end

    def self.mysql?
      Biorails::Dba.retrieve_db_adapter =~ /mysql/
    end

    def self.database_driver
    end
#
# Check for htmldoc
#
    def self.htmldoc_status
      puts "Checking for htmldoc"
      puts ident = run("htmldoc --version ")
      if ident.blank?
        puts "Cant find htmldoc executable please install"
        return false
      end
      pdf = PDF::HTMLDoc.new
      pdf.set_option :outfile, "xxx.pdf"
      pdf.set_option :webpage, true
      pdf.set_option :charset, SystemSetting.character_set
      pdf.set_option :bodycolor, :white
      pdf.set_option :links, false
      pdf.set_option :path, File::SEPARATOR
      pdf << "#{RAILS_ROOT}/public/500.html"
      pdf.generate
      puts "htmldoc installed"
      return true
    rescue Exception => ex
      puts "Error in looking for htmldoc"
      false
    end

    def self.graphviz_status
      puts "Checking for htmldoc"
      ident = run("dot -V")
      image_file =  Biorails::UmlModel.create_model_diagram(File.join(RAILS_ROOT, "public/images"),Project,{})
      unless image_file.nil?
         puts "Graphviz Installed"
        return true
      end
      puts "WARNING: Graphiv no installed"
      return false
    rescue Exception => ex
      puts "Error in looking for graphviz #{ex.message}"
      false
    end
#
# Check fof image magick and suitable gem
#
    def self.image_magick_status
      puts "Checking for ImageMagick convert"
      puts ident = run("convert -version")
      if ident.blank?
        puts "ERROR: No ImageMagick convert executable on path please install"
        return false
      end

      begin
        require 'RMagick'
        if Object.const_defined?(:Magick)
          image = Magick::Image.read("#{RAILS_ROOT}/public/images/logo/logo_full.png").first
          thumb = image.resize(50,50)
          unless thumb.nil?
            puts "Rmagick Installed"
            return true
          end
        end
      rescue Exception => ex
        puts "No Rmagic installed, trying mini_magick"
      end

      begin
        require 'mini_magick'
        if Object.const_defined?(:MiniMagick)
          print "Found mini_magick gem"
          image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/images/logo/logo_full.png")
          thumb = image.resize(50,50)
          if thumb.nil?
            puts "ERROR: no image conversion processor found"
            return false
          else
            puts  "mini_magick Installed"
            return true
          end
        end
      rescue Exception => ex
        puts "No mini_magic installed"
      end


      puts "No image processing utility installed pleace gem install mini_magick"
      return false
    rescue Exception => ex
      puts "Error in attempting to test image processing"
      return false
    end

    def self.run(command,input='')
      IO.popen(command,'r+') do |io|
        io.puts input
        io.close_write
        return io.read
      end
    rescue Exception => ex
      puts "Failed to run #{command}"
      false
    end
  end
end
