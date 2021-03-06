class AuthentasaurusViewsGenerator < Rails::Generator::NamedBase
  default_options :authorizable => false, :validatable => false, :invitable => false

  def manifest
    record do |m|
      # Controller, View , Model, test, and fixture directories.
      m.directory File.join('app/views', class_path)
      # Other directories
      m.directory File.join('app/views', class_path, "sessions")
      m.directory File.join('app/views', class_path, file_name)
      m.directory File.join('app/views', class_path, "authentasaurus_emailer")
      m.directory File.join('app/views', class_path, "recoveries")
      
      # Views
      ## user sessions
      m.file 'views/sessions/new.html.erb', File.join("app/views", class_path, "sessions", "new.html.erb")
      m.file 'views/sessions/no_access.html.erb', File.join("app/views", class_path, "sessions", "no_access.html.erb")
      ## users
      m.file 'views/users/edit.html.erb', File.join("app/views", class_path, file_name, "edit.html.erb")
      m.file 'views/users/index.html.erb', File.join("app/views", class_path, file_name, "index.html.erb")
      m.file 'views/users/new.html.erb', File.join("app/views", class_path, file_name, "new.html.erb")
      m.file 'views/users/show.html.erb', File.join("app/views", class_path, file_name, "show.html.erb")
      ## recoverable
      m.file 'views/recoveries/new.html.erb', File.join("app/views", class_path, "recoveries", "new.html.erb")
      m.file 'views/recoveries/edit.html.erb', File.join("app/views", class_path, "recoveries", "edit.html.erb")
      m.file 'views/authentasaurus_emailer/recovery_mail.html.erb', File.join("app/views", class_path, "authentasaurus_emailer", "recovery_mail.html.erb")
      
      
      if options[:authorizable]
        m.directory File.join('app/views', class_path, "groups")
        m.directory File.join('app/views', class_path, "areas")
        m.directory File.join('app/views', class_path, "permissions")
        ## groups
        m.file 'views/groups/show.html.erb', File.join('app/views', class_path, "groups", "show.html.erb")
        m.file 'views/groups/index.html.erb', File.join("app/views", class_path, "groups", "index.html.erb")
        m.file 'views/groups/edit.html.erb', File.join("app/views", class_path, "groups", "edit.html.erb")
        m.file 'views/groups/new.html.erb', File.join("app/views", class_path, "groups", "new.html.erb")
        ## areas
        m.file 'views/areas/edit.html.erb', File.join("app/views", class_path, "areas", "edit.html.erb")
        m.file 'views/areas/index.html.erb', File.join("app/views", class_path, "areas", "index.html.erb")
        m.file 'views/areas/new.html.erb', File.join("app/views", class_path, "areas", "new.html.erb")
        m.file 'views/areas/show.html.erb', File.join("app/views", class_path, "areas", "show.html.erb")
        ## permissions
        m.file 'views/permissions/edit.html.erb', File.join("app/views", class_path, "permissions", "edit.html.erb")
        m.file 'views/permissions/index.html.erb', File.join("app/views", class_path, "permissions", "index.html.erb")
        m.file 'views/permissions/new.html.erb', File.join("app/views", class_path, "permissions", "new.html.erb")
        m.file 'views/permissions/show.html.erb', File.join("app/views", class_path, "permissions", "show.html.erb")
      end

      # Validations
      if options[:validatable]
        m.directory File.join('app/views', class_path, "validations")
        
        # Views
        m.file 'views/validations/activate.html.erb', File.join("app/views", class_path, "validations", "activate.html.erb")
        m.file 'views/validations/resend_validation_email.html.erb', File.join("app/views", class_path, "validations", "resend_validation_email.html.erb")
        m.file 'views/authentasaurus_emailer/validation_mail.html.erb', File.join("app/views", class_path, "authentasaurus_emailer", "validation_mail.html.erb")
      end
      
      # User invitations
      if options[:invitable]
        m.directory File.join('app/views', class_path, "user_invitations")
        m.directory File.join('app/views', class_path, "registrations")
        
        #Views
        m.file 'views/user_invitations/index.html.erb', File.join('app/views', class_path, 'user_invitations', "index.html.erb")
        m.file 'views/user_invitations/new.html.erb', File.join('app/views', class_path, 'user_invitations', "new.html.erb")
        
        m.file 'views/registrations/new.html.erb', File.join('app/views', class_path, 'registrations', "new.html.erb")

        m.file 'views/authentasaurus_emailer/invitation_mail.html.erb', File.join("app/views", class_path, "authentasaurus_emailer", "invitation_mail.html.erb")
      end
    end
  end

  protected
  def banner
    "Usage: #{$0} #{spec.name} MainUserControllerName"
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--validatable",
           "Add validation to authentasaurus") { |v| options[:validatable] = v }
    opt.on("--authorizable",
           "Add authorization to authentasaurus") { |v| options[:authorizable] = v }
    opt.on("--invitable",
           "Add invitations to authentasaurus") { |v| options[:invitable] = v }
  end
end