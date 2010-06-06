module Migrations
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
      end
      
      # creates users table
      def authentasaurus_user?(*opts)
        create_table :users do |t|
          t.string :username, :null => false
          t.string :hashed_password, :null => false
          t.string :password_seed, :null => false
          t.string :name, :null => false
          t.string :email, :null => false
          t.boolean :active, :null => false, :default => false
          
          if opts.include?(:authorizable)
            t.integer :group_id, :null => false
            t.string :group_type, :null => false
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
          t.boolean :read, :null => false
          t.boolean :write, :null => false
    
          t.timestamps
        end
      end
      
      # creates validations table
      def authentasaurus_validation
        create_table :validations do |t|
          t.integer :user_id, :null => false
          t.string :validation_code, :null => false
    
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
    end
  end
  
  # Extends ActiveRecord::ConnectionAdapters::TableDefinition
  module Columns
    def self.included(base) # :nodoc:
      base.send :include, InstanceMethods
    end
    
    module InstanceMethods
      def user
        string :username, :null => false
        string :hashed_password, :null => false
        string :password_seed, :null => false
        string :name, :null => false
        string :email, :null => false
        boolean :active, :null => false, :default => false
        integer :group_id, :null => false
  
        timestamps
      end
    end
  end
end