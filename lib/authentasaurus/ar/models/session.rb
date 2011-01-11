# This class represents a session model, a session authenticates a username and a password.
#
# A session behaves just like an ActiveRecord model
module Authentasaurus::Ar::Models
  module Session
    extend ActiveSupport::Concern
    
    included do # :nodoc:      
      include ActiveModel::Validations
      include ActiveModel::Conversion
      
      attr_accessor :username, :password, :remember
      validates_presence_of :username, :password
      
      attr_reader :user
    end
    
    module ClassMethods
      # Takes a hash of attributes keys and values just like new and authenticates the information.
      # Returns true or false
      def create(*attrs)
        attributes = attrs.extract_options!
        attrs = attrs.flatten
        self_obj = self.new attributes
        self_obj.save(attrs)
        return self_obj
      end
      
      # Takes an id (usually from an ActiveController session) and returns a User object
      def current_user(id, session_type = Authentasaurus::Configuration.instance.user_model.to_sym)
        session_type.to_s.camelize.constantize.find id
      end
    end
        
    # Takes a hash of attributes keys and values just like ActiveRecord models
    def initialize(attributes = nil)        
      if attributes
        attributes.each do |key,value|
          send(key.to_s + '=', value)
        end
      else
        self.remember = false
      end
    end
    
    # Authenticates the information saved in the attributes
    # Returns true or false
    def save(*session_types)
      session_types = session_types.flatten
      
      if session_types.empty?
        user_model = Authentasaurus::Configuration.instance.user_model.to_sym
        session_types = [user_model]
      end
      
      ret = true
      session_types.each do |type|
        @user = type.to_s.camelize.constantize.authenticate(self.username.downcase, self.password, self.remember == "1")
        if @user.nil?
          self.errors.add_to_base I18n.t(:invalid_login, :scope => [:authentasaurus, :messages, :sessions]) 
          ret &= false
        else
          ret = true
          break
        end
      end
      ret
    end
    
    def new_record? #:nodoc:
      true
    end
    
    def persisted? #:nodoc:
      false
    end
  end  
end