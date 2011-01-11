module Authentasaurus::Ac::Controllers
  module SessionsController
    extend ActiveSupport::Concern
    
    included do      
      before_filter :check_is_logged_in, :except => [:destroy, :no_access]      
    end
    
    module ClassMethods
    end
        
    def new
      @session = AuthentasaurusSession.new
      
      respond_to do |format|
        format.html
      end
    end
    
    def create
      @session = AuthentasaurusSession.new params[:authentasaurus_session]
      
      respond_to do |format|
        if @session.save(self.class.user_model)
          if @session.remember == "1"
            cookies.signed.permanent[:remember_me_token] = @session.user.remember_me_token
          end
          session[:user_id] = @session.user.id
          if @session.user.respond_to?(:permissions)
            session[:user_permissions] =   {:read => @session.user.permissions.collect{|per| per.area.name if per.read}, :write => @session.user.permissions.collect{|per| per.area.name if per.write}}
          end
          format.html { redirect_to session[:original_url] || (defined?(authentasaurus_signin_redirect_path).nil? ?  root_path : authentasaurus_signin_redirect_path) }
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
        redirect_to defined?(authentasaurus_signin_redirect_path).nil? ?  root_path : authentasaurus_signin_redirect_path
      end
    end
  end  
end