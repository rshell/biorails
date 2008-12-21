require File.dirname(__FILE__) + '/../test_helper'

class StateTest < ActiveSupport::TestCase

  def setup
    @model = State
    @item = State.create(:name=>'test',:description=>'test',:is_default=>true,:position=>1,:level=>1)
  end

  def test00_new
    item = @model.new
    assert item
    assert_nil item.name
    assert_nil item.description
  end

  def test01_find_one
    item = @model.find(:first)
    assert item
    assert item.name
    assert item.description
    assert item.level_no
    assert item.level_text
  end

  def test02_find_all
    list = @model.find(:all)
    assert list
    assert list.is_a?(Array)
  end
  
  def test03_create
    item1= @model.create(:name=>'new',:description=>'new',:level=>1,:is_default=>true,:position=>1)
    item2= @model.create(:name=>'accept',:description=>'accepting',:level=>2,:position=>2)
    item3= @model.create(:name=>'process',:description=>'processing',:level=>3,:position=>3)
  end

  def test004_flows
    list = State.flows
    assert list
    assert list.size>0
    assert list[0].is_a?(StateFlow)
  end

  def test005_states
    list = State.states
    assert list
    assert list.size>0
    assert list[0].is_a?(State)
  end
  
  def test006_get
    item = State.find(1)
    element = ProjectElement.find(:first)
    assert_equal item, State.get(1)
    assert_equal item, State.get(item.name)
    assert_equal item, State.get(item.id)
    assert_equal item, State.get(item)
    assert_equal element.state, State.get(element)
  end

  def test007_in_use
    element = ProjectElement.find(:first)
    assert element.state.in_use?
  end

  def test008_finished
    state = State.find(:first,:conditions=>['level_no> ?',State::FROZEN_LEVEL])
    assert state.finished?
  end
end
