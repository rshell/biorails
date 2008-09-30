##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights 
##

class SignaturesController < ApplicationController

  use_authorization :project,
                    :actions => [:list,:show,:new,:update],
                    :rights =>  :current_user
  

  def list
     @title = "Signed documents in project #{current_project.name}" 
     @project_folder = current_element
     @signatures = Signature.find_signed_for_project(current_project.id)
    respond_to do |format|
      format.html {render :action => 'list'}
    end
  end





  def user
     @title = "Published documents in project #{current_project.name}" 
     @project_folder = current_element
     @signatures = Signature.find_published_for_project(current_project.id)
     render :action=>'list'
   end
    
   def published
     @title = "Published documents in project #{current_project.name}" 
     @project_folder = current_element
     @signatures = Signature.find_published_for_project(current_project.id)
     render :action=>'list'
   end
   
    
  def list_witnessed
     @user = User.find(params[:id]) if params[:id]
     @user ||= current_user
     @project_folder = current_element
     @title = "Documents witnessed by user #{@user.name}" 
     @signatures = Signature.find_witness_by(@user.id)
     render :action=>'list'
   end
   
   def list_pending
     @user = User.find(params[:id]) if params[:id]
     @user ||= current_user
     @project_folder = current_element
     @title = "Documents pending witnessing by user #{@user.name}" 
     @signatures = Signature.find_pending_witness_by(@user.id)
     render :action=>'list'
   end

   def list_waiting
     @user = User.find(params[:id]) if params[:id]
     @user ||= current_user
     @project_folder = current_element
     @title = "Documents by user #{@user.name} waiting witness" 
     @signatures = Signature.find_pending_witness_for(@user.id)
     render :action=>'list'
   end
   
   def list_authored
     @user = User.find(params[:id]) if params[:id]
     @user ||= current_user
     @project_folder = current_element
     @title = "Documents Authored by #{@user.name}" 
     @signatures = Signature.find_authored_by(@user.id)
    render :action=>'list'
   end
   
  def show_related
    sig=Signature.find(params[:id])
    @signatures=sig.related
    @project_name=sig.project.name 
    @element_name=sig.project_element.name
    render :action=> "signatures"
  end
    
  def show
    unless params[:id]
       flash[:warning]='Must specify id for what you want to verify'
       return redirect_to( :controller=>'folders', :action=>'show', :id=>current_element)
    end
    @project_folder = set_element(params[:id])
    @signatures=Signature.find(:all,:conditions=>['project_element_id=?',params[:id]],
                :order=>"signature_state desc,signed_date desc")
    @status = nil
    @signature= nil
    if params[:signature_id]
        @signature=Signature.find(params[:signature_id])
        @status = @signature.verify_the_digest
        if @status
          flash.now[:notice]= "This signature is a valid signature of #{@signature.project_element.path} and was signed by #{@signature.signer.name}"
        elsif @status.nil?
          flash.now[:warning]='The signature cannot be validated because generated PDF file is missing'
        else
          flash.now[:error]='The signature could not be verified'
        end   
    end    
    render :action=> "show"
  end

  
  # create a pdf and zipped tarball of the contents and display a form for signature  
  def new
    unless params[:id]
       flash[:warning]='Must specify id for what you want to sign'
       return redirect_to( :controller=>'folders', :action=>'show', :id=>ProjectFolder.current)
    end
    if current_user.email.blank?
       flash[:warning]='You cannot sign a document without a valid email address'
       return redirect_to( :controller=>'folders', :action=>'show', :id=>params[:id])
    end
    @project_folder = set_element(params[:id])
    @signature = @project_folder.sign
    @root = @signature.make_files_for_signing 
     
    render(:action=>'new',:layout=>'dialog')  
  end
  #
  # Save the signatures 
  #
  def sign
    unless params[:id]
       flash[:warning]='Must specify id for what you want to sign'
       return redirect_to( :controller=>'folders', :action=>'show', :id=>params[:id])
    end
    @project_folder = set_element(params[:id])
    @signature = @project_folder.sign(params[:signature])
    if current_user.email.blank?
       flash[:warning]='You cannot sign a document without a valid email address'
       return render(:action=>:new)
    end
    if params[:password].blank?
       flash[:warning]='You cannot sign a document without password'       
      return render(:action=>:new)
    end
    if !User.login(current_user.login,params[:password])
       flash[:warning]='Wrong Password can not sign document'       
       return render(:action=>:new)
    end
    
    if params[:submit]== "Sign"

      @signature.public_key = current_user.public_key.export
      @signature.create_sig
      @witness=User.find(params[:witness])
      @signature.witness_by_request( @witness)if @witness   
      flash[:notice]="Document awaiting witness by #{@witness.name}"
      
    end
    redirect_to :controller=>'folders', :action=>'show', :id=>params[:id]
  end

  
  #get the pdf of the document and display it, along with a form for the chosen witness to sign
  def abandon
    unless params[:id]
       flash[:warning]='Must specify id for what you want to see'
       return redirect_to( :controller=>'folders', :action=>'show', :id=>current_element)
    end
    @signature=Signature.find(params[:id])        
    @project_folder = set_element(@signature.project_element_id)
    return render(:action=>:abandon,:layout=>'dialog')    
  end


  #get the pdf of the document and display it, along with a form for the chosen witness to sign
  def witness
    unless params[:id]
       flash[:warning]='Must specify id for what you want to witness'
       return redirect_to( :controller=>'folders', :action=>'show', :id=>current_element.id)
    end
    if current_user.email.blank?
       flash[:warning]='You cannot sign a document without a valid email address'
       return redirect_to( :controller=>'folders', :action=>'show', :id=>current_element.id)
    end
    @signature=Signature.find(params[:id]) 
    @project_folder = set_element(@signature.project_element_id)
    if current_user.id ==  @signature.created_by_user_id
       flash[:warning]='You witness signatures you created user for'
       return redirect_to( :controller=>'folders', :action=>'show', :id=>@project_folder.id)
    end
    return render(:action=>:witness,:layout=>'dialog')    
  end
  
  
#
# Act of a witness response
# 
def update
  Signature.transaction do
    unless params[:id]
       flash[:warning]='Must specify id for what you want to witness'
       return redirect_to( :controller=>'folders', :action=>'show', :id=>current_element)
    end
    @signature=Signature.find(params[:id])
    @project_folder = set_element(@signature.project_element_id)

    if params[:password].blank?
       flash[:warning]='You cannot sign a document without password'       
       return render(:action=>:witness)
    end
    
    if current_user.email.blank?
       flash[:warning]='You cannot sign a document without a valid email address'
       return render(:action=>:witness)
    end
    
    if !User.login(current_user.login,params[:password])
       flash[:warning]='Wrong Password can not sign document'       
       return render(:action=>:witness)
    end
   
      case params[:submit]
        when "Witness" 
           @signature.signed(params[:signature][:comments])
           flash[:notice]="Signature on #{@project_folder.name} witnesed"
         
        when "Refuse" 
           @signature.refused_request(params[:signature][:comments])
           flash[:notice]="Signature on #{@project_folder.name} refused"

       when "Abandon" 
           @signature.abandon(params[:signature][:comments])
           flash[:notice]="Signature on #{@project_folder.name} abandoned"
        else
           flash[:warning]="Unknown actions #{params[:submit]}"
          
      end   
      return redirect_to( :controller=>'folders', :action=>'show', :id=>@signature.project_element_id)
   end
  end
  
 
end
