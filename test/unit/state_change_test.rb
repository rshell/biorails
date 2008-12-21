require File.dirname(__FILE__) + '/../test_helper'

class StateChangeTest < ActiveSupport::TestCase

  def setup
    assert_ok @one= State.create(:name=>'x1',:description=>'new',:level=>1,:is_default=>true,:position=>1)
    assert_ok @two= State.create(:name=>'x2',:description=>'accepting',:level=>2,:position=>2)
    assert_ok @flow= StateFlow.create(:name=>'test',:description=>'test')
  end

  def test_find
    @flow.enable(@one,@two)
    item = StateChange.find(:first)
    assert item.name
    assert item.to_s
  end

  def test_relations
    @flow.enable(@one,@two)
    item = StateChange.find(:first)
    assert item.to
    assert item.from
    assert item.state_flow
  end


end
