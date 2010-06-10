require 'active_record/acts_as_authenticatable'
module Authenticatable
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def authenticatable(options = {})
      # Associations
      belongs_to :group
      has_many :permissions, :through => :groups
      # Validation
      # basic attributes
      validates_presence_of :username, :hashed_password, :password_seed, :email, :name
      validates_uniqueness_of :username, :email
      validates_format_of :email, :with => %r{[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}}
      # password validations
      validates_confirmation_of :password, :on => :create
      validates_presence_of :password, :on => :create
      validates_length_of :password, :minimum => 6, :on => :create
      # new password
      validates_confirmation_of :new_password, :on => :update, :unless => :new_password?
      validates_length_of :new_password, :minimum => 6, :on => :update, :unless => :new_password?
      # format of password
      if options[:strong_password]
        validates_format_of :password, :with => %r{[a-z]}, :on => :create
        validates_format_of :password, :with => %r{[A-Z]}, :on => :create
        validates_format_of :password, :with => %r{[0-9]}, :on => :create
        validates_format_of :password, :with => %r{[@$%!&]}, :on => :create
        # new password
        validates_format_of :new_password, :with => %r{[a-z]}, :on => :update, :unless => :new_password?
        validates_format_of :new_password, :with => %r{[A-Z]}, :on => :update, :unless => :new_password?
        validates_format_of :new_password, :with => %r{[0-9]}, :on => :update, :unless => :new_password?
        validates_format_of :new_password, :with => %r{[@$%!&]}, :on => :update, :unless => :new_password?
      end
      # Accessors
      attr_accessor :password_confirmation, :new_password_confirmation
      # include authentication methods
      include ActsAsAuthenticatable
      # dont delete admin
      before_destroy :dont_delete_admin
    end
    
    def authenticatable_with(strong_password, *options)
      authenticatable(:strong_password => strong_password)
      if options.include?(:validation)
        has_one :validation, :as => :user
        before_create :create_validation
      end
    end
  end
end