module Authentasaurus::Ar
  module ActsAsAuthenticatable
    extend ActiveSupport::Concern
    
    module ClassMethods
      case Authentasaurus::Configuration.instance.hashing
      when "SHA2"
        require 'digest/sha2'
      when "SHA1"
        require 'digest/sha1'
      when "MD5"
        require 'digest/md5'
      else
        require 'digest/sha2'
      end
      
      
      ## Authenticates the username (or email) and password
      def authenticate(username_or_email, password, remember = false)
        user=self.find_by_username(username_or_email) || self.find_by_email(username_or_email)
        if user
          expected_password=encrypt_password(password, user.password_seed)
          unless expected_password == user.hashed_password && user.active
            user = nil 
          else
            user.create_remember_me_token if remember
          end
        end
        return user
      end
      
      ## Encrypts the password using the given seed
      def encrypt_password(password, password_seed)
  			pass_to_hash=password + "Securasaurus" + password_seed
        
        case Authentasaurus::Configuration.instance.hashing
        when "SHA2"
          Digest::SHA2.hexdigest(pass_to_hash)
        when "SHA1"
          Digest::SHA1.hexdigest(pass_to_hash)
        when "MD5"
          Digest::MD5.hexdigest(pass_to_hash)
        else
          Digest::SHA2.hexdigest(pass_to_hash)
        end
        
      end
    end
    
    def username=(username)      
      super(username.downcase)
    end
      
    ## Password attribute (used when creating a user)
    def password
      return @password
    end
    
    def password=(pwd)
      @password = pwd
      return if pwd.blank?
      create_salt
      self.hashed_password = self.class.encrypt_password(@password, self.password_seed)
    end
    
    ## New password attribute (used when editing a user)
    def new_password
      return @new_password
    end
    
    def new_password=(pwd)
      @new_password = pwd
      return if pwd.blank?
      create_salt
      self.hashed_password = self.class.encrypt_password(@new_password, self.password_seed)
    end
    
    def activate
      self.update_attribute :active, true
    end
    
    def deactivate
      self.update_attribute :active, false
    end
    
    def create_remember_me_token
      pass_to_hash=Time.now.to_i.to_s + "Securasaurus" + password_seed
      self.update_attribute :remember_me_token, Digest::SHA1.hexdigest(pass_to_hash)
      self.remember_me_token
    end
    
    private
    def new_password_blank? 
			self.new_password.blank?
    end
    
		## Creates password seed (salt)
    def create_salt
			self.password_seed = self.object_id.to_s + rand.to_s
    end
    
		## Dont delete the last user
    def dont_delete_admin
		  raise "You cannot delete the last admin" if self.id == 1 || User.count == 1
    end
  end  
end