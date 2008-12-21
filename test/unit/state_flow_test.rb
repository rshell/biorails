require 'test_helper'

class StateFlowTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    @one= State.create(:name=>'x1',:description=>'new',:level=>1,:is_default=>true,:position=>1)
    @two= State.create(:name=>'x2',:description=>'accepting',:level=>2,:position=>2)
    @three= State.create(:name=>'x3',:description=>'processing',:level=>3,:position=>3)
    @flow= StateFlow.create(:name=>'test',:description=>'test')
  end

  def test_ok
    assert_ok @one
    assert_ok @two
    assert_ok @three
    assert_ok @flow
  end

  def test_create
    @flow.enable(@one,@two)
    @flow.enable(@one,@three)
    assert @flow.allow?(@one,@two)
    assert @flow.allow?(@one,@three)
    @flow.disable(@one,@two)
    assert !@flow.allow?(@one,@two)
  end

  def test_default
    assert_ok StateFlow.default
  end

  def test_get_flow
    assert items = StateFlow.default.get_flow
    assert items.is_a?(Hash)
  end

  def test_previous_states
    flow =  StateFlow.find(:first)
    State.find(:all).each do |item|
       items = flow.previous_states(item.id)
       assert items
    end
  end

  def test_allowed_state_change
    root = ProjectElement.find(:first)
    flow =  StateFlow.find(:first)
    State.find(:all).each do |item|
      flow.allowed_state_change?(root,item.id)
    end
  end

  def test_used
    flow =  ProjectType.find(:first).state_flow
    assert flow.used?
  end

  def test_states
    flow =  StateFlow.find(:first)
    assert flow.states.size>0
  end

  
  def test_set_flow
    flow = StateFlow.create(:name=>'dfgdsgds',:description=>'dffsfs')
    assert !flow.allow?(1,3)
    flow.set_flow({1=>[1,2,3],2=>[1,2,3]})
    assert flow.allow?(1,3)
    assert flow.allow?(1,2)

  end

end
