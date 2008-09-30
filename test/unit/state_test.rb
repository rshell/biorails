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

end
