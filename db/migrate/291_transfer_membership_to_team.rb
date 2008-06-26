class TransferMembershipToTeam < ActiveRecord::Migration
  def self.up
      Project.find(:all).each do |project|
         team = Team.create(
                 :id => project.id,
                 :public_role_id=>1,
                 :external_role_id =>1,
                 :status_id => 0,                  
                 :name =>project.name,
                 :description=>project.description)
         puts "Failed to transfer #{project.name}" unless team.valid?
       end

       add_column    :projects, :team_id, :integer ,:default=>0, :null => false
       add_column    :project_elements, :team_id, :integer ,:default=>0, :null => false
       add_column    :studies, :team_id, :integer ,:default=>0, :null => false
       add_column    :experiments, :team_id, :integer ,:default=>0, :null => false
       add_column    :tasks, :team_id, :integer ,:default=>0, :null => false
       add_column    :requests, :team_id, :integer ,:default=>0, :null => false

       execute 'update projects set team_id = id'
       execute 'update project_elements set team_id = project_id'
       execute 'update studies set team_id = project_id'
       execute 'update experiments set team_id = project_id'
       execute 'update tasks set team_id = project_id'
       execute 'update requests set team_id = project_id'

       add_column    :memberships, :team_id  ,:integer ,:default=>0, :null => false  
       #add_column :memberships, :project_id, :integer,:default=>0, :null=>false
      execute 'update memberships set team_id = project_id'

 end

  def self.down
       remove_column    :projects, :team_id
       remove_column    :project_elements, :team_id
       remove_column    :studies, :team_id
       remove_column    :experiments, :team_id
       remove_column    :tasks, :team_id
       remove_column    :requests, :team_id
       remove_column    :memberships, :project_id
       rename_column    :memberships, :team_id, :project_id

      Project.find(:all).each do |project|
         team.find(project.id)       
         puts "Failed to remove #{project.name}" unless team.destory
       end
  end
end
