## Authentasaurus routes helper
module Authentasaurus::Ac
  module Routing
    def self.included(base) # :nodoc:
      base.send :include, InstanceMethods
    end
    
    module InstanceMethods
      # TODO: add documentation here
      def authentasaurus_routes(*opts)
        options = opts.extract_options!
        
        # Authenticatable
        authentasaurus_sessions options.dup
        authentasaurus_users options.dup
        # Recoverable
        authentasaurus_recoverable
        
        # Authorizable
        if opts.include?(:authorization)
          authentasaurus_authorizable options.dup
        end
        
        # Validatable
        if opts.include?(:validation)
          authentasaurus_validatable
        end
        
        # Invitable
        if opts.include?(:invitation)
          authentasaurus_invitable options.dup
          authentasaurus_invitable_public
        end
      end
      
      # TODO: add documentation here
      def authentasaurus_sessions(*opts)
        get     "/sessions/sign-in(.:format)" => "sessions#new", :as => :new_session
        post    "/sessions(.:format)" => "sessions#create", :as => :sessions
        delete  "/sessions/sign-out(.:format)" => "sessions#destroy", :as => :session
        get     "/sessions/no-access(.:format)" => "sessions#no_access", :as => :no_access_sessions
      end
      
      # TODO: add documentation here
      def authentasaurus_users(*opts)
        options = opts.extract_options!
        
        resources :users, options.dup
      end
      
      # TODO: add documentation here
      def authentasaurus_authorizable(*opts)
        options = opts.extract_options!
        
        resources :groups, options.dup
        resources :areas, options.dup
        resources :permissions, options.dup
      end
      
      # TODO: add documentation here
      def authentasaurus_validatable
        match "/validate" => "validations#validate", :as => 'validate'
        match "/activate" => "validations#activate", :as => 'activate'
        match "/resend-validation" => "validations#resend_validation_email", :via => :get, :as => 'recover_password'
        match "/resend-validation" => "validations#do_resend_validation_email", :via => :post, :as => 'do_recover_password'
      end
      
      # TODO: add documentation here
      def authentasaurus_invitable(*opts)
        options = opts.extract_options!
        
        resources :user_invitations, options.dup.merge({:except => [:show, :edit, :update]})
      end
      
      def authentasaurus_invitable_public(*opts)
        options = opts.extract_options!
        
        resources :registrations, :only => [:new, :create], :path_prefix => "/:token", :requirements => {:token => /[0-9a-zA-Z]+/}
      end
      
      # TODO: add documentation here
      def authentasaurus_recoverable      
        match "/forgot-password" => "recoveries#new", :via => :get, :as => 'forgot_password'
        match "/forgot-password" => "recoveries#create", :via => :post, :as => 'do_forgot_password'
        match "/recover-password/:token" => "recoveries#edit", :via => :get, :as => 'recover_password'
        match "/recover-password/:token" => "recoveries#destroy", :via => :delete, :as => 'do_recover_password'
      end
    end
  end
end