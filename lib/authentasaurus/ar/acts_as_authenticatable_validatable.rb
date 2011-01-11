module Authentasaurus::Ar
  module ActsAsAuthenticatableValidatable
    extend ActiveSupport::Concern
    
    included do      
      include ActsAsAuthenticatable
    end
    
    module ClassMethods
      ## Authenticates the username (or email) and password
      def authenticate(username_or_email, password, remember = false)
        user=self.find_by_username(username_or_email) || self.find_by_email(username_or_email)
        if user
          expected_password=encrypt_password(password, user.password_seed)
          unless expected_password == user.hashed_password && user.active && user.validation.nil?    
            user = nil 
          else
            user.create_remember_me_token if remember
          end
        end
        return user
      end
    end
    
    private
    def send_validation
      unless self.active
				validation = self.build_validation(:email => self.email, :validation_code => User.encrypt_password(self.username,self.password_seed))
        unless validation.save
					raise "Could not create validation record"
        end
      end
    end
  end    
end