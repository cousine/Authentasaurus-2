# This class represents a session model, a session authenticates a username and a password.
#
# A session behaves just like an ActiveRecord model
class Session
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
    end
  end
  
  # Authenticates the information saved in the attributes
  # Returns true or false
  def save
    @user = User.authenticate(self.username, self.password)
    self.errors.add_to_base I18n.t(:invalid_login, :scope => [:authentasaurus, :active_record, :errors, :messages]) if @user.nil?
    !@user.nil?
  end
  
  # Takes a hash of attributes keys and values just like new and authenticates the information.
  # Returns true or false
  def self.create(attributes = nil)
    self_obj = self.new attributes
    self_obj.save
  end
  
  def new_record? #:nodoc:
    true
  end
end