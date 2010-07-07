module ActiveRecord::Authenticatable
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def authenticatable(*args)
      options = args.extract_options!
      args = args.flatten
      # Associations
      belongs_to :group
      has_many :permissions, :through => :group
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
      validates_confirmation_of :new_password, :on => :update, :unless => :new_password_blank?
      validates_length_of :new_password, :minimum => 6, :on => :update, :unless => :new_password_blank?
      # format of password
      if args.include?(:strong_password)
        validates_format_of :password, :with => %r{[a-z]}, :on => :create, :message => :"authenticatable.lower_case_password"
        validates_format_of :password, :with => %r{[A-Z]}, :on => :create, :message => :"authenticatable.upper_case_password"
        validates_format_of :password, :with => %r{[0-9]}, :on => :create, :message => :"authenticatable.digit_password"
        validates_format_of :password, :with => %r{[@$%!&]}, :on => :create, :message => :"authenticatable.symbol_password"
        # new password
        validates_format_of :new_password, :with => %r{[a-z]}, :on => :update, :message => :"authenticatable.lower_case_password", :unless => :new_password_blank?
        validates_format_of :new_password, :with => %r{[A-Z]}, :on => :update, :message => :"authenticatable.upper_case_password", :unless => :new_password_blank?
        validates_format_of :new_password, :with => %r{[0-9]}, :on => :update, :message => :"authenticatable.digit_password", :unless => :new_password_blank?
        validates_format_of :new_password, :with => %r{[@$%!&]}, :on => :update, :message => :"authenticatable.symbol_password", :unless => :new_password_blank?
      end
      
      # Accessors
      attr_accessor :password_confirmation, :new_password_confirmation
      
      # dont delete admin
      before_destroy :dont_delete_admin
      
      #validation
      if args.include?(:validatable)
        has_one :validation, :as => :user
        before_create :create_validation
        # include authentication methods including validation
        include ActiveRecord::ActsAsAuthenticatableValidatable
      else
        # include authentication methods
        include ActiveRecord::ActsAsAuthenticatable
      end
    end
  end
end