# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class Notification < ActionMailer::Base
  
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
