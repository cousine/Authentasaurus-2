class AuthentasaurusEmailer < ActionMailer::Base
  def validation_mail(name, email, validation_code, sent_at = Time.now)
    subject    'Validate your account'
    recipients email
    from       'no-reply@your-domain.com' # dont forget to change me
    sent_on    sent_at
    
    body       :name => name, :vcode => validation_code
    content_type "text/html"
  end
  
  def recovery_mail(user, token, sent_at = Time.now)
    subject    'Recover your password'
    recipients user.email
    from       'no-reply@your-domain.com' # dont forget to change me
    sent_on    sent_at
    
    body       :name => user.name, :token => token
    content_type "text/html"
  end
end
