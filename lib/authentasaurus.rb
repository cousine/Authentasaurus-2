module Authentasaurus  
  require 'authentasaurus/railtie' if defined?(Rails) # NEVER EVER REMOVE THIS LINE !!!
  # Authorization Helpers
  require 'authentasaurus/authorization'
  # Controllers, Views and Routes helpers
  require 'authentasaurus/ac/acts_as_overrider'
  require 'authentasaurus/ac/routing'
  # ActiveRecord And Migrations Helpers  
  require 'authentasaurus/ar/acts_as_overrider'
  require 'authentasaurus/ar/authenticatable'
  require 'authentasaurus/ar/migrations'
  # ActiveResource Helpers
  require 'authentasaurus/arel/authenticatable'
  
  if defined?(ActionController)
    class ActionController::Base
      include Authentasaurus::Authorization::ActionController
      include Authentasaurus::Ac::ActsAsOverrider
    end
    
    class ActionView::Base
      include Authentasaurus::Authorization::ActionView
    end
    
    class ActionDispatch::Routing::Mapper
      include Authentasaurus::Ac::Routing
    end
  end
  
  if defined?(ActiveRecord)
    class ActiveRecord::Base
      include Authentasaurus::Ar::Authenticatable
      include Authentasaurus::Ar::ActsAsOverrider
    end
    
    class ActiveRecord::ConnectionAdapters::AbstractAdapter
      include Authentasaurus::Ar::Migrations::Tables
    end
    
    class ActiveRecord::ConnectionAdapters::TableDefinition
      include Authentasaurus::Ar::Migrations::Columns
    end
  end
  
  if defined?(ActiveResource)
    class ActiveResource::Base
      class_inheritable_accessor :sync, :sync_to
      include Authentasaurus::Arel::Authenticatable
    end
  end

end