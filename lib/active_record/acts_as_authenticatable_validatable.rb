module ActiveRecord::ActsAsAuthenticatableValidatable
  def self.included(base)
    base.send :extend, ActiveRecord::ActsAsAuthenticatable::ClassMethods
    base.send :include, ActiveRecord::ActsAsAuthenticatable::InstanceMethods
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end
  
  module ClassMethods
    ## Authenticates the username and password
    def authenticate(username, password)
      user=self.find_by_username username
      if user
        expected_password=encrypt_password(password, user.password_seed)
        user = nil unless expected_password == user.hashed_password && user.active && user.validation.nil?    
      end
      return user
    end
  end
  
  module InstanceMethods
    private
		def create_validation
			unless self.active
				validation = Validation.new(:user => self, :email => self.email, :validation_code => User.encrypt_password(self.username,self.password_seed))
				unless validation.save
					raise "Could not create validation record"
				end
			end
		end
  end
end