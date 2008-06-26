# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class Notification < ActionMailer::Base
  
    def witness_request(signature, sent_at = Time.now)
      
     @subject    = 'Please witness this signature'
     @body['signature']       = signature
     @recipients = signature.signer.email
     @from       = signature.creator.email
     @sent_on    = sent_at
     @headers    = {}
     part :content_type => "text/html", :body => render_message("witness_request", :signature => signature)  
     attachment :content_type =>"application/pdf",:body => File.read(signature.file_full_path)
   end

    
   def signature_witnessed(signature, sent_at = Time.now)
     @subject    = 'Please witness this signature'
     @body['signature']       = signature
     @recipients = signature.creator.email
     @from       = signature.signer.email
     @sent_on    = sent_at
     @headers    = {}
     part :content_type => "text/html", :body => render_message("signature_witnessed", :signature => signature)  
  end
    
  def signature_refused(signature, sent_at = Time.now)
     @subject    = 'Your request for a witness signature has been refused'
     @body['signature']       = signature
     @recipients = signature.creator.email
     @from       = signature.signer.email
     @sent_on    = sent_at
     @headers    = {}
     part :content_type => "text/html", :body => render_message("signature_refused", :signature => signature)  
  end
  
  def excessive_login_failures(user, sent_at = Time.now)
     @subject    = 'Exceede limit of number of failed login attempts'
     @body['user']       = user
     @recipients = user.email
     @from       = user.email
     @sent_on    = sent_at
     @headers    = {}
     part :content_type => "text/html", :body => render_message("excess_login_failures", :user => user)  
    
  end
end
