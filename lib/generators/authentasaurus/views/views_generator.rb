module Authentasaurus
  class ViewsGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../../../../../app/views', __FILE__)
    class_option  :authorization, :type => :boolean, :default => true, :desc => "Generates views for authorization"
    class_option  :validation, :type => :boolean, :default => true, :desc => "Generates views for user validation"
    class_option  :invitation, :type => :boolean, :default => true, :desc => "Generates views for user invitation"
    
    # Generate Users Views
    def generate_users
      copy_file "users/edit.html.erb", "app/views/#{name.underscore.pluralize}/edit.html.erb"
      copy_file "users/index.html.erb", "app/views/#{name.underscore.pluralize}/index.html.erb"
      copy_file "users/new.html.erb", "app/views/#{name.underscore.pluralize}/new.html.erb"
      copy_file "users/show.html.erb", "app/views/#{name.underscore.pluralize}/show.html.erb"
    end
    
    # Generate Sessions Views
    def generate_sessions
      copy_file "sessions/new.html.erb", "app/views/#{class_path}/sessions/new.html.erb"
      copy_file "sessions/no_access.html.erb", "app/views/#{class_path}/sessions/no_access.html.erb"
    end
    
    # Generate recoveries Views
    def generate_recoveries
      copy_file "recoveries/edit.html.erb", "app/views/#{class_path}/recoveries/edit.html.erb"
      copy_file "recoveries/new.html.erb", "app/views/#{class_path}/recoveries/new.html.erb"
      copy_file "authentasaurus_emailer/recovery_mail.html.erb", "app/views/#{class_path}/authentasaurus_emailer/recovery_mail.html.erb"    
    end
    
    # Generate Authorization Views
    def generate_authorization
      if options.authorization?
        # Areas
        copy_file "areas/edit.html.erb", "app/views/#{class_path}/areas/edit.html.erb"
        copy_file "areas/index.html.erb", "app/views/#{class_path}/areas/index.html.erb"
        copy_file "areas/new.html.erb", "app/views/#{class_path}/areas/new.html.erb"
        copy_file "areas/show.html.erb", "app/views/#{class_path}/areas/show.html.erb"
        
        # Groups
        copy_file "groups/edit.html.erb", "app/views/#{class_path}/groups/edit.html.erb"
        copy_file "groups/index.html.erb", "app/views/#{class_path}/groups/index.html.erb"
        copy_file "groups/new.html.erb", "app/views/#{class_path}/groups/new.html.erb"
        copy_file "groups/show.html.erb", "app/views/#{class_path}/groups/show.html.erb"
        
        # Permissions
        copy_file "permissions/edit.html.erb", "app/views/#{class_path}/permissions/edit.html.erb"
        copy_file "permissions/index.html.erb", "app/views/#{class_path}/permissions/index.html.erb"
        copy_file "permissions/new.html.erb", "app/views/#{class_path}/permissions/new.html.erb"
        copy_file "permissions/show.html.erb", "app/views/#{class_path}/permissions/show.html.erb"
      end
    end
    
    # Generate Validation Views
    def generate_validation
      if options.validation?
        # Validations
        copy_file "validations/resend_validation_email.html.erb", "app/views/#{class_path}/validations/resend_validation_email.html.erb"
        copy_file "validations/validate.html.erb", "app/views/#{class_path}/validations/validate.html.erb"
        # Validation email
        copy_file "authentasaurus_emailer/validation_mail.html.erb", "app/views/#{class_path}/authentasaurus_emailer/validation_mail.html.erb"      
      end
    end
    
    # Generate Invitation Views
    def generate_invitation    
      if options.invitation?
        # User Invitations
        copy_file "user_invitations/index.html.erb", "app/views/#{class_path}/user_invitations/index.html.erb"
        copy_file "user_invitations/new.html.erb", "app/views/#{class_path}/user_invitations/new.html.erb"
        # Registrations
        copy_file "registrations/new.html.erb", "app/views/#{class_path}/registrations/new.html.erb"
        # Invitation email
        copy_file "authentasaurus_emailer/invitation_mail.html.erb", "app/views/#{class_path}/authentasaurus_emailer/invitation_mail.html.erb"
      end
    end  
  end
end