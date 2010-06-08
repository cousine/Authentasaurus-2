# Defines authorization helpers for ActionController
module Authorization
  
  def self.included(base) # :nodoc:
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end
  
  module ClassMethods
    # Checks if the current user has the appropriate permission
    # 
    # *ex*: has?(:write) or has?(:read, :users)
    def has?(permission, area = nil)
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
  end
end