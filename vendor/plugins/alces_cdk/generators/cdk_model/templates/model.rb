class <%= class_name %> < ActiveRecord::Base

  include Rjb

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
#
# Calculates the Tanimoto coefficient for a given pair of two fingerprint bitsets or real valued feature vectors. 
# The Tanimoto coefficient is one way to quantitatively measure the "distance" or similarity of two chemical structures.
# You can use the FingerPrinter class to retrieve two fingerprint bitsets. We assume that you have two structures stored 
# in cdk.Molecule objects. 
#
  def tanimoto(other)
    Alces::Chemistry::CDK.tanimoto( self.fingerprint , other.fingerprint )
  end
#
# Generates a Fingerprint for a given AtomContainer. Fingerprints are one-dimensional bit arrays, where bits are set according 
# to a the occurence of a particular structural feature (See for example the Daylight inc. theory manual for more information) 
# Fingerprints allow for a fast screening step to excluded candidates for a substructure search in a database. 
# They are also a means for determining the similarity of chemical structures.
#

  def fingerprint
     return @fingerprint if  @fingerprint
     @fingerprint = Alces::Chemistry::CDK.fingerprint(self.chemistry);
  end
#
# Generate a formula or used the stored formula if it exists.
# Returns the complete set of Nodes, as implied by the molecular formula, including all the hydrogens.
#
  def formula 
    calculate
    cd_formula  
  end
#
# Generate a molecular weight or used the stored version if it exists.
# returns the exact mass for a given molecular formula, using major isotope for each element.
#
  def mw
    calculate
    cd_molweight
  end
  
#
# Generate a smiles or used the stored version if it exists
#
  def smiles
    calculate
    cd_smiles 
  end
#
# Set chemistry based on smiles
#
   def smiles=(str)
    self.cd_smiles = str
    @chemistry =Alces::Chemistry::CDK.from_smiles(str,true)
    self.recalculate_chemistry_dependent_fields
  end

  def molfile
    Alces::Chemistry::CDK.to_molfile(self.chemistry)
  end   

   def molefile=(molfile)
    @chemistry =Alces::Chemistry::CDK.from_molfile(molfile)  
    self.recalculate_chemistry_dependent_fields
  end


  def analyser
    Alces::Chemistry::CDK.analyser(self.chemistry)
  end

#
# Calculate the 
#
  def calculate
    self.cd_formula   = self.analyser.getMolecularFormula() unless self.cd_formula
    self.cd_molweight = self.analyser.getCanonicalMass() unless cd_molweight
    self.cd_smiles    = Alces::Chemistry::CDK.to_smiles(self.chemistry) unless self.cd_smiles
  end
#
# The exact mass for a given molecular formula, using using IUPAC official masses published in Pure Appl.
#
  def canonical_mass
    self.analyser.getCanonicalMass()
  end
#
# The natural mass for a given molecular formula, using weighted average of isotopes.
#
  def natural_mass
    self.analyser.getNaturalMass()
  end
#
# The exact mass for a given molecular formula, using major isotope for each element.
#
  def exact_mass
    self.analyser.getNaturalMass()
  end

#
# Layout the Molecule with a rough 2D structure based on rule base
#  
  def layout_2d
    @chemistry = Alces::Chemistry::CDK.layout_2d(self.chemistry)    
  end

#
# Layout the  Molecule with a rougth 3d structure based on force field calculation
#
   def layout_3d
    @chemistry =Alces::Chemistry::CDK.layout_3d(self.chemistry)    
  end

 #
  # Convert to jpg with 
  #     filename = id.png
  #     width  = 300
  #     height = 300
  #
  def to_png(filename=nil,width= 300 , height = 300)
     filename ||= "#{id}.png"
     Alces::Chemistry::CDK.to_png(self.chemistry, filename, width, height)
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
     Alces::Chemistry::CDK.to_svg(self.chemistry, filename, width, height)
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
     Alces::Chemistry::CDK.to_jpg(self.chemistry, filename, width, height)
     return filename
  end
  
#
 # from_mol  
 #   @param molfile to load into the database
 # 
  def self.from_molfile(molfile)
    mol = self.new
    mol.molfile = molfile
    return mol      
  end  
 #
 # from_smiles  
 #   @param smiles 
 # 
  def self.from_smiles(smiles)
    mol = self.new
    mol.smiles =  smiles
    return mol
  end
  
  def chemistry
    @chemistry if @chemistry
    load_from_smiles
  end
#  end
  
protected
  def recalculate_chemistry_dependent_fields
    self.cd_formula   = analyser.getMolecularFormula()
    self.cd_molweight = analyser.getCanonicalMass()
    self.cd_smiles    = Alces::Chemistry::CDK.to_smiles(self.chemistry)
    
    fp = eval( self.fingerprint.to_string.sub("{","[").sub("}","]")  ) 
    self.cd_fp1 = fp[0]
    self.cd_fp2 = fp[1]
    self.cd_fp3 = fp[2]
    self.cd_fp4 = fp[3]
    self.cd_fp5 = fp[4]
    self.cd_fp6 = fp[5]
    self.cd_fp7 = fp[6]
    self.cd_fp8 = fp[7]
    self.cd_fp9 = fp[8]
    self.cd_fp10 = fp[9]
    self.cd_fp11 = fp[10]
    self.cd_fp12 = fp[11]
    self.cd_fp13 = fp[12]
    self.cd_fp14 = fp[13]
    self.cd_fp15 = fp[14]   
    self.cd_fp16 = fp[16]   
    self.cd_hash = self.fingerprint.hash
  end

  def load_from_smiles
    @chemistry =Alces::Chemistry::CDK.from_smiles(self.cd_smiles,true)
  end


end
