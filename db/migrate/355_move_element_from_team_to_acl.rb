class MoveElementFromTeamToAcl < ActiveRecord::Migration
  def self.up
    add_column :project_elements, :access_control_list_id, :integer
    Team.find(:all).each do |item|
       acl = AccessControlList.from_team(item)
       execute "update project_elements set access_control_list_id = #{acl.id} where team_id=#{item.id}"
    end   
  end

  def self.down
    remove_column :project_elements, :access_control_list_id
  end
end
