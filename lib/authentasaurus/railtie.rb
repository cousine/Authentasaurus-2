require 'authentasaurus'
require 'rails'

module Authentasaurus #:nodoc:
  class Railtie < Rails::Engine
    initializer "authentasaurus.initialize" do |app|
      Authentasaurus::Configuration.instance.load
    end
  end
end