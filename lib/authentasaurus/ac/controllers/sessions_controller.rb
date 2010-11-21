module Authentasaurus::Ac::Controllers
  module SessionsController
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      
      base.send :before_filter, :check_is_logged_in, :except => [:destroy, :no_access]
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def new
        @session = Session.new
        
        respond_to do |format|
          format.html
        end
      end
      
      def create
        @session = Session.new params[:session]
        
        respond_to do |format|
          if @session.save
            if @session.remember == "1"
              cookies.signed.permanent[:remember_me_token] = @session.user.remember_me_token
            end
            session[:user_id] = @session.user.id
            session[:user_permissions] =   {:read => @session.user.permissions.collect{|per| per.area.name if per.read}, :write => @session.user.permissions.collect{|per| per.area.name if per.write}}
            format.html { redirect_to session[:original_url] || (defined?(signin_redirect_path).nil? ?  root_path : signin_redirect_path) }
          else
            format.html { render :action => :new }
          end
        end
        
      end
      
      def destroy
        session[:user_id] = nil
        session[:user_permissions] = nil
        cookies.delete :remember_me_token
        
        respond_to do |format|
          format.html { redirect_to :action => :new }
        end
      end
      
      private
      def check_is_logged_in
        if is_logged_in?
          redirect_to defined?(signin_redirect_path).nil? ?  root_path : signin_redirect_path
        end
      end
    end
  end
end