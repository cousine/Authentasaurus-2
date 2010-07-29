# Defines authorization helpers for ActionController
module ActionView::Authorization
  
  def self.included(base) # :nodoc:
    base.send :include, InstanceMethods
  end
  
  module InstanceMethods
    private
    # Returns an object of the current user
    def current_user(user_model = nil)
      user_model = User if user_model.nil?
      return user_model.find session[:user_id] if session[:user_id]
    end
    
    # Checks if the current user is logged in but takes no further action
    def is_logged_in?(user_model = nil)
      user_model = User if user_model.nil?
      unless user_model.find_by_id(session[:user_id])
        return false
      end
			return true
    end
    
    # Checks if the current user has the appropriate permission
    # 
    # *ex*: has?(:write) or has?(:read, :users)
    def has?(permission, area = nil, user_model = User)
      return false unless is_logged_in? user_model
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
  end
end