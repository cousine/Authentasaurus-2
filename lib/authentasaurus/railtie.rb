require 'authentasaurus'
require 'rails'

module Authentasaurus
  class Railtie < Rails::Engine    
    config.to_prepare do
      require 'active_record/acts_as_authenticatable'
      require 'active_record/acts_as_authenticatable_validatable'
      require 'active_resource/acts_as_authenticatable'
    end
  end
end