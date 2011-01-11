require 'erb'
require 'singleton'

module Authentasaurus
  class Configuration
    include Singleton
    
    attr_accessor :hashing, :user_model, :default_namespace, :configuration
    
    def load
      @configuration ||= parse_config      
    end
    
    private
    
    # Parse the config/sphinx.yml file - if it exists
    #
    def parse_config
      path = "#{Rails.root}/config/authentasaurus.yml"
      return unless File.exists?(path)
      
      conf = YAML::load(ERB.new(IO.read(path)).result)[Rails.env]
      
      conf.each do |key,value|
        self.send("#{key}=", value) if self.respond_to?("#{key}=")
      end
    end
    
  end
end