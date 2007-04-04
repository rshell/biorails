# == Schema Information
# Schema version: 233
#
# Table name: subscribers
#
#  id         :integer(11)   not null, primary key
#  user_id    :integer(11)   default(0), not null
#  project_id :integer(11)   default(0), not null
#

class Subscriber < ActiveRecord::Base
end
