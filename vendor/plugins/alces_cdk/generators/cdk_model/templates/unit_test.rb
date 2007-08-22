require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../test_helper'

class <%= class_name %>Test < Test::Unit::TestCase
  fixtures :<%= table_name %>

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
    def test001_find
    mol = Molecule.find(:first)
    assert mol.mw
    assert mol.formula
    assert mol.smiles    
  end

  def test002_tanimoto
    mol1 = Molecule.find(1)
    mol2 = Molecule.find(2)    
    assert mol1.tanimoto(mol2) < 1.0
    assert mol1.tanimoto(mol1) == 1.0
  end

  def test003_match
    mol1 = Molecule.find(1)
    mol2 = Molecule.find(2)
    assert !mol1.match(mol2)    
    assert mol1.match(mol1)    
  end

  def test004_sss
    mol1 = Molecule.find(1)
    mol2 = Molecule.find(2)
    assert !mol1.sss(mol2)    
    assert mol1.sss(mol1)    
  end


  def test005_parse_smiles
    entries = []
    smiles_tests =  [
      "C", 
     "[Au]", 
      "[235U]",
      "CC",
      "CCC",
      "C=O",
      "C=CC=C",
      "C#N",
      "CC(C)C(=O)O",
      "O=Cl(=O)(=O)[O-]", # Cl(=O)(=O)(=O)[O-]
      "CCCC(C(=O)O)CCC", # 4-heptanoic acid
      # Ring
     "C1CCCCC1", # Cyclohexane
      "C1=CCCCC1", # cyclohexene
      "c12c(cccc1)cccc2", # naphthalene
      "c1ccccc1c2ccccc2", # biphenyl 
      "C12C3C4C1C5C4C3C25", # Cubane
      # Isotopic specification
      "[C]", # elemental carbon
      "[12C]", # elemental carbon-12
      "[13C]", # elemental carbon-13
      "[13CH4]", # C-13 methane
      # Specifying double-bond configuration
      'F/C=C/F', # trans-difluoroethene
      'F\C=C\F', # trans-difluoroethene
      'F/C=C\F', # cis-difluoroethene
      'F\C=C/F', # cis-difluoroethene
      # Specifying tetrahedral chirality
      "N[C@@H](C)C(=O)O", # L-alanine
      "N[C@H](C)C(=O)O", # D-alanine
      "O[C@H]1CCCC[C@H]1O", # cis-resorcinol
      "C1C[C@H]2CCCC[C@H]CC1", #cis-decaline
      # http://pubchem.ncbi.nlm.nih.gov/summary/summary.cgi?cid=043383,niaid
      "C1=CC2=C3C(=C1)C=CC4=C3C(=CC5=C4[C@H]([C@H](C=C5)O)O)C=C2",
      "NC(Cc1c[nH]c2cc[Se]c12)C(O)=O", # pointed out by Dr. ktaz
    ]
    smiles_tests.each do |smiles|
      entries.push(Molecule.from_smiles(smiles))
    end  
    assert SMILES.size == entries.size
  end
  
  def test006_masses
    molecule = Molecule.from_smiles("CC")
    assert (( molecule.mw - 24.0214 ).abs < 0.001) , "mass was #{molecule.mw}"
  end

  def test007_molfile
    molecule = Molecule.from_smiles("C1=CC2=C3C(=C1)C=CC4=C3C(=CC5=C4[C@H]([C@H](C=C5)O)O)C=C2")
    assert molecule.molfile
  end

  def test008_to_png
    molecule = Molecule.from_smiles("C1=CC2=C3C(=C1)C=CC4=C3C(=CC5=C4[C@H]([C@H](C=C5)O)O)C=C2")
    assert molecule.to_png("test.png") 
  end

  def test009_to_svg
    molecule = Molecule.from_smiles("C1=CC2=C3C(=C1)C=CC4=C3C(=CC5=C4[C@H]([C@H](C=C5)O)O)C=C2")
    assert molecule.to_svg("test.svg") 
  end

  def test010_to_jpg
    molecule = Molecule.from_smiles("C1=CC2=C3C(=C1)C=CC4=C3C(=CC5=C4[C@H]([C@H](C=C5)O)O)C=C2")
    assert molecule.to_jpg("test.jpg") 
  end

 def test011_layout_2d
    molecule = Molecule.from_smiles("C1=CC2=C3C(=C1)C=CC4=C3C(=CC5=C4[C@H]([C@H](C=C5)O)O)C=C2")
    assert molecule.layout_2d
  end

 def test012_layout_3d
    molecule = Molecule.from_smiles("C1=CC2=C3C(=C1)C=CC4=C3C(=CC5=C4[C@H]([C@H](C=C5)O)O)C=C2")
    assert molecule.layout_3d
  end


end
