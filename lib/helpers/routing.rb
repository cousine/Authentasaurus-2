## Authentasaurus routes helper
module Helpers::Routing
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
    	authentasaurus_recoverable options.dup
      
      # Authorizable
      if opts.include?(:authorizable)
        authentasaurus_authorizable options.dup
      end
      
      # Validatable
      if opts.include?(:validatable)
        authentasaurus_validatable options.dup
      end
      
      # Invitable
      if opts.include?(:invitable)
        authentasaurus_invitable options.dup
        authentasaurus_invitable_public
      end
    end
    
    # TODO: add documentation here
    def authentasaurus_sessions(*opts)
      options = opts.extract_options!
      
      resources :sessions, options.dup.merge({:except => [:index, :show, :edit, :update], :path_names => {:new => 'sign-in'}, :collection => {:no_access => :get}})
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
    def authentasaurus_validatable(*opts)
      options = opts.extract_options!
      
      validate "/validate", options.dup.merge({:controller => :validations, :action => :validate})
      activate "/activate", options.dup.merge({:controller => :validations, :action => :activate})
      resend_validation_email "/resend-validation", options.dup.merge({:controller => :validations, :action => :resend_validation_email, :conditions => {:method => :get}})
      do_resend_validation_email "/resend-validation", options.dup.merge({:controller => :validations, :action => :do_resend_validation_email, :conditions => {:method => :post}})
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
    def authentasaurus_recoverable(*opts)
    	options = opts.extract_options!
    	
	  	forgot_password			"/forgot-password", 					options.dup.merge({ :controller => :recoveries, :action => :new,			:conditions => { :method => :get } })
	  	do_forgot_password	"/forgot-password", 					options.dup.merge({ :controller => :recoveries, :action => :create,		:conditions => { :method => :post } })
	  	recover_password		"/recover-password/:token", 	options.dup.merge({ :controller => :recoveries, :action => :edit,			:conditions => { :method => :get } })
	  	do_recover_password	"/recover-password/:token", 	options.dup.merge({ :controller => :recoveries, :action => :destroy,	:conditions => { :method => :delete } })
  	end
  end
end