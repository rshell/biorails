require File.dirname(__FILE__) + '/../test_helper'
require 'gnuplot'
class DataElementsTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def test_chart
		Gnuplot.open do |gp|
			Gnuplot::Plot.new( gp ) do |plot|
				plot.set ('terminal', 'svg' )
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
  
#  
#  def  xyplot(x,y, options={})
#		Gnuplot.open do |gp|
#			Gnuplot::Plot.new( gp ) do |plot|
#				plot.set ('terminal', options[:format] || 'svg' )
#				plot.set('output', options[:filename] ||' graph1.svg')
#			  
#				plot.title   options[:title] || 'x//y plot'
#				plot.ylabel   options[:ylabel] ||"y"
#				plot.xlabel  options[:xlabel]||'x'
#				
#				plot.data << Gnuplot::DataSet.new( [x,y]) do |ds|
#					ds.with = "linespoints"
#					ds.title = "Array data"
#					ds.linewidth = 4
#				end			
#			end
#		end
#  end
    
#def ic50plot(x,y)
##   options={:hill=>1,:min=>0,:max=>100,:pIC50=>1})
#		BioPlot.open do |gp|
#			BioPlot::Plot.new( gp ) do |plot|
#				plot.terminal options[:format] || 'svg' )
#				plot.output     options[:filename] ||' fit.svg')
#				plot.key  'bmargin center horizontal Right noreverse enhanced autotitles nobox'
#				plot.title "fitted to realistic model function" 
#				plot.xlabel "Temperature T  [deg Cels.]" 
#				plot.ylabel "Density [g/cm3]" 
###
##  Add function fitting
##				
#				plot.var ' l(x) = y0 + m*x'
#				plot.var  'high(x) = mh*(x-Tc) + dens_Tc'
#				plot.var  'lowlin(x)  = ml*(x-Tc) + dens_Tc'
#				plot.var  'curve(x) = b*tanh(g*(Tc-x))'
#				plot.var  'density(x) = x < Tc ? curve(x)+lowlin(x) : high(x)'
#				plot.var  'y0 = 1.0686507417645'
#				plot.var  'm = -0.000943519626916798'
#				plot.var  'FIT_CONVERGED = 1'
#				plot.var  'FIT_NDF = 31'
#				plot.var  'FIT_STDFIT = 5.38883632122203e-05'
#				plot.var  'FIT_WSSR = 9.00226263804574e-08'
#				plot.var  'ml = -0.00100003889377295'
#				plot.var  'mh = -0.000831266485032402'
#				plot.var  'dens_Tc = 1.02497044445616'
#				plot.var  'Tc = 46.0899249399594'
#				plot.var  'g = 3.85580365359622'
#				plot.var  'b = 0.00153901455761662'
#				plot.fit  'density(x)', 'lcdemo.dat' via 'start.par'
###
##			     f(x) = a*x**2 + b*x + c
##     g(x,y) = a*x**2 + b*y**2 + c*x*y
##     FIT_LIMIT = 1e-6
##     fit f(x) 'measured.dat' via 'start.par'
##     fit f(x) 'measured.dat' using 3:($7-5) via 'start.par'
##     fit f(x) './data/trash.dat' using 1:2:3 via a, b, c
##     fit g(x,y) 'surface.dat' using 1:2:3:(1) via a, b, c
##		
##				plot 'lcdemo.dat', density(x)
##plot.fit density(x) 'lcdemo.dat' via 'start.par'
#end
#
#	
# def test_chart2
#   Gnuplot.open do |gp|
#		Gnuplot::Plot.new( gp ) do |plot|
#  			plot.set ('terminal', 'png' )
#			plot.set('output','c:\graph2.png')
#			plot.xrange "[-10:10]"
#			plot.title  "Sin Wave Example"
#			plot.ylabel "x"
#			plot.xlabel "sin(x)"
#    
#			x = (0..50).collect { |v| v.to_f }
#			y = x.collect { |v| v ** 2 }
#
#			plot.data = [
#				Gnuplot::DataSet.new( "sin(x)" ) { |ds|
#					ds.with = "lines"
#					ds.title = "String function"
#					ds.linewidth = 4
#				},
#			
#				Gnuplot::DataSet.new( [x, y] ) { |ds|
#					ds.with = "linespoints"
#					ds.title = "Array data"
#				}
#			]
#		end
#	end    
# end
   
end
