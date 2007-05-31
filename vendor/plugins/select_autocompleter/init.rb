require 'select_autocompleter'

ActionView::Base.send :include, SelectAutocompleterMacroHelper

ActionController::Base.extend SelectAutocompleterActionHelper