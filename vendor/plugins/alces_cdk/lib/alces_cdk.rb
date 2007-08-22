##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
# This is licenced under GNU 2.0 lience to match the CDK library
# it is dependent upon
#
# The initial idea for this code came from http://rubyforge.org/projects/rcdk 
# and pieces on http://depth-first.com . In the end ended up with a reimplementation
# for CDK 1.0 and changes to create generate for rails models based for 
# chemical aware objects. Big change with= this library is covers basic
# structure operaitons SSS, Match, Fingerprint so a simple example registration
# system can be built with it.  
# 
# 
# 
#

gem 'rjb'
require 'rjb'
require 'chemistry/java'
require 'chemistry/CDK'

Dir[ File.join(File.dirname(__FILE__),'java/*.jar').to_s ].each  do |file|
  require_jar File.join(file)
end

jrequire 'java.io.StringReader'
jrequire 'java.io.StringWriter'
jrequire 'org.openscience.cdk.io.MDLWriter'
jrequire 'org.openscience.cdk.io.MDLReader'
jrequire 'org.openscience.cdk.smiles.SmilesParser'
jrequire 'org.openscience.cdk.smiles.SmilesGenerator'
jrequire 'org.openscience.cdk.DefaultChemObjectBuilder'
jrequire 'org.openscience.cdk.Molecule'
jrequire 'org.openscience.cdk.graph.invariant.MorganNumbersTools'
jrequire 'org.openscience.cdk.layout.StructureDiagramGenerator'
jrequire 'org.openscience.cdk.modeling.builder3d.ModelBuilder3D'
jrequire 'org.openscience.cdk.isomorphism.UniversalIsomorphismTester'
jrequire 'org.openscience.cdk.fingerprint.Fingerprinter'
jrequire 'org.openscience.cdk.fingerprint.FingerprinterTool'
jrequire 'org.openscience.cdk.similarity.Tanimoto'
jrequire 'org.openscience.cdk.isomorphism.matchers.QueryAtomContainerCreator'
jrequire 'org.openscience.cdk.tools.MFAnalyser'
jrequire 'org.openscience.cdk.io.CMLReader'
jrequire 'org.openscience.cdk.ChemFile'
jrequire 'net.sf.structure.cdk.util.ImageKit'
jrequire 'uk.ac.cam.ch.wwmm.opsin.NameToStructure'


