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
                   
  has_many   :batches, :dependent => :destroy
  
  #validates_uniqueness_of :name
  validates_presence_of :name

###
# @todo this will be a killer with value data sets
#
# Lookup to find Object based on a external name from a lookup
#
  def self.lookup(name)
    find(:first,:conditions=>["name = ?",name])
  end
##
# convert a id to a Object
#
  def self.reference(id)
    find(id)
  end
##
# find values like the passed name
#
  def self.like(name, limit=25, offset=0)
    find(:all,:conditions=>["name like ?","#{name}%"],:limit=>limit,:offset=>offset)
  end

  def to_s
    name
  end

  def molfile
    #data = self['mol_file']
    data ||= <<DATA

  Marvin  03210313552D

 29 28  0  0  0  0  0  0  0  0999 V2000
   -3.8125    2.6688    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -4.5270    2.2563    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -4.5270    1.4312    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -3.8125    1.0187    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -3.0980    1.4312    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -3.0980    2.2563    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -2.3836    2.6688    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -1.6691    2.2562    0.0000 C   0  0  3  0  0  0  0  0  0  0  0  0
   -0.9546    2.6687    0.0000 C   0  0  3  0  0  0  0  0  0  0  0  0
   -3.8125    0.1937    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
   -5.2414    2.6688    0.0000 N   0  3  0  0  0  0  0  0  0  0  0  0
   -5.9559    2.2562    0.0000 O   0  5  0  0  0  0  0  0  0  0  0  0
   -5.2414    3.4938    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
   -3.0980   -0.2188    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
   -4.5270   -0.2188    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
   -5.2414    1.0187    0.0000 Cl  0  0  0  0  0  0  0  0  0  0  0  0
   -2.7961    3.3832    0.0000 H   0  0  0  0  0  0  0  0  0  0  0  0
   -1.9711    3.3832    0.0000 H   0  0  0  0  0  0  0  0  0  0  0  0
   -0.2401    2.2562    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    0.4743    2.6687    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    1.1888    2.2562    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
   -1.6691    1.4312    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -0.9546    1.0187    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -0.9546    0.1937    0.0000 N   0  3  0  0  0  0  0  0  0  0  0  0
    0.0000    0.2187    0.0000 Cl  0  5  0  0  0  0  0  0  0  0  0  0
   -0.9546    3.4937    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -0.2401    3.9062    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
   -0.2401    4.7312    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
   -0.2401    5.5562    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
  1  2  1  0  0  0  0
  1  6  2  0  0  0  0
  2  3  2  0  0  0  0
  3  4  1  0  0  0  0
  4  5  2  0  0  0  0
  5  6  1  0  0  0  0
  6  7  1  0  0  0  0
  7  8  1  0  0  0  0
  8  9  1  0  0  0  0
  4 10  1  0  0  0  0
  2 11  1  0  0  0  0
 11 12  1  0  0  0  0
 11 13  2  0  0  0  0
 10 14  2  0  0  0  0
 10 15  2  0  0  0  0
  3 16  1  0  0  0  0
  7 17  1  0  0  0  0
  7 18  1  0  0  0  0
  9 19  1  0  0  0  0
 19 20  2  0  0  0  0
 20 21  1  0  0  0  0
  8 22  1  0  0  0  0
 22 23  1  0  0  0  0
 23 24  1  0  0  0  0
  9 26  1  0  0  0  0
 26 27  1  0  0  0  0
 27 28  2  0  0  0  0
 28 29  3  0  0  0  0
M  CHG  4  11   1  12  -1  24   1  25  -1
M  END
DATA
  end

  #
  # simple code for image creation
  #
  # for mol2ps see  http://merian.pch.univie.ac.at/~nhaider/cheminf/mol2ps.html
  #
  # for ps2png see latex2html utilities [ sudo apt-get install tth groff latex2html]
  #
  def image
    filename =File.join(RAILS_ROOT,"public","images",self.class.to_s,self.dom_id)
    unless File.exists?("#{filename}.png")
      FileUtils.mkdir_p(File.join(RAILS_ROOT,"public","images",self.class.to_s))
      open("#{filename}.mol","w"){|f| f << self.molfile}
      system "mol2ps #{filename}.mol > #{filename}.ps"
      system "ps2png  #{filename}.ps #{filename}.png"
    end
    return "<image src='/images/#{self.class.to_s}/#{self.dom_id}.png'>"
  rescue Exception =>ex
    logger.warn  "mol->png conversion failed #{ex.message}"
    return ""
  end
  
  protected

end
