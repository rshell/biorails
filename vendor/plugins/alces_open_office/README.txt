= Alces::OpenOffice

This is utility wrapper arround open office functions

Home:: http://biorails.org
Copyright:: 2009, Robert Shell

== LICENSE NOTES

Please read the LICENCE.txt file for licensing information on this
library.

== USAGE

1) Document conversion

To to this simply create a coverter for the required output format like
doc,html,pdf etc. Then send this files to convert

  require "open_office"

  converter = Alces::OpenOffice::FormatConverter.new("html")
  output_filename = converter.convert(source_filename)

If the output_filename is nil then the errors collection may be used to
work out what when wrong as follows :-

  puts converter.errors.join("\n")


2) Templated output

This uses erb to convert a template to completed document

  template = Alces::OpenOffice::DocumentTemplate.new("template.odt")

  list = template.variables
  template.set(name,value)
  template.get(name)
  document = template.run

3) Formatter


  template = Alces::OpenOffice::DocumentFormater.new("source.html","format.odt","pdf")

== NOTES
