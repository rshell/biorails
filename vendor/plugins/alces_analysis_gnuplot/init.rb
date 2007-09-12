# Include a require hook to each of the analysis methods class you want to define
# Each should provide the following interfaces
#
#
#  class.new(task,analysis_method) => object
#  class.setup => default analysis_method definition
#  object.run => true/false
#  object.to_html => report on the results on the analysis
#
require 'alces_plot_xy'
require 'alces_dummy'
#
# Registor as a processing methods into Biorails
# 
AnalysisMethod.add_processor(Alces::Processor::PlotXy)
AnalysisMethod.add_processor(Alces::Processor::Dummy)
