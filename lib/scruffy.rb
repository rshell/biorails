# ===Scruffy Graphing Library for Ruby
#
# Author:: Brasten Sager
# Date:: August 5th, 2006
#
# For information on generating graphs using Scruffy, see the
# documentation in Scruffy::Graph.
#
# For information on creating your own graph types, see the
# documentation in Scruffy::Layers::Base.
# 
# This code is currently a branch of the 0.2.2 release as a play with adding a number of new graph types
#  Series
#  * Candle eg min,max,avg,errr
#  * high,low,close
#  * custom point types
#    
#  2D
#  * Line 
#  * Dots 
#  * Functions
#  
#  Maps
#  * HeatMap  x by y grid with rects
#  * PlateMap x by y grid with cicles
#  
#  
module Scruffy; end


$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  
require 'rubygems'
require_gem 'builder', '>= 2.0'

require 'scruffy/helpers'
require 'scruffy/graph'
require 'scruffy/themes'
require 'scruffy/version'
require 'scruffy/formatters'
require 'scruffy/rasterizers'
require 'scruffy/layers'
require 'scruffy/components'
require 'scruffy/renderers'