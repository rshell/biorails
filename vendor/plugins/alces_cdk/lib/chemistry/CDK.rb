# =============================================
# The Chemistry Development Kit Inteface
# =============================================
#
# This provides the standard features needed
# to implement chemical awareness with the CDK library
#
# Searching
#     sss     true is this is subgraph
#     match   true is molecules are then same
#
# Fingerprints
#     fingerprint  generate finderprint
#     subset       fingerprint screen passed for sss
#     tanimoto     how simular are molecules
#
# Calculation
#     formula
#     canonical_mass
#     natural_mass
#     exact_mass
#
# Layout
#    Layout_2d
#    Layout_3d
#
# Conversions
#     to_smiles
#     from_smiles
#     to_molfile
#     from_molecule
#     read(data,format)
#     write(format)
#     to_png
#     to_jpg
#     to_svg
#
module Alces
  
  # Convenience methods for working with the CDK.
  module Chemistry
    
    # Molecular language translation. Currently molfile, SMILES,
    # and IUPAC nomenclature (read-only) are implemented.
    class CDK
   
      # Tests if other a subgraph of self.
      # 
      def self.sss(source,query)
        qry =  Org::Openscience::Cdk::Isomorphism::Matchers::QueryAtomContainerCreator.createBasicQueryContainer(query)
        Org::Openscience::Cdk::Isomorphism::UniversalIsomorphismTester.isSubgraph(source,qry)
      end
      #
      # Tests if self and other are isomorph.
      #
      def self.match(source,query)
        query =  Org::Openscience::Cdk::Isomorphism::Matchers::QueryAtomContainerCreator.createBasicQueryContainer(other.chemistry)
        Org::Openscience::Cdk::Isomorphism::UniversalIsomorphismTester.isIsomorph(self.chemistry,query)
      end
      #
      # Tests fingerprint of other is a subset of self
      #  
      def self.subset(fp1,fp2)
        Org::Openscience::Cdk::Fingerprint::FingerprinterTool.isSubset(fp1.fp2)
      end
      #
      # Calculates the Tanimoto coefficient for a given pair of two fingerprint bitsets or real valued feature vectors. 
      # The Tanimoto coefficient is one way to quantitatively measure the "distance" or similarity of two chemical structures.
      # You can use the FingerPrinter class to retrieve two fingerprint bitsets. We assume that you have two structures stored 
      # in cdk.Molecule objects. 
      #
      def self.tanimoto(fp1,fp2)
        @@tanimoto ||= Org::Openscience::Cdk::Similarity::Tanimoto.new
        Org::Openscience::Cdk::Similarity::Tanimoto.calculate(fp1 , fp2)
      end
      #
      # Generates a Fingerprint for a given AtomContainer. Fingerprints are one-dimensional bit arrays, where bits are set according 
      # to a the occurence of a particular structural feature (See for example the Daylight inc. theory manual for more information) 
      # Fingerprints allow for a fast screening step to excluded candidates for a substructure search in a database. 
      # They are also a means for determining the similarity of chemical structures.
      #
      def self.fingerprint(molecule, size = 1024)
          @@fingerprinter ||= Org::Openscience::Cdk::Fingerprint::Fingerprinter.new 
          @@fingerprinter.getFingerprint(molecule);
      end
     
      def self.analyser(molecule)
         Org::Openscience::Cdk::Tools::MFAnalyser.new(molecule)        
      end
      #
      # Generate a formula or used the stored formula if it exists.
      # Returns the complete set of Nodes, as implied by the molecular formula, including all the hydrogens.
      #      
      def self.formula(molecule)
        analyser(molecule).getMolecularFormula()
      end
      #
      # The exact mass for a given molecular formula, using using IUPAC official masses published in Pure Appl.
      #
      def self.canonical_mass(molecule)
        analyser(molecule).getCanonicalMass()
      end
      #
      # The natural mass for a given molecular formula, using weighted average of isotopes.
      #
      def self.natural_mass(molecule)
        analyser(molecule).getNaturalMass()
      end
      #
      # The exact mass for a given molecular formula, using major isotope for each element.
      #
      def self.exact_mass(molecule)
        analyser(molecule).getNaturalMass()
      end
      #
      # Create a molecule from a smiles
      #
      def self.from_smiles(str, layout =false)
        @@smiles_parser  ||= Org::Openscience::Cdk::Smiles::SmilesParser.new
        molecule = @@smiles_parser.parseSmiles(str)    
        molecule = layout_2d(molecule) if layout
        return molecule
        
      end
      #
      # Generate a smiles code from the structure
      #
      def self.to_smiles(molecule,chiral =false)
        @@smiles_generator ||= Org::Openscience::Cdk::Smiles::SmilesGenerator.new()
        if chiral
           @@smiles_generator.createChiralSMILES(molecule)
        else      
           @@smiles_generator.createSMILES(molecule)
        end
      end
  
      #
      # Generate Molfile from molecule
      #  
      def self.to_molfile(molecule)
        @@mdl_writer   ||= Org::Openscience::Cdk::Io::MDLWriter.new
        writer = Java::Io::StringWriter.new
        @@mdl_writer.setWriter(writer)
        @@mdl_writer.writeMolecule(molecule)
        @@mdl_writer.close
        writer.toString
      end   
    
      def self.from_molefile(molfile)
        @@mdl_reader ||= Org::Openscience::Cdk::Io::MDLReader.new    
        reader = Java::Io::StringReader.new(molfile)
        @@mdl_reader.setReader(reader  )
        @@mdl_reader.read(Org::Openscience::Cdk::Molecule.new)   
      end

      
      # Returns a CDK <tt>Molecule</tt> given the specified <tt>iupac_name</tt>.
      def self.from_iupac(iupac_name)
        nts = Uk::Ac::Cam::Ch::Wwmm::Opsin::NameToStructureNameToStructure.getInstance
        cml = nts.parseToCML(iupac_name)
        
        raise "Couldn't parse #{iupac_name}." unless cml
        
        string_reader = Java::Io::StringReader.new(cml.toXML)
        
        @@cml_reader = Org::Openscience::Cdk::Io::CMLReader.new unless @@cml_reader
        @@cml_reader.setReader(string_reader)
        
        chem_file = @@cml_reader.read(ChemFile.new)
        chem_file.getChemSequence(0).getChemModel(0).getSetOfMolecules.getMolecule(0)
      end
     
      #e
      # Layout the Molecule with a rough 2D structure based on rule base
      #  
      def self.layout_2d(molecule)
        @@structure_diagram_generator ||= Org::Openscience::Cdk::Layout::StructureDiagramGenerator.new
        @@structure_diagram_generator.setMolecule(molecule)
        @@structure_diagram_generator.generateCoordinates();
        @@structure_diagram_generator.getMolecule()
      end
      
      #
      # Layout the  Molecule with a rougth 3d structure based on force field calculation
      #
      def self.layout_3d(molecule)
        @@model_builder_3d ||= Org::Openscience::Cdk::Modeling::Builder3d::ModelBuilder3D.getInstance()
        @@model_builder_3d.generate3DCoordinates(molecule, false);
      end
    
       #
       # Convert to jpg with 
       #     filename = id.png
       #     width  = 300
       #     height = 300
       #
      def self.to_png(molecule, filename='molecule.png',width= 300 , height = 300)
         Net::Sf::Structure::Cdk::Util::ImageKit.writePNG(molecule, width, height, filename)
         return filename
      end
    
      #
      # Convert to svg with 
      #     filename = id.svg 
      #     width  = 300
      #     height = 300
      #
      def self.to_svg(molecule,filename='molecule.svg',width= 300 , height = 300)
         Net::Sf::Structure::Cdk::Util::ImageKit.writeSVG(molecule, width, height, filename)
         return filename
      end
      #
      # Convert to jpg with 
      #     filename = id.jpg 
      #     width  = 300
      #     height = 300
      #
      def self.to_jpg(molecule,filename = 'molecule.jpg',width= 300 , height = 300)
         Net::Sf::Structure::Cdk::Util::ImageKit.writeJPG(molecule, width, height, filename)
         return filename
      end

    end
  end
end