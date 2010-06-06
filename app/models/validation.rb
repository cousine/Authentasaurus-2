class Validation < ActiveRecord::Base
  belongs_to :user
  
  # Check that everything is there
  validates_presence_of :user_id, :validation_code
  # Check foreign keys
  validates_associated :user
  # Check unique user
  validates_uniqueness_of :user_id, :validation_code

  #send email
  after_create :send_validation

  private
  def send_validation
    validation_emailer.validation_mail(self.user.name, self.user.email, self.validation_code)
  end
end
