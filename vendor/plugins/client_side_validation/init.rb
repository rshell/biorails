
require 'boiler_plate/instance_tag_validations'

ActionView::Helpers::InstanceTag.class_eval do
  include BoilerPlate::ActionViewExtensions::InstanceTagValidationsSupport
end

ActionView::Helpers::AssetTagHelper::register_javascript_include_default('validator')
