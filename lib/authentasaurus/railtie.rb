require 'authentasaurus'
require 'rails'

module Authentasaurus
  class Railtie < Rails::Engine   
    ActiveSupport.on_load(:before_initialize) do
      Rails.application.config.authentasaurus = {}
      require 'active_record/acts_as_authenticatable'
      require 'active_record/acts_as_authenticatable_validatable'
      require 'active_resource/acts_as_authenticatable'
    end
  end
end