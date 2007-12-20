class Project::SignaturesController < ApplicationController
  def sign(sig) 
    sig.asset.title=params[:title].shift[0]
    sig.asset.filename=params[:filename].shift[0]
    sig.signer=params[:user]
    sig.generate_checksum
    sig.public_key=params[:public_key]
    sig.signature_state='SIGNED'
    sig.save!
    redirect_to :controller=>'folders', :action=>'show', :id=>params[:id]
  end
  
  def sign_as_author
    sign(AuthorSignature.new)
  end
  
  def sign_as_witness
     sign(WitnessSignature.new)
  end
end
