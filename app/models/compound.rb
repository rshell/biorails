# == Schema Information
# Schema version: 280
#
# Table name: compounds
#
#  id                 :integer(11)   not null, primary key
#  name               :string(50)    default(), not null
#  description        :text          
#  formula            :string(50)    
#  mass               :float         
#  smiles             :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_by_user_id :integer(32)   default(1), not null
#  created_at         :datetime      not null
#  updated_by_user_id :integer(32)   default(1), not null
#  updated_at         :datetime      not null
#  registration_date  :datetime      
#  iupacname          :string(255)   default()
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Compound < ActiveRecord::Base

  attr_accessor :chemistry
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
  acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
                              :description=>{:store=>:yes,:boost=>0},
                               }, 
                   :default_field => [:name],           
                   :single_index => true, 
                   :store_class_name => true 
                   
  has_many   :batches, :dependent => :destroy
  
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :registration_date

  
#
# Overide context_columns to remove all the internal system columns.
# 
  def self.content_columns
        @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(lock_version|_by|_at|_id|_count)$/ || c.name == inheritance_column }
  end

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
# Generate a smiles or used the stored version if it exists
#

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
    self.formula   = self.analyser.getMolecularFormula() unless self.formula
    self.mass      = self.analyser.getCanonicalMass() unless self.mass
    self.smiles    = Alces::Chemistry::CDK.to_smiles(self.chemistry) unless self.smiles
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
    compound = self.new
    compound.molfile = molfile
    compound.smiles  = Alces::Chemistry::CDK.to_smiles(compound.chemistry) 
    compound.formula = compound.analyser.getMolecularFormula() 
    compound.mass    = compound.analyser.getCanonicalMass()
    return mol      
  end  
 #
 # from_smiles  
 #   @param smiles 
 # 
  def self.from_smiles(smiles)
    compound = self.new
    compound.smiles  =  smiles
    compound.formula = compound.analyser.getMolecularFormula() 
    compound.mass    = compound.analyser.getCanonicalMass()
    return compound
  end
  
  def chemistry
    @chemistry if @chemistry
    load_from_smiles
  end
  
#  end
  
protected
  def recalculate_chemistry_dependent_fields
    self.formula   = analyser.getMolecularFormula()
    self.molweight = analyser.getCanonicalMass()
    self.smiles    = Alces::Chemistry::CDK.to_smiles(self.chemistry)    
  end

  def load_from_smiles
    @chemistry =Alces::Chemistry::CDK.from_smiles(self.smiles,true)
  end

end
