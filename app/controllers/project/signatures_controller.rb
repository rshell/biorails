class Project::SignaturesController < ApplicationController
  def sign(sig) 
    sig.title=params[:title].shift[0]
    sig.signer=params[:user]
    sig.generate_checksum
    sig.public_key=params[:public_key]
    sig.signature_state='SIGNED'
    sig.project_element=ProjectElement.find(params[:id])
    sig.filename=params[:filename].shift[0]
    sig.save!
    redirect_to :controller=>'folders', :action=>'show', :id=>params[:id]
  end
  
  def sign_as_author
    sign(AuthorSignature.new)
  end
  
  def sign_as_witness
     sign(WitnessSignature.new)
  end
  
  def index
    @project = current_project
    Dir.glob("public/documents/*") do |doc|
      if doc.match('project_folder-' << current_project.id.to_s)
        p doc
        p File.ctime(doc)
        p File.mtime(doc)
        
      end
      
    end
  end
end
