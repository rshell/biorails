# == Schema Information
# Schema version: 280
#
# Table name: task_relations
#
#  id           :integer(11)   not null, primary key
#  to_task_id   :integer(11)   
#  from_task_id :integer(11)   
#  relation_id  :integer(11)   
#

# == Schema Information
# Schema version: 233
#
# Table name: task_relations
#
#  id           :integer(11)   not null, primary key
#  to_task_id   :integer(11)   
#  from_task_id :integer(11)   
#  relation_id  :integer(11)   
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
# This is used to govern cascade of tasks in a experiment. In internal release
# task should be in the same experiment. This is used to work out whether all 
# required(relation_id=1) tasks have been completed 
# 
# relation_id=1 is required
# relation_id=2 is parent 
# 
class TaskRelation < ActiveRecord::Base

  belongs_to :from , :class_name=>'Task', :foreign_key =>'from_task_id'
  belongs_to :to , :class_name=>'Task', :foreign_key =>'to_task_id'

end
