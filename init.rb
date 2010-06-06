require 'action_controller/authorization'
require 'active_record/authenticatable'
require 'helpers/routing'

if defined? ActionController
  class ActionController::Base
    include Authorization
  end
  
  class ActionController::Routing::RouteSet::Mapper
    include Routing
  end
end

if defined? ActiveRecord
  class ActiveRecord::Base
    include Authenticatable
  end
end
