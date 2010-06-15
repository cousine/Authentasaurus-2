require "digest/sha1"

class Recovery < ActiveRecord::Base
	belongs_to :user
	
	before_validation_on_create :make_token!
	before_save :send_recovery
	
	def make_token!
		self.token = Digest::SHA1.hexdigest "#{Time.now.to_i} #{rand} #{self.user.email}"
	end
	
	def send_recovery
		AuthentasaurusEmailer.deliver_recovery_mail(self.user, self.token)
	end
end
