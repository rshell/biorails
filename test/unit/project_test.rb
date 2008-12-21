require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :user_roles
  ## Biorails::Dba.import_model :project_roles
  ## Biorails::Dba.import_model :users
  ## Biorails::Dba.import_model :projects
  ## Biorails::Dba.import_model :memberships
  ## Biorails::Dba.import_model :assays

  def assert_ok(object)
     assert_not_nil object, ' Object is missing'
     assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
     assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
     assert !object.new_record?,   " #{object.class}:#{object} not saved"
  end
  
  def test001_valid
     project = Project.new(:name=>'test1',:description=>'sssss',:title=>'dggsdgsd',:status_id=>0)
     assert project.valid? , project.errors.full_messages().join('\n')
  end
  
  def test002_duplicate_name
     project = Project.new(:name=>'test2',:description=>'sssss',:title=>'dggsdgsd',:status_id=>0,:team_id=>1)
     assert project.save , project.errors.full_messages().join('\n')
     project = Project.new(:name=>'test2',:description=>'sssss',:title=>'dggsdgsd',:status_id=>0,:team_id=>1)
     assert !project.valid? , "Should not allow duplicate name"
  end


  def test003_invalid
     destory_id_generator(Project)    
     project = Project.new
     assert !project.valid?  
     project = Project.new(:name=>'test3')
     assert !project.valid?  
     project = Project.new
     assert !project.valid?  
  end

  def test004_save
     team = Team.find(:first)
     project = Project.new(:name=>'test4',:description=>'sssss',:title=>'dggsdgsd',:team_id => team.id)
     assert project.save , project.errors.full_messages().join('\n')
     assert_ok project
     
     assert project.folders.size==1, 'has a root folder'
     assert project.articles.size==0, 'has no articles'
     assert project.users.size== team.users.size, 'has one member'
     assert project.members.size== team.memberships.size , 'has one membership'
     assert project.owners.size== team.owners.size, 'has one owner'
  end 
  
  
  def test005_folders
     project = Project.find(1)
     assert project.folders
  end  

   def test006_use_external_assay
    User.current = User.find(3) 
    User.current.admin =true
    User.current.save
    project = Project.current = Project.find(3)
    project.folder.access_control_list.grant(User.current,Role.find(5))
    assay = Assay.find(2)       
    assert project.project_element.visible?  , "project needs to be visible"
    assert project.changeable?," project needs to be changable to can add reference"
    assert assay.visible?,"assay must be visible"
    assert assay.is_setup?,"assay must be setup"
    assert assay.shareable?(project)
    assert project.share(assay)    
   end


  def test007_linked_to
     project = Project.find(1)
     assert project.folders.size>0
     assert !project.folders_for(Assay).nil? # array of folders linked to a model type
   end  


  def test010_create_calendar
    s = Time.now-30.days
    e = Time.now
    project = Project.find(1)
    items = project.tasks.range(s,e)

  end
 
  def test011_users
    project = Project.find(1)
    assert project.users
    assert project.users.size > 0, "there are users linked to this project"
  end
   
  def test012_owners
    project = Project.find(1)
    assert project.owners
    assert project.owners.size > 0, "there are owners linked to this project"
  end
   
  def test013_non_members
    project = Project.find(1)
    assert project.non_members
    assert project.non_members.size == 0, "Everyone is on the public project"
  end
   
  def test014_member
    project = Project.find(1)
    assert project.member(User.find(1)), "there are users linked to this project"
  end
    
  def test017_partial_template
    project = Project.find(1)
    assert project.project_type_id
    assert_equal project.project_type_id,1
    assert_equal project.project_type.name,'project'
    assert_equal File.join('projects','project','show') , project.partial_template("projects/project/show")
    assert_equal "no_moose_exists" , project.partial_template("no_moose_exists")
  end
  
 def test018_home_folder
    project = Project.new(:name =>'test18',:description=>'test',:title=>'dggsdgsd',:team_id=>1,:project_type_id=>1)
    assert project.valid?
    assert project.save
    assert project.home_folder
    assert project.home
    assert_equal project.home.project_id, project.id
    assert_equal project.home.reference, project
    assert_equal project.home.name, project.name    
  end
  
  def test019_reports
    project = Project.find(1)
    assert project.reports
  end

  def test020_folders
    project = Project.find(1)
    assert project.folders
    assert project.folders.size>0
  end

  def test021_elements
    project = Project.find(1)
    assert project.elements
    assert project.elements.size>0
  end
  
  def test022_assays
    project = Project.find(1)
    list = project.assays
    assert list
    assert list.is_a?(Array)
    if list.size>0
      for item in list
        assert_equal item,project.assay(item.id)
      end
    end
  end
  
  def test023_experiments
    project = Project.find(1)
    list = project.experiments
    assert list
    assert list.is_a?(Array)
    if list.size>0
      for item in list
        assert_equal item,project.experiment(item.id)
      end
    end
  end
  
  def test024_tasks
    project = Project.find(1)
    list = project.tasks
    assert list
    assert list.is_a?(Array)
    if list.size>0
      for item in list
        assert_equal item,project.task(item.id)
      end
    end
  end

  def test025_requested_services
    project = Project.find(1)
    list = project.requested_services
    assert list
    assert list.is_a?(Array)
    if list.size>0
      for item in list
        assert_equal item,project.requested_service(item.id)
      end
    end
  end

  def test025_queue_items
    project = Project.find(1)
    assert project.queue_items
  end

  def test026_protocols
    project = Project.find(2)
    list = project.protocols
    assert list
    assert list.is_a?(Array)
  end

  def test027_assets
    project = Project.find(1)
    assert project.assets
  end

  def test028_articles
    project = Project.find(1)
    assert project.articles
  end
  
  def test029_style
    project = Project.find(1)
    assert project.style
    assert_equal project.style , 'project'    
  end
  
  def test030_articles
    project = Project.find(1)
    assert project.runnable? == false
  end

  def test031_lastest
    project = Project.find(1)
    assert project.latest(Assay)
    assert project.latest(Experiment)
    assert project.latest(Task)
    assert project.latest(ProjectFolder)
    assert project.latest(ProjectElement)
  end

  def test032_folder_create
    project = Project.find(1)
    folder1 = project.folder("moose")
    assert_equal folder1.name,"moose"
    assert_equal folder1.project,project
    assert_equal folder1.access_control_list,project.home.access_control_list
    folder2 = project.folder("moose")
    assert_equal folder1,folder2
  end
  
  def test033_folder_for_model
    project = Project.find(2)
    x = project.folders_for(Assay)
    assert x
    assert x.size>0
    assert x.is_a?(Array)
    assert x.size>0    
  end

  def test034_linked_assays
    project = Project.find(2)
    assert project.linked_assays.size
    assert project.linked_assays
  end

  def test034_unlinked_assays
    project = Project.find(2)
    assert project.unlinked_assays.size
    assert project.unlinked_assays
  end

  def test035_process_instances
    project = Project.find(2)
    assert project.process_instances
  end

  def test036_outstanding_requested_services
    project = Project.find(2)
    list = project.outstanding_requested_services(5)
    assert list
    assert list.is_a?(Array)
  end

  def test037_lastest_tasks
    project = Project.find(2)
    list = project.latest(Task)
    assert list
    assert list.is_a?(Array)
  end

  def test038_lastest_assay
    project = Project.find(2)
    list = project.latest(Assay)
    assert list
    assert list.is_a?(Array)
  end

  def test039_lastest_by_name
    project = Project.find(2)
    list = project.latest(DataConcept,5,'id')
    assert list
    assert list.is_a?(Array)
  end

  def test040_lastest_by_records
    project = Project.find(2)
    list = project.latest(DataConcept,5)
    assert list
    assert list.is_a?(Array)
  end

  def test041_in_use?
    project = Project.find(2)
    assert project.in_use?
  end

  def test042_has_protocols?
    project = Project.find(2)
    assert project.has_protocols?
  end

  def test043_folder?
    project = Project.find(2)
    assert !project.folder?('test043')
  end



  def test045_process_flow
    project = Project.find(2)
    list = project.process_flows
    assert list
    assert list.is_a?(Array)
    if list.size>0
      for flow in list
        assert_equal flow,project.process_flow(flow.id)
      end
    end
  end

  def test045_process_instance
    project = Project.find(2)
    list = project.process_instances
    assert list
    assert list.is_a?(Array)
    if list.size>0
      for item in list
        assert_equal item,project.process_instance(item.id)
      end
    end
  end

  def test046_path
    project = Project.create(:name=>'dddddd',:description=>'degfdsgfsd',:title=>'dggsdgsd',:parent_id=>1)
    assert_ok project
    assert project.path
    assert project.state_flow
  end

  def test047_linked
    project = Project.find(1)
    assert_ok project
    assert project.linked(Task)
  end

  def test048_add_and_remove_link
    project = Project.find(1)
    assert_ok project
    cmpd = Compound.find(:first)
    link = project.add_link(cmpd)
    assert link
    assert project.linked(Compound)
    project.remove_link(cmpd)
  end

  def test_is_dictionary
    assert_dictionary_lookup(Project)
  end

end
