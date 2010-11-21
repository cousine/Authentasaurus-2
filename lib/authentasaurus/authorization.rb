# =Authorization Helpers
# The authorization module provides helpers for restricting access to your controllers.
# 
# Each controller is considered an area in Authentasaurus, for example UsersController stands for
# "users" area. Each area must be defined in the Areas table so Authentasaurus can control access
# to it.
#
# Authentasaurus provides a simple rake task to define areas automatically:
#
#  rake authentasaurus:create_areas
#
# == Restricting Access
# You can restrict access to any controller using one of the following class methods on your 
# controller.
# 
# At login, Authentasaurus will load the permissions of the group the user belongs to in the session
# and will use them to authorize access to the area.
#
# There are three levels of restriction in Authentasaurus, login, read and write; with the exception
# of login, read and write don't have any logic behind them; they are defined using the Permission and
# are only symbolically named i.e.: you can use read instead of write and vice versa it only depends on
# how you use them.
#
# === Restricting access to logged in users
# You can restrict access to an area to logged in users only using the ActionController::ClassMethods#require_login
# class method.
#
# Consider the following example restricting access to the pages controller to only logged in users:
#
#   class PagesController < ActionController::Base
#     require_login
#     ... 
#   end
#
# You can also specify which actions to restrict:
#
#   require_login :new, :create, :index
#
# Authentasaurus will automatically redirect users to the sign-in page if they try accessing the area 
# while they are not logged in. Once the user logs in he/she is redirected back to his/her original destination 
# unless you explicitly skip that behaviour:
#
#   require_login :skip_request => true
#
# === Restricting access according to permissions
# Unlike the login restriction, permissions restrictions checks if the user is logged in and has 
# the permission to access the area.
#
# Users get permissions from their parent group and permissions are dynamically set in the database.
#
# Authentasaurus currently supports only two permissions, read and write, both permissions are 
# symbolically named, they have no meaning.
#
# ==== Restricting access to users with read permission
#
#   class PagesController < ActionController::Base
#     require_read
#     ...
#   end
#
# ActionController::ClassMethods#require_read takes the same options as ActionController::ClassMethods#require_login
# and ActionController::ClassMethods#require_write
#
# ==== Restricting access to users with write permission
#
#   class PagesController < ActionController::Base
#     require_write
#     ...
#   end
#
# ActionController::ClassMethods#require_write takes the same options as ActionController::ClassMethods#require_login 
# and ActionController::ClassMethods#require_read
#
# == Checking if the user is logged in in actions or views
# Along with the class helpers, Authentasaurus includes a helper to check if the user is logged in
# inside any of your actions:
#
#   is_logged_in?
#
# Check ActionController::CommonInstanceMethods#is_logged_in? for more information.
#
# == Checking permissions in actions or views
# You can also check if the logged in user has a certain permission.
#
# Consider the following example to check if the logged in user has read permission on the current
# area
#
#   has?(:read)
#
# You can also check permissions on an area while in another, for example to check if the current 
# user has write permission on the users area:
#
#   has?(:write,:users)
#
# Check ActionController::CommonInstanceMethods#has? for more information.
#
# == Retrieving the current user in actions or views
# To get the logged in user you can use the following helper:
#
#   current_user
#
# Check ActionController::CommonInstanceMethods#current_user for more information.
module Authentasaurus::Authorization
  module CommonInstanceMethods
    # Returns an object of the current user
    #
    # <b>Parameters:</b>
    #   
    #   user_model  - The model class representing a user (User by default)
    def current_user(user_model = nil)#:doc:
      user_model = User if user_model.nil?
      return user_model.find session[:user_id] if session[:user_id]
    end
    
    # Checks if the current user has the appropriate permission
    # 
    # <b>ex</b>: 
    #    has?(:write) or has?(:read, :users)
    #
    # <b>Parameters:</b>
    #   
    #   permission  - The permission to check, either :read or :write
    #   area        - The area to check the permission on, by default checks the current area.
    def has?(permission, area = nil) #:doc:
      return false unless is_logged_in?
      check = false
      case permission
      when :write
        unless area
          user_permissions = session[:user_permissions]
          check = user_permissions[:write].find { |perm| perm==self.controller_name || perm=="all" }
        else
          user_permissions = session[:user_permissions]
          check = user_permissions[:write].find { |perm| perm==area.to_s || perm=="all" }
        end
      when :read
        unless area
          user_permissions = session[:user_permissions]
          check = user_permissions[:read].find { |perm| perm==self.controller_name || perm=="all" }
        else
          user_permissions = session[:user_permissions]
          check = user_permissions[:read].find { |perm| perm==area.to_s || perm=="all" }
        end
      end
      return check
    end
          
    # Checks if the current user is logged in but takes no further action
    #
    # <b>Parameters:</b>
    #   
    #   user_model  - The model class representing a user (User by default)
    def is_logged_in?(user_model = nil) #:doc:
      user_model = User if user_model.nil?
      unless user_model.find_by_id(session[:user_id])
        return cookie_login?(user_model)
      end
			return true
    end
  end
  
  module ActionController
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
      
      # Requires the user to login before accessing the actions specified
      # 
      # <b>ex:</b> Tells Authentasaurus that the action destroy requires login and that Authentasaurus
      # shouldn't store the request in the session (typically for logout actions).
      # 
      #   require_login :destroy, :skip_request => true
      #
      # <b>Options</b>
      #
      #   :skip_request - skips saving the original request (to redirect to after login)
      #   :user_model   - if defined, authentasaurus will use that model instead of the default "User"
      #   :if           - specifies a method, proc or string to call to determine if the authorization should occur
      #   :unless       - specifies a method, proc or string to call to determine if the authorization should not occur
      def require_login (*attrs)
        options = attrs.extract_options!.symbolize_keys
        attrs = attrs.flatten
        
        unless attrs.empty?
          before_filter :only => attrs, :if => options[:if], :unless => options[:unless] do |controller|
    		    controller.instance_eval {check_logged_in !options[:skip_request].nil?, options[:user_model]}
          end
        else
          before_filter :if => options[:if], :unless => options[:unless] do |c| 
    			  c.instance_eval {check_logged_in !options[:skip_request].nil?, options[:user_model]}
          end
        end
      end
      
      # Requires the user to have a write permission to that area to access the actions specified
      # 
      # <b>ex:</b> Tells Authentasaurus that the actions create_user and delete_user requires login and write 
      # permission.
      # 
      #   require_write :create_user, :delete_user
      #
      # <b>Options</b>
      #
      #   :skip_request - skips saving the original request (to redirect to after login)
      #   :user_model   - if defined, authentasaurus will use that model instead of the default "User"
      #   :if           - specifies a method, proc or string to call to determine if the authorization should occur
      #   :unless       - specifies a method, proc or string to call to determine if the authorization should not occur
      def require_write(*attrs)
        options = attrs.extract_options!.symbolize_keys
        attrs = attrs.flatten
        
        
        unless attrs.empty?
          before_filter :only => attrs, :if => options[:if], :unless => options[:unless] do |controller|
    			  controller.instance_eval { check_write_permissions !options[:skip_request].nil?, options[:user_model] }
          end
        else
          before_filter :if => options[:if], :unless => options[:unless] do |c| 
    			  c.instance_eval {check_write_permissions !options[:skip_request].nil?, options[:user_model]}
          end
        end
      end
      
      # Requires the user to have a read permission to that area to access the actions specified
      # 
      # <b>ex:</b> Tells Authentasaurus that the action show_user requires login and read permission.
      # 
      #   require_read :show_user
      #   
      # <b>Options</b>
      #
      #   :skip_request - skips saving the original request (to redirect to after login)
      #   :user_model   - if defined, authentasaurus will use that model instead of the default "User"
      #   :if           - specifies a method, proc or string to call to determine if the authorization should occur
      #   :unless       - specifies a method, proc or string to call to determine if the authorization should not occur
      def require_read(*attrs)
        options = attrs.extract_options!.symbolize_keys
        attrs = attrs.flatten
        
        unless attrs.empty?
          before_filter :only => attrs, :if => options[:if], :unless => options[:unless] do |controller|
    			  controller.instance_eval { check_read_permissions !options[:skip_request].nil?, options[:user_model] }
          end
        else
          before_filter :if => options[:if], :unless => options[:unless] do |c| 
    			  c.instance_eval { check_read_permissions !options[:skip_request].nil?, options[:user_model] } 
          end
        end
      end
    end
    
    module InstanceMethods #:nodoc:
      private
      include CommonInstanceMethods
      
      # Checks if the current user is logged in and redirects to the login path if the user is not logged in.
      # 
      # If skip_request is set to true, the user won't be redirected to the original url after he/she logs in.
      def check_logged_in(skip_request = false, user_model = nil) #:nodoc:
        unless is_logged_in?(user_model)
          login_required skip_request
        end
      end
      
      # Checks if the current user is logged in and has write permission over the current controller, redirects to no access
      # page if the user hasn't the permissions and redirects to the login path if the user is not logged in
      #
      # If skip_request is set to true, the user won't be redirected to the original url after he/she logs in.
      def check_write_permissions(skip_request = false, user_model = nil) #:nodoc:
        if is_logged_in?(user_model)
          user_permissions = session[:user_permissions]
          check = user_permissions[:write].find { |perm| perm==self.controller_name || perm=="all" }
          unless check
            redirect_to no_access_sessions_path
          end
        else
          login_required skip_request
        end
      end
      
      # Checks if the current user is logged in and has read permission over the current controller, redirects to no access
      # page if the user hasn't the permissions and redirects to the login path if the user is not logged in
      #
      # If skip_request is set to true, the user won't be redirected to the original url after he/she logs in.    
      def check_read_permissions(skip_request = false, user_model = nil) #:nodoc:
        if is_logged_in?(user_model)
          user_permissions = session[:user_permissions]
          check = user_permissions[:read].find { |perm| perm==self.controller_name || perm=="all" }
          unless check
            redirect_to no_access_sessions_path
          end
        else
          login_required skip_request
        end
      end
      
      # Logs in the user through a remember me cookie    
      def cookie_login?(user_model = nil) #:nodoc:
        user_model = User if user_model.nil?
        
        if cookies[:remember_me_token]
          user = user_model.find_by_remember_me_token cookies[:remember_me_token]
          if user.nil?
            cookies.delete :remember_me_token
            return false
          else
            session[:user_id] = user.id
            session[:user_permissions] = {:read => user.permissions.collect{|per| per.area.name if per.read}, :write => user.permissions.collect{|per| per.area.name if per.write}}
            return true
          end
        else
          return false
        end
      end
      
      # Redirects the user to the login page
      #
      # If skip_request is set to true, the user won't be redirected to the original url after he/she logs in.    
      def login_required(skip_request) #:nodoc:
        unless(skip_request)
          session[:original_url]=request.url
        end
        flash.now[:alert] = t(:login_required, :scope => [:authentasaurus, :action_controller, :errors, :messages])
        redirect_to new_session_path
      end
      
      def controller_instance #:nodoc:
        self
      end 
    end
  end
  
  module ActionView # :nodoc:
    def self.included(base) 
      base.send :include, CommonInstanceMethods      
    end
  end
end