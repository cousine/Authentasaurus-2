require 'action_controller/authorization'
require 'action_view/authorization'
require 'active_record/authenticatable'
require 'active_resource/authenticatable'
require 'helpers/routing'
require 'helpers/migrations'

if defined? ActionController
  class ActionController::Base
    include ActionController::Authorization
  end
  
  class ActionView::Base
    include ActionView::Authorization
  end
  
  class ActionController::Routing::RouteSet::Mapper
    include Helpers::Routing
  end
end

if defined? ActiveRecord
  class ActiveRecord::Base
    include ActiveRecord::Authenticatable
  end
  
  class ActiveRecord::ConnectionAdapters::AbstractAdapter
    include Helpers::Migrations::Tables
  end
  
  class ActiveRecord::ConnectionAdapters::TableDefinition
    include Helpers::Migrations::Columns
  end
end

if defined? ActiveResource
  class ActiveResource::Base
    class_inheritable_accessor :sync, :sync_to
    include ActiveResource::Authenticatable
  end
end
