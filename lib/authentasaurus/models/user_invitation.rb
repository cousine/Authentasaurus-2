module Authentasaurus::Models
  module UserInvitation
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      
      base.send :require, 'digest/sha2'
      base.send :validates_presence_of, :email
      base.send :validates_uniqueness_of, :email, :scope => :token
      base.send :validates_format_of, :email, :with => %r{[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}}
      
      base.send :before_validation, :create_token
      #send email
      base.send :after_create, :send_invitation
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def send_invitation
        AuthentasaurusEmailer.deliver_invitation_mail(self.email, self.token) if Rails.application.config.authentasaurus[:modules][:invitable][:send_email]
      end
      
      private
      def create_token
        return if self.email.nil? || self.email.blank?
        string_to_hash=self.email + "invitable.olation" + self.email.hash.to_s
    		self.token = Digest::SHA2.hexdigest(string_to_hash)
      end
    end
  end
end
