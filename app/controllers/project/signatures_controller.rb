class Project::SignaturesController < ApplicationController
  def sign 
    @sig.asset.title=params[:title]
    @sig.asset.filename=params[:filename]
    @sig.signer=params[:user]
    @sig.generate_checksum
    @sig.public_key=params[:public_key]
    @sig.save!
  end
  
  def sign_as_author
    @sig=AuthorSignature.new
    sign
  end
  
  def sign_as_witness
    @sig=WitnessSignature.new
    sign
  end
end
