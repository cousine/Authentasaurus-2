# Defines authorization helpers for ActionController
module Authorization
  
  def self.included(base) # :nodoc:
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end
  
  
  module ClassMethods
    
    # <tt>require_login</tt>::
    #   requires the user to login before accessing the actions specified
    # 
    #   <b>ex:</b> Tells Authentasaurus that the action destroy requires login and that
    #   Authentasaurus shouldn't store the request in the session
    #   (typically for logout actions)
    # 
    #   * :actions - actions that require the permission (list)
    #   * :skip_request - skips saving the original request (to redirect to after login)
    #   * :user_model - if defined, authentasaurus will use that model instead of the default "User"
    # 
    #     require_login :actions => :destroy, :skip_request => true
    def require_login (options ={})
  		if options[:actions]
  		  before_filter :only => options[:actions] do |controller|
  		    controller.instance_eval {check_logged_in !options[:skip_request].nil?, options[:user_model]}
		    end
  		else
  			before_filter {|c| c.instance_eval {check_logged_in !options[:skip_request].nil?, options[:user_model]} }
  		end
    end
    
    # <tt>require_write</tt>::
    #   requires the user to have a write permission to that area to access the actions specified
    # 
    #   <b>ex:</b> Tells Authentasaurus that the actions create_user and delete_user
    #   requires login and write permission.
    #   
    #   * :actions - actions that require the permission (list)
    #   * :skip_request - skips saving the original request (to redirect to after login)
    #   * :user_model - if defined, authentasaurus will use that model instead of the default "User"
    # 
    #     require_write :actions => [:create_user, :delete_user]
    def require_write(options = {})
  		if options[:actions]
  			before_filter :only => options[:actions] do |controller|
  			  controller.instance_eval { check_write_permissions !options[:skip_request].nil?, options[:user_model] }
			  end
  		else
  			before_filter {|c| c.instance_eval {check_write_permissions !options[:skip_request].nil?, options[:user_model]} }
  		end
    end
    
    # <tt>require_read</tt>::
    #   requires the user to have a read permission to that area to access the actions specified
    # 
    #   <b>ex:</b> Tells Authentasaurus that the action show_user requires login and read
    #   permission. 
    #   
    #   * :actions - actions that require the permission (list)
    #   * :skip_request - skips saving the original request (to redirect to after login)
    #   * :user_model - if defined, authentasaurus will use that model instead of the default "User"
    # 
    #     require_read :actions => :show_user
    def require_read(options = {})
  		if options[:actions]
  			before_filter :only => options[:actions] do |controller|
  			  controller.instance_eval { check_read_permissions !options[:skip_request].nil?, options[:user_model] }
			  end
  		else
  			before_filter {|c| c.instance_eval { check_read_permissions !options[:skip_request].nil?, options[:user_model] } }
  		end
    end
  end
  
  module InstanceMethods
    private
    # Returns an object of the current user
    def current_user(user_model = nil)
      user_model = User if user_model.nil?
      return user_model.find session[:user_id] if session[:user_id]
    end
    
    # Checks if the current user is logged in and redirects to the login path if the user is not logged in.
    # 
    # If skip_request is set to true, the user won't be redirected to the original url after he/she logs in.
    def check_logged_in(skip_request = false, user_model = nil)
      unless is_logged_in?(user_model)
        login_required skip_request
      end
    end
    
    # Checks if the current user is logged in and has write permission over the current controller, redirects to no access
    # page if the user hasn't the permissions and redirects to the login path if the user is not logged in
    #
    # If skip_request is set to true, the user won't be redirected to the original url after he/she logs in.
    def check_write_permissions(skip_request = false, user_model = nil)
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
    def check_read_permissions(skip_request = false, user_model = nil)
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
    
    # Checks if the current user is logged in but takes no further action
    def is_logged_in?(user_model)
      user_model = User if user_model.nil?
      unless user_model.find_by_id(session[:user_id])
        return cookie_login?(user_model)
      end
			return true
    end
    
    # Logs in the user through a remember me cookie
    def cookie_login?(user_model)
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
    def login_required(skip_request)
      unless(skip_request)
        session[:original_url]=request.url
      end
      flash[:notice] = t(:login_required, :scope => [:authentasaurus, :action_controller, :errors, :messages])
      redirect_to new_session_path
    end
    
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