require 'liquid'
require 'extras/liquid_view'

if defined? ActionView::Template and ActionView::Template.respond_to? :register_template_handler
#  ActionView::Template::register_template_handler :liquid, LiquidView
else
#  ActionView::Base::register_template_handler :liquid, LiquidView
end