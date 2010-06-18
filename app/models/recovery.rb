require "digest/sha1"

class Recovery < ActiveRecord::Base
	belongs_to :user
	
	before_validation_on_create :make_token!
	before_save :send_recovery
	
	named_scope :valid, lambda { { :conditions => ["updated_at <= ?", AUTHENTASAURUS_CONFIGURATIONS[:modules][:recoverable][:token_expires_after].days.from_now] } }
	
	validates_uniqueness_of :user_id
	validates_presence_of :email
	validates_presence_of :user_id, :message => :"recovery.user_id.blank"
	validates_format_of :email, :with => %r{[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}}
	
	
	def make_token!
		self.token = Digest::SHA1.hexdigest "#{Time.now.to_i} #{rand} #{self.email}"
	end
	
	def send_recovery
		AuthentasaurusEmailer.deliver_recovery_mail(self.user, self.token)
	end
end
