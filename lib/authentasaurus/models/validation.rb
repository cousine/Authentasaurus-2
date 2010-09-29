module Authentasaurus::Models
  module Validation
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      
      base.send :belongs_to, :user, :polymorphic => true
      
      # Check that everything is there
      base.send :validates_presence_of, :user_id, :validation_code, :user_type, :email
      # Check foreign keys
      base.send :validates_associated, :user
      # Check unique user
      base.send :validates_uniqueness_of, :user_id, :scope => [:user_type, :email]
      base.send :validates_uniqueness_of, :validation_code
      
      #send email
      base.send :after_create, :send_validation
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def send_validation
        AuthentasaurusEmailer.deliver_validation_mail(self.user.name, self.email, self.validation_code) if AUTHENTASAURUS[:modules][:validatable][:send_email]
      end
    end
  end
end
