module Helpers::Migrations
  # Extends ActiveRecord::ConnectionAdapters::SchemaStatements
  module Tables
    def self.included(base) # :nodoc:
      base.send :include, InstanceMethods
    end
    
    module InstanceMethods
      # creates all tables
      def authentasaurus_tables
        authentasaurus_user :authorizable
        authentasaurus_group
        authentasaurus_area
        authentasaurus_permission
        authentasaurus_validation
        authentasaurus_user_invitation
        authentasaurus_recovery
      end
      
      # creates users table
      def authentasaurus_user(*opts)
        create_table :users do |t|
          t.string :username, :null => false
          t.string :hashed_password, :null => false
          t.string :password_seed, :null => false
          t.string :name, :null => false
          t.string :email, :null => false
          t.boolean :active, :null => false, :default => false
          t.string :remember_me_token
          
          if opts.include?(:authorizable) || opts.include?("authorizable")
            t.integer :group_id, :null => false
          end
    
          t.timestamps
        end
      end
      
      # creates groups table
      def authentasaurus_group
        create_table :groups do |t|
          t.string :name, :null => false
    
          t.timestamps
        end
      end
      
      # creates areas table
      def authentasaurus_area
        create_table :areas do |t|
          t.string :name, :null => false
    
          t.timestamps
        end
      end
      
      # creates permissions table
      def authentasaurus_permission
        create_table :permissions do |t|
          t.integer :group_id, :null => false
          t.integer :area_id, :null => false
          t.boolean :read, :null => false, :default => false
          t.boolean :write, :null => false, :default => false
    
          t.timestamps
        end
      end
      
      # creates validations table
      def authentasaurus_validation
        create_table :validations do |t|
          t.integer :user_id, :null => false
          t.string  :user_type, :null => false
          t.string :email, :null => false
          t.string :validation_code, :null => false
    
          t.timestamps
        end
      end
      
      # creates user_invitations table
      def authentasaurus_user_invitation
        create_table :user_invitations do |t|
          t.string  :token, :null => false, :unique => true
          t.string  :email
    
          t.timestamps
        end
      end
      
      # creates recoveries table
		  def authentasaurus_recovery
		    create_table :recoveries do |t|
		      t.integer :user_id, :null => false
		      t.string  :email, :null => false
		      t.string :token, :null => false, :unique => true
		
		      t.timestamps
		    end
		  end
      
      # drops all tables
      def authentasaurus_drop_tables
        authentasaurus_drop_user
        authentasaurus_drop_group
        authentasaurus_drop_area
        authentasaurus_drop_permission
        authentasaurus_drop_validation
        authentasaurus_drop_user_invitation
        authentasaurus_drop_recovery
      end
      
      # drops users table
      def authentasaurus_drop_user
        drop_table :users
      end
      
      # drops groups table
      def authentasaurus_drop_group
        drop_table :groups
      end
      
      # drops areas table
      def authentasaurus_drop_area
        drop_table :areas
      end
      
      # drops permissions table
      def authentasaurus_drop_permission
        drop_table :permissions
      end
      
      # drops validations table
      def authentasaurus_drop_validation
        drop_table :validations
      end
      
      # drops user_invitations table
      def authentasaurus_drop_user_invitation
        drop_table :user_invitations
      end
      
      # drops recoveries table
      def authentasaurus_drop_recovery
        drop_table :recoveries
      end
    end
  end
  
  # Extends ActiveRecord::ConnectionAdapters::TableDefinition
  module Columns
    def self.included(base) # :nodoc:
      base.send :include, InstanceMethods
    end
    
    module InstanceMethods
      def user(*opts)
        string :username, :null => false
        string :hashed_password, :null => false
        string :password_seed, :null => false
        string :name, :null => false
        string :email, :null => false
        string :remember_me_token
        boolean :active, :null => false, :default => false
        if opts.include?(:authorizable)
          integer :group_id, :null => false
        end
      end
    end
  end
end