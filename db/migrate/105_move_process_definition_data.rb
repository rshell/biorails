##
# move data arround with changes to remove the process definition as merge it with study protocols
#
class MoveProcessDefinitionData < ActiveRecord::Migration
  def self.up
    oracle_sql = <<SQL
    update study_protocols s
    set 
     s.name,
     s.description,
     s.protocol_catagory,
     s.protocol_status,
     s.literature_ref,
     s.lock_version,
     s.created_by,created_at,
     s.updated_by,
     s.updated_at
    ) = (
    select 
    p.name,
    p.description,
    p.protocol_catagory,
    p.protocol_status,
    p.literature_ref,
    p.lock_version,
    p.created_by,created_at,
    p.updated_by,
    p.updated_at
    from process_definitions p
    where p.id = s.process_definition_id )
SQL
##
# Need to move data across from process_definitions table to study Protocols 
# This is generic version forgot and wrote oracle specific SQL, nice but no good in other databases.
# Kept oracle version for reference.
#  
    generic_sql = <<SQL
    update study_protocols s 
    set
     s.name              = ( select p.name from process_definitions p where p.id = s.process_definition_id ),
     s.description       = ( select p.description from process_definitions p where p.id = s.process_definition_id ),
     s.protocol_catagory = ( select p.protocol_catagory from process_definitions p where p.id = s.process_definition_id ),
     s.protocol_status   = ( select p.protocol_status from process_definitions p where p.id = s.process_definition_id ),
     s.literature_ref    = ( select p.literature_ref from process_definitions p where p.id = s.process_definition_id ),
     s.lock_version      = ( select p.lock_version from process_definitions p where p.id = s.process_definition_id ),
     s.created_by        = ( select p.created_by from process_definitions p where p.id = s.process_definition_id ),
     s.created_at        = ( select p.created_at from process_definitions p where p.id = s.process_definition_id ),
     s.updated_by        = ( select p.updated_by from process_definitions p where p.id = s.process_definition_id ),
     s.updated_at        = ( select p.updated_at from process_definitions p where p.id = s.process_definition_id )
SQL
    execute generic_sql
    
##
# Ok moving process_instances to new daddy. process_definition_id linked to study_protocol.id
#     
    update_ref_sql = <<SQL
    update process_instances i set i.process_definition_id 
    =( select s.id from study_protocols s, process_definitions d 
   where s.process_definition_id = d.id
   and d.id = i.process_definition_id )
SQL
    execute update_ref_sql
##
# Try to guess links between study_parameters and parameters
# Only likily to be 75% successful
# 
    update_parameter_ref_sql = <<SQL
update parameters p set 
p.study_parameter_id = (
select s.id
from process_instances v, 
     study_parameters s,
     study_protocols q
where p.name = s.default_name
and   p.parameter_type_id =s.parameter_type_id
and   p.parameter_role_id = s.parameter_role_id
and   p.process_instance_id = v.id
and   v.process_definition_id = q.id
and  q.study_id = s.study_id
order by p.id, s.id )
SQL
  execute update_parameter_ref_sql
  
  end

  def self.down
  ##
  # Interesting case have to move reference back when downgrading (may need to create process definitions
  # but not really attempting that high a level of downgrade!)
  # 
    update_ref_sql = <<SQL
    update process_instances i set i.process_definition_id 
    =( select d.id from study_protocols s, process_definitions d 
   where s.process_definition_id = d.id
   and s.id = i.process_definition_id )
SQL
    execute update_ref_sql  
  end
end
