class ConfigStateFlows < ActiveRecord::Migration
  
  def self.up
    User.current = User.find(:first)
    default_flow = StateFlow.create(:name=>'default',:description=>'default workflow')

    StateChange.find(:all).each do | item|
      item.flow
      flow = StateFlow.find_by_name(item.flow)
      unless flow
        flow = StateFlow.create(:name=>item.flow,:description=>item.flow)
      end
      item.state_flow = flow
      item.save!
    end

    ProjectType.find(:all).each do |item|
      item.state_flow = default_flow
      item.save
    end
  end

end
