module Authentasaurus::Models
  module Recovery
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      
      base.send :require, "digest/sha1"
      
      base.send :unloadable
      
      base.send :belongs_to, :user
      
    	base.send :before_validation, :make_token!, :on => :create
    	base.send :before_save, :send_recovery
      
    	base.send :scope, :valid, lambda { { :conditions => ["updated_at <= ?", Rails.application.config.authentasaurus[:modules][:recoverable][:token_expires_after].days.from_now] } }
      
    	base.send :validates_uniqueness_of, :user_id
    	base.send :validates_presence_of, :email
    	base.send :validates_presence_of, :user_id, :message => :"recovery.user_id.blank"
    	base.send :validates_format_of, :email, :with => %r{[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}}
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def make_token!
    		self.token = Digest::SHA1.hexdigest "#{Time.now.to_i} #{rand} #{self.email}"
      end
      
      def send_recovery
    		AuthentasaurusEmailer.deliver_recovery_mail(self.user, self.token) if Rails.application.config.authentasaurus[:modules][:recoverable][:send_email]
      end
    end
  end
end