# Include hook code here
require 'better_nested_set'
require 'better_nested_set_helper'
require 'alces_tree_control'

ActiveRecord::Base.class_eval do
  include Alces::Acts::NestedSet
end
ActionView::Base.send :include, Alces::Acts::BetterNestedSetHelper
