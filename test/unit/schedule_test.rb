require File.dirname(__FILE__) + '/../test_helper'

require File.dirname(__FILE__) + '/../test_helper'

class ScheduleTest < Test::Unit::TestCase
  fixtures :projects
  fixtures :memberships
  fixtures :users
  fixtures :studies
  fixtures :study_protocols
  fixtures :protocol_versions
  fixtures :parameters
  fixtures :study_parameters
  fixtures :experiments
  fixtures :tasks

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  
  def test001_new
    schedule = Schedule.new
    assert_not_nil schedule
    assert schedule.model == Task
  end

  def test002_new_study
    schedule = Schedule.new(Study)
    assert_not_nil schedule
    assert schedule.model == Study
  end

  def test003_new_experiment
    schedule = Schedule.new(Experiment)
    assert_not_nil schedule
    assert schedule.model == Experiment
  end

  def test004_new_task
    schedule = Schedule.new(Task)
    assert_not_nil schedule
    assert schedule.model == Task
  end

  def test005_this_month
    schedule = Schedule.new(Task)
    assert_not_nil schedule
    schedule.calendar
    assert schedule.year == Date.today.year
    assert schedule.month ==  Date.today.month
  end

  def test006_jan_month
    schedule = Schedule.new(Task)
    schedule.calendar({:year=>2007,:month=>2})
    assert schedule.year == 2007
    assert schedule.month ==  2

    schedule.filter =["experiment_id=?",15]
    schedule.refresh

    assert_not_nil schedule.items
    #assert_not_nil schedule.items[0]
  end
  
  def test007_tasks_for_user
    schedule = Schedule.new(Task)
    schedule.calendar({:year=>2007,:month=>1})
    schedule.filter =["user_id",User.find(:first)]
    schedule.refresh
    
    assert_not_nil schedule

  end   

  def test008_requests_for_user
    schedule = Schedule.new(RequestService,{:start=>'created_at',:end=>'requested_for'})
    schedule.calendar({:year=>2007,:month=>1})
    schedule.filter = ["user_id",User.find(:first)]
    schedule.refresh

    assert_not_nil schedule

  end   


  def test009_experiments_for_project
    schedule = Schedule.new(Experiment,{:start=>'created_at',:end=>'updated_at'})
    schedule.calendar({:year=>2007,:month=>1})
    schedule.filter = ["project_id",Project.find(:first)]
    schedule.refresh

    assert_not_nil schedule
  end   

  def test010_tasks_for_project
    schedule = Schedule.new(Task)
    schedule.calendar({:year=>2007,:month=>1})
    schedule.filter = ["project_id",Project.find(:first)]
    schedule.refresh

    assert_not_nil schedule

  end   

end