# Include hook code here
require 'alces_act_as_dictionary'
ActiveRecord::Base.send(:include,     Alces::ActAsDictionary)
