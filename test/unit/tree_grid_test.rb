require File.dirname(__FILE__) + '/../test_helper'

class TreeGridTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model Project
  ## Biorails::Dba.import_model Study
  ## Biorails::Dba.import_model StudyProtocol
  ## Biorails::Dba.import_model StudyParameter
  ## Biorails::Dba.import_model ProtocolVersion
  ## Biorails::Dba.import_model Parameter
  ## Biorails::Dba.import_model Experiment
  ## Biorails::Dba.import_model Task
  ## Biorails::Dba.import_model TaskContext
  ## Biorails::Dba.import_model TaskValue
  ## Biorails::Dba.import_model TaskText
 

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
# No tasks in test data bases
#  def test_create
#     process = ProtocolVersion.find(:first)
#     assert_not_nil process
#
#     grid = TreeGrid.from_process(process)  
#     assert_not_nil grid.to_csv
#  end
#
#
#  def test_create
#     task = Task.new( :first )
#     assert_not_nil task
#     
#     assert_not_nil task.grid
#     assert_not_nil task.to_csv
#  end

end
