module Authentasaurus::Ac  
  Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file }
  
  module ActsAsOverrider
    extend ActiveSupport::Concern    
    
    module ClassMethods      
      def acts_as_areas
        include Authentasaurus::Ac::Controllers::AreasController
      end
      
      def acts_as_groups
        include Authentasaurus::Ac::Controllers::GroupsController
      end
      
      def acts_as_permissions
        include Authentasaurus::Ac::Controllers::PermissionsController
      end
      
      def acts_as_recoveries
        include Authentasaurus::Ac::Controllers::RecoveriesController
      end
      
      def acts_as_registrations
        include Authentasaurus::Ac::Controllers::RegistrationsController
      end
      
      def acts_as_sessions(user_model = nil)        
        cattr_accessor :user_model
        self.user_model = user_model || Authentasaurus::Configuration.instance.user_model.to_sym
        
        include Authentasaurus::Ac::Controllers::SessionsController
      end
      
      def acts_as_user_invitations
        include Authentasaurus::Ac::Controllers::UserInvitationsController
      end
      
      def acts_as_users
        include Authentasaurus::Ac::Controllers::UsersController
      end
      
      def acts_as_validations
        include Authentasaurus::Ac::Controllers::ValidationsController
      end
    end
  end
end