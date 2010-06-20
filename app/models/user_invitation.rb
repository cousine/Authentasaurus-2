require 'digest/sha1'
class UserInvitation < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email, :scope => :token
  validates_format_of :email, :with => %r{[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}}
  
  before_validation :create_token
  #send email
  after_create :send_invitation

  def send_invitation
    AuthentasaurusEmailer.deliver_invitation_mail(self.email, self.token) if AUTHENTASAURUS[:modules][:invitable][:send_email]
  end
  
  private
  def create_token
    return if self.email.nil? || self.email.blank?
    string_to_hash=self.email + "invitable.olation" + self.email.hash.to_s
		self.token = Digest::SHA1.hexdigest(string_to_hash)
  end
end
