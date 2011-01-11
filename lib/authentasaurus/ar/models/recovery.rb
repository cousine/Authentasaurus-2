module Authentasaurus::Ar::Models
  module Recovery
    extend ActiveSupport::Concern
    
    included do
      require "digest/sha1"
      
      unloadable
      
      belongs_to :user
      
    	before_validation :make_token!, :on => :create
      before_save :send_recovery
      
    	scope :valid, lambda { { :conditions => ["updated_at <= ?", Authentasaurus::Configuration.instance.configuration[:modules][:recoverable][:token_expires_after].days.from_now] } }
      
    	validates_uniqueness_of :user_id
    	validates_presence_of :email
    	validates_presence_of :user_id, :message => :"recovery.user_id.blank"
    	validates_format_of :email, :with => %r{[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}}
    end
    
    module ClassMethods
    end
        
    def make_token!
      self.token = Digest::SHA1.hexdigest "#{Time.now.to_i} #{rand} #{self.email}"
    end
    
    def send_recovery
  		AuthentasaurusEmailer.deliver_recovery_mail(self.user, self.token) if Authentasaurus::Configuration.instance.configuration[:modules][:recoverable][:send_email]
    end
  end    
end