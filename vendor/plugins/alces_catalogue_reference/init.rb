# Include hook code here
require 'alces_catalogue_reference'
ActiveRecord::Base.send(:include,     Alces::CatalogueReference)