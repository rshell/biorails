require 'rubygems'
require 'rcdk'

jrequire 'java.io.StringReader'
jrequire 'java.io.StringWriter'
jrequire 'org.openscience.cdk.io.MDLWriter'
jrequire 'org.openscience.cdk.io.MDLReader'
jrequire 'org.openscience.cdk.smiles.SmilesParser'
jrequire 'org.openscience.cdk.smiles.SmilesGenerator'
jrequire 'org.openscience.cdk.DefaultChemObjectBuilder'
jrequire 'org.openscience.cdk.Molecule'
jrequire 'org.openscience.cdk.layout.StructureDiagramGenerator'
jrequire 'org.openscience.cdk.modeling.builder3d.ModelBuilder3D'
jrequire 'org.openscience.cdk.graph.invariant.MorganNumbersTools'
jrequire 'org.openscience.cdk.isomorphism.UniversalIsomorphismTester'
jrequire 'org.openscience.cdk.fingerprint.Fingerprinter'
# cdk 1.0.1 jrequire 'org.openscience.cdk.fingerprint.FingerprinterTool'
jrequire 'org.openscience.cdk.similarity.Tanimoto'
jrequire 'org.openscience.cdk.isomorphism.matchers.QueryAtomContainerCreator'
jrequire 'org.openscience.cdk.tools.MFAnalyser'
jrequire 'org.openscience.cdk.io.CMLReader'
jrequire 'org.openscience.cdk.ChemFile'
jrequire 'net.sf.structure.cdk.util.ImageKit'
jrequire 'uk.ac.cam.ch.wwmm.opsin.NameToStructure'

class Molecule < ActiveRecord::Base
  set_primary_key :cd_id
  attr_accessor :chemistry
#
# Tests if other a subgraph of self.
# 
  def sss(other)
    query =  Org::Openscience::Cdk::Isomorphism::Matchers::QueryAtomContainerCreator.createBasicQueryContainer(other.chemistry)
    Org::Openscience::Cdk::Isomorphism::UniversalIsomorphismTester.isSubgraph(self.chemistry,query)
  end
#
# Tests if self and other are isomorph.
#
  def match(other)
    query =  Org::Openscience::Cdk::Isomorphism::Matchers::QueryAtomContainerCreator.createBasicQueryContainer(other.chemistry)
    Org::Openscience::Cdk::Isomorphism::UniversalIsomorphismTester.isIsomorph(self.chemistry,query)
  end
#
# Tests fingerprint of other is a subset of self
#  
  def subset(other)
    Org::Openscience::Cdk::Fingerprint::FingerprinterTool.isSubset(self.fingerprint,other.fingerprint)
  end

  def tanimoto(other)
    @@tanimoto ||= Org::Openscience::Cdk::Similarity::Tanimoto.new
    Org::Openscience::Cdk::Similarity::Tanimoto.calculate(self.fingerprint,other.fingerprint)
  end

  def fingerprint(size = 1024)
    @@fingerprinter ||= Org::Openscience::Cdk::Fingerprint::Fingerprinter.new 
    @@fingerprinter.getFingerprint(self.chemistry);
  end

  def formula 
    cd_formula  
  end
  
  def mw
    cd_molweight
  end
  
  def smiles
    cd_smiles
  end
  
  def find_exact(query)
    chemistry.match_by_ullmann(query)
  end
  
  def find_similar(query)
    
  end
#
# Calculate the 
#
  def recalculate
    analyser = Org::Openscience::Cdk::Tools::MFAnalyser.new(self.chemistry)
    self.cd_formula = analyser.getMolecularFormula()
    self.cd_molweight = analyser.getCanonicalMass()
  end
#
# The exact mass for a given molecular formula, using using IUPAC official masses published in Pure Appl.
#
  def canonical_mass
    analyser = Org::Openscience::Cdk::Tools::MFAnalyser.new(self.chemistry)
    analyser.getCanonicalMass()
  end
#
# The natural mass for a given molecular formula, using weighted average of isotopes.
#
  def natural_mass
    analyser = Org::Openscience::Cdk::Tools::MFAnalyser.new(self.chemistry)
    analyser.getNaturalMass()
  end
#
# The exact mass for a given molecular formula, using major isotope for each element.
#
  def exact_mass
    analyser = Org::Openscience::Cdk::Tools::MFAnalyser.new(self.chemistry)
    analyser.getNaturalMass()
  end


  def morgan_numbers  
    @@morgan_numbers_tools ||= Org::Openscience::Cdk::Graph::Invarient::MorganNumbersTools.new
    @@morgan_numbers_tools.getMorganNumbers(sef.chemistry)
  end


  def to_smiles
    @@smiles_generator ||= Org::Openscience::Cdk::Smiles::SmilesGenerator.new(DefaultChemObjectBuilder.getInstance)
    @@smiles_generator.createSMILES(self.chemistry)
  end
  
  
  def to_molfile
    @@mdl_writer       ||= Org::Openscience::Cdk::Io::MDLWriter.new
    writer = StringWriter.new
    @@mdl_writer.setWriter(writer)
    @@mdl_writer.writeMolecule(self.chemistry)
    @@mdl_writer.close
    writer.toString
  end   
#
# Layout the Molecule with a rough 2D structure based on rule base
#  
  def layout_2d
    @@structure_diagram_generator ||= Org::Openscience::Cdk::Layout::StructureDiagramGenerator.new
    @@structure_diagram_generator.setMolecule(self.chemistry)
    @@structure_diagram_generator.generateCoordinates();
    @chemistry = @@structure_diagram_generator.getMolecule()
  end

#
# Layout the  Molecule with a rougth 3d structure based on force field calculation
#
   def layout_3d
    @@model_builder_3d ||= Org::Openscience::Cdk::Modeling::Builder3d::ModelBuilder3D.getInstance()
    @chemistry = @@model_builder_3d.generate3DCoordinates(self.chemistry, false);
  end

 #
  # Convert to jpg with 
  #     filename = id.png
  #     width  = 300
  #     height = 300
  #
  def to_png(filename=nil,width= 300 , height = 300)
     filename ||= "#{id}.png"
     Net::Sf::Structure::Cdk::Util::ImageKit.writePNG(self.chemistry, width, height, filename)
     return filename
  end

  #
  # Convert to svg with 
  #     filename = id.svg 
  #     width  = 300
  #     height = 300
  #
  def to_svg(filename=nil,width= 300 , height = 300)
     filename ||= "#{id}.svg"
     Net::Sf::Structure::Cdk::Util::ImageKit.writeSVG(self.chemistry, width, height, filename)
     return filename
  end
  #
  # Convert to jpg with 
  #     filename = id.jpg 
  #     width  = 300
  #     height = 300
  #
  def to_jpg(filename=nil,width= 300 , height = 300)
     filename ||= "#{id}.jpg"
     Net::Sf::Structure::Cdk::Util::ImageKit.writeJPG(self.chemistry, width, height, filename)
     return filename
  end
  
#
 # from_mol  
 #   @param molfile to load into the database
 # 
  def self.from_molfile(molfile)
    @@mdl_reader   ||= Org::Openscience::Cdk::Io::MDLReader.new
    reader = StringReader.new(molfile)       
    @@mdl_reader.setReader(reader)
    mol = self.new
    mol.chemistry = @@mdl_reader.read(Org::Openscience::Cdk::Molecule.new)   
    return mol      
  end  
 #
 # from_smiles  
 #   @param smiles 
 # 
  def self.from_smiles(smiles)
    @@smiles_parser    ||= Org::Openscience::Cdk::Smiles::SmilesParser.new
    mol = self.new
    mol.cd_smiles = smiles
    mol.chemistry =  @@smiles_parser.parseSmiles(smiles)  
    mol.recalculate
    mol.layout_2d
    return mol
  end

  #
  # As a local in memory chemistry object to play with
  #
  def chemistry
    @chemistry unless @chemistry
    @@smiles_parser    ||= Org::Openscience::Cdk::Smiles::SmilesParser.new
    @chemistry =  @@smiles_parser.parseSmiles(self.cd_smiles)     
    self.layout_2d
    
  end
  
  
end
