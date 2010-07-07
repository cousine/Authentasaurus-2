# This class represents a session model, a session authenticates a username and a password.
#
# A session behaves just like an ActiveRecord model
class Authentasaurus::Models::Session
  attr_accessor :username, :password, :remember
  attr_accessor :errors
  attr_reader :user
  
  # Takes a hash of attributes keys and values just like ActiveRecord models
  def initialize(attributes = nil)
    self.errors = ActiveRecord::Errors.new(self)
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
      @user = type.to_s.camelize.constantize.authenticate(self.username, self.password)
      if @user.nil?
        self.errors.add_to_base I18n.t(:invalid_login, :scope => [:authentasaurus, :messages, :sessions]) 
        ret &= false
      else
        @user.create_remember_me_token if self.remember == "1"
        ret = true
        break
      end
    end
    ret
  end
  
  # Takes a hash of attributes keys and values just like new and authenticates the information.
  # Returns true or false
  def self.create(*attrs)
    attributes = attrs.extract_options!
    attrs = attrs.flatten
    self_obj = self.new attributes
    self_obj.save(attrs)
    return self_obj
  end
  
  def new_record? #:nodoc:
    true
  end
  
  # Takes an id (usually from an ActiveController session) and returns a User object
  def self.current_user(id, session_type = :user)
    session_type.to_s.camelize.constantize.find id
  end
end