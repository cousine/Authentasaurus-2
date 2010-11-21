# This class represents a session model, a session authenticates a username and a password.
#
# A session behaves just like an ActiveRecord model
module Authentasaurus::Ar::Models
  module Session
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      base.send :include, ActiveModel::Validations
      base.send :include, ActiveModel::Conversion
      
      base.send :attr_accessor, :username, :password, :remember
      base.send :validates_presence_of, :username, :password
      base.send :attr_reader, :user
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
      def current_user(id, session_type = :user)
        session_type.to_s.camelize.constantize.find id
      end
    end
    
    module InstanceMethods
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
          session_types = [:user]
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
end