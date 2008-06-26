require File.dirname(__FILE__) + '/../test_helper'
require 'gnuplot'
class ChartTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def test_chart
		Gnuplot.open do |gp|
			Gnuplot::Plot.new( gp ) do |plot|
				plot.set('terminal', 'svg' )
				plot.set('output','c:\graph1.svg')
			  
				plot.xrange "[-10:10]"
				plot.title  "Sin Wave Example"
				plot.ylabel "x"
				plot.xlabel "sin(x)"
				
				plot.data << Gnuplot::DataSet.new( "sin(x)" ) do |ds|
					ds.with = "lines"
					ds.linewidth = 4
				end			
			end
		end
  end
   
end
