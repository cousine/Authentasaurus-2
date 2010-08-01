class Authentasaurus::Models::ValidationModel < ActiveRecord::Base
  belongs_to :user, :polymorphic => true
  
  # Check that everything is there
  validates_presence_of :user_id, :validation_code, :user_type, :email
  # Check foreign keys
  validates_associated :user
  # Check unique user
  validates_uniqueness_of :user_id, :scope => [:user_type, :email]
  validates_uniqueness_of :validation_code

  #send email
  after_create :send_validation

  def send_validation
    AuthentasaurusEmailer.deliver_validation_mail(self.user.name, self.email, self.validation_code) if AUTHENTASAURUS[:modules][:validatable][:send_email]
  end
end
