class AuthentasaurusEmailer < ActionMailer::Base
  def validation_mail(name, email, validation_code, sent_at = Time.now)
    subject    Rails.application.config.authentasaurus[:modules][:validatable][:mail_subject]
    recipients email
    from       Rails.application.config.authentasaurus[:modules][:validatable][:mail_from]
    sent_on    sent_at
    
    body       :name => name, :vcode => validation_code
    content_type "text/html"
  end
  
  def recovery_mail(user, token, sent_at = Time.now)
    subject    Rails.application.config.authentasaurus[:modules][:recoverable][:mail_subject]
    recipients user.email
    from       Rails.application.config.authentasaurus[:modules][:recoverable][:mail_from] # dont forget to change me
    sent_on    sent_at
    
    body       :name => user.name, :token => token
    content_type "text/html"
  end
  
  def invitation_mail(email, token, sent_at = Time.now)
    subject   Rails.application.config.authentasaurus[:modules][:invitable][:mail_subject]
    recipients email
    from       Rails.application.config.authentasaurus[:modules][:invitable][:mail_from]
    sent_on    sent_at
    
    body       :token => token
    content_type "text/html"
  end
end
