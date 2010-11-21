require 'authentasaurus'
require 'rails'

module Authentasaurus #:nodoc:
  class Railtie < Rails::Engine   
    ActiveSupport.on_load(:before_initialize) do
      Rails.application.config.authentasaurus = {}
      require 'authentasaurus/ar/acts_as_authenticatable'
      require 'authentasaurus/ar/acts_as_authenticatable_validatable'
      require 'authentasaurus/arel/acts_as_authenticatable'
    end
  end
end