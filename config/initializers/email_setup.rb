ActionMailer::Base.smtp_settings = {
  :tls => true,
  :address => 'smtp.gmail.com',
  :port => '587',
  :domain => 'biorails.org',
  :authentication => :plain,
  :user_name => 'demo@biorails.org',
  :password => 'smtp!123456'
 }
    