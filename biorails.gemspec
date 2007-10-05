require 'date'
Gem::Specification.new do |s|
  s.name = %q{biorails}
  s.version = "2.0.0"
  s.date = Date.today.to_s
  s.summary = %q{Biorails is a rails based biora}
  s.description =<<DESCRIPTION
Biorails is a Ruby on Rails based data management system. For management of electronic project
folders with build in data capture of structure data in sheet and unstructured annotations.

DESCRIPTION
  s.author = %q{Robert shell}
  s.email = %q{bob@biorails.org}
  s.homepage = %q{http://biorails.com}
  s.files = Dir.glob('**/*')
  s.require_paths = %w{lib .}
  s.rubyforge_project = %q{biorails}
  s.extensions = %w{gem_extconf.rb}
  s.has_rdoc = false
  s.required_ruby_version = '>= 1.8.6'
  s.requirements << 'ImageMagick 6.0.0 or later, MySql 5.0, GnuPlot 4.0 and Project R for full functions '

  s.rdoc_options = ["--title", "Biorails Documentation", "--main", "README", "-q"]
  s.extra_rdoc_files = ["README", "LICENSE", "AUTHORS"]

  s.add_dependency(%q<gem_plugin>, [">= 0.2.2"])
  s.add_dependency(%q<rubyforge>, [">= 0.4.1"])
  s.add_dependency(%q<rake>, [">= 0.7.2"])
  s.add_dependency(%q<rails>, [">= 1.2.3"])

  s.add_dependency(%q<transaction-simple>, ["= 1.4.0"])
  s.add_dependency(%q<fastercsv>, [">= 1.1.0"])
  s.add_dependency(%q<pdf-writer>, [">= 1.1.3"])
  s.add_dependency(%q<daemons>, [">= 1.0.3"])
  s.add_dependency(%q<tzinfo>, [">= 0.3.3"])
  s.add_dependency(%q<icalendar>, [">= 0.98"])
  s.add_dependency(%q<builder>, [">= 2.1.2"])
  s.add_dependency(%q<mime-types>, [">= 1.15"])

  s.add_dependency(%q<mysql>, ["= 1.4.0"])
  s.add_dependency("sqlite3-ruby", ">= 1.1.0")

  s.add_dependency(%q<gnuplot>, ["= 2.2.0"])
  s.add_dependency(%q<rmagick>, ["= 2.2.0"])
  s.add_dependency(%q<ruport>, ["= 1.0.1"])

  s.add_dependency(%q<mongrel>, [">= 1.0.1"])
  s.add_dependency(%q<mongrel_cluster>, [">= 0.2.1"])

end
