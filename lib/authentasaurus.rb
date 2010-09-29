module Authentasaurus
  # NEVER EVER REMOVE THIS !!!
  require 'authentasaurus/railtie' if defined?(Rails)
  # Controller stubs
  require 'authentasaurus/areas_controller' if defined?(ActionController)
  require 'authentasaurus/groups_controller' if defined?(ActionController)
  require 'authentasaurus/permissions_controller' if defined?(ActionController)
  require 'authentasaurus/recoveries_controller' if defined?(ActionController)
  require 'authentasaurus/registrations_controller' if defined?(ActionController)
  require 'authentasaurus/sessions_controller' if defined?(ActionController)
  require 'authentasaurus/user_invitations_controller' if defined?(ActionController)
  require 'authentasaurus/users_controller' if defined?(ActionController)
  require 'authentasaurus/validations_controller' if defined?(ActionController)
  # Model stubs
  require 'authentasaurus/models/area' if defined?(ActiveRecord)
  require 'authentasaurus/models/group' if defined?(ActiveRecord)
  require 'authentasaurus/models/permission' if defined?(ActiveRecord)
  require 'authentasaurus/models/recovery' if defined?(ActiveRecord)
  require 'authentasaurus/models/session' if defined?(ActiveRecord)
  require 'authentasaurus/models/user_invitation' if defined?(ActiveRecord)
  require 'authentasaurus/models/validation' if defined?(ActiveRecord)
  # Overriders ^^
  require 'action_controller/authorization'
  require 'action_view/authorization'  
  require 'active_record/authenticatable'  
  require 'active_resource/authenticatable'
  require 'helpers/migrations'
  require 'helpers/routing'  
  
  if defined?(ActionController)
    class ActionController::Base
      include ActionController::Authorization
    end
    
    class ActionView::Base
      include ActionView::Authorization
    end
    
    class ActionDispatch::Routing::Mapper
      include Routing
    end
  end
  
  if defined?(ActiveRecord)
    class ActiveRecord::Base
      include ActiveRecord::Authenticatable
    end
    
    class ActiveRecord::ConnectionAdapters::AbstractAdapter
      include Migrations::Tables
    end
    
    class ActiveRecord::ConnectionAdapters::TableDefinition
      include Migrations::Columns
    end
  end
  
  if defined?(ActiveResource)
    class ActiveResource::Base
      class_inheritable_accessor :sync, :sync_to
      include ActiveResource::Authenticatable
    end
  end

end