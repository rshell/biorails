require File.dirname(__FILE__) + '/../test_helper'

class RequestTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :requests

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = Request
  end
  
  def test01_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test02_find
    first = @model.find(:first)
    assert first
  end

  def test02_update
    first = @model.find(:first)
    first.name ='sdgdsgsdgds'
    assert first.save
    first.reload
    assert 'sdgdsgsdgds',first.name
  end

  def test02_name
    first = @model.find(:first)
    assert first.name
  end

  def test03_description
    first = @model.find(:first)
    assert first.description
  end

  def test04_data_element
    first = @model.find(:first)
    assert first.data_element
  end

  def test05_project
    first = @model.find(:first)
    assert first.project
  end
  
  def test07_create
    element = DataElement.find(28)
    req = Request.create(:name=>'dddd',:description=>'dsfsfsf',:started_at=>'2000-1-1',:expected_at=>'2018-1-1',:data_element_id=>element.id)
    assert_ok req
    assert req.list
    assert_equal req.list.name,req.name
    assert_ok item = User.find(1)
    assert_ok req.add_item(item)
  end
  
  def test07_create_with_item
    element = DataElement.find(28)
    req = Request.create(:name=>'ddd2',:description=>'dsfsfsf',:started_at=>'2000-1-1',:expected_at=>'2018-1-1',:data_element_id=>element.id)
    assert_ok req
    assert req.list
    assert_equal req.list.name,req.name
    assert_ok item = User.find(1)
    assert_ok req.add_item(item)
  end
  
  def test07_create_with_service
    queue = AssayQueue.find(2)
    element = DataElement.find(28)
    assert_ok queue
    req = Request.create(:name=>'ddd3',:description=>'dsfsfsf',:started_at=>'2000-1-1',:expected_at=>'2018-1-1',:data_element_id=>element.id)
    assert_ok req
    assert req.list
    assert_equal req.list.name,req.name
    assert_ok req.add_service(queue)
  end
  
  def test07_create_with_service_and_item_and_submit
    queue = AssayQueue.find(2)
    element = DataElement.find(120)
    assert_ok queue
    req = Request.create(:name=>'ddd3',:description=>'dsfsfsf',:started_at=>'2000-1-1',:expected_at=>'2010-1-1',:data_element_id=>element.id)
    assert_ok req
    assert req.list
    assert_equal req.list.name,req.name
    assert_ok item = element.values[0]
    assert_ok req.add_item(item)
    assert_ok req.add_service(queue)
    req.submit
    assert req.items_by_service
    assert req.item_status(item.name,queue.name)
    req.priority_id =1
    assert_equal 1,req.services[0].priority_id
  end
  
  def test08_folder
    req = @model.find(:first)
    assert req.folder
  end

  def test09_folder
    req = @model.find(:first)
    assert req.folder("test08") 
  end

  def test10_items_by_service  
    req = @model.find(:first)
    assert req.items_by_service  
  end

  def test11_items
    req = @model.find(:first)
    assert req.items
  end

  def test12_submit
    req = @model.find(:first)
    assert req.submit
  end

  def test13_submit
    req = @model.find(:first)
    if req.list
      assert req.numeric_results
    end
  end

  def test14_allowed_elements
    req = @model.find(:first)
    assert req.allowed_elements
  end
  
  def test15_allowed_services
    req = @model.find(:first)
    assert req.allowed_services
  end

  def test15_not_runnable
    req = Request.new
    assert !req.runnable?
  end

  def test_add_service_with_nil
    req = @model.find(:first)
    assert_equal nil,req.add_service(nil)
  end
  
  def test_add_item_with_nil
    req = @model.find(:first)
    assert_equal nil,req.add_item(nil)
  end

  def test_add_item_with_first
    req = @model.find(:first)
    assert_equal 35, req.data_element_id
    req.list.items.each{|i|i.destroy}
    item = Compound.find(:first)
    assert_ok item
    request_item = req.add_item(item)
    assert_ok request_item
  end
  
  def test16_numeric_results
    req = create_request
    assert req
    assert req.numeric_results
  end
  
  def test17_create_request
    req = create_request
    assert req
    assert req.valid?
  end
  
  
  def create_request
    assert queue = AssayQueue.find(:first)
    assert items = Task.find(:all)
    assert items,"#{queue.data_element.name}"
    assert_not_equal items.size,0,"Cant find any #{queue.data_element.name}"
    assert queue.data_element.name
    request = Request.create(:name =>'test2',:description=>'test1')
    assert request
    request.data_element = DataElement.find(33)
    request.requested_by = User.find(1)
    request.expected_at=DateTime.now+100.day
    request.priority = 'normal'
    request.save
    assert_ok request
    assert request.add_service(queue)
    request.add_item(items[0])
    request.add_item(items[1])
    request.save
    assert_ok request
    return request
  end
  
end
