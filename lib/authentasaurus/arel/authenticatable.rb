module Authentasaurus::Arel
  module Authenticatable
    def self.included(base)
      base.send :extend, ClassMethods
      
    end
    
    module ClassMethods
      
      def authenticatable(*args)
        self.unloadable
        options = args.extract_options!
        
        self.site = options[:site] || Rails.application.config.authentasaurus[:modules][:remote][self.name.underscore.gsub(/_sync/, "").to_sym][:site]
        self.element_name = options[:session_element].try(:to_s) || Rails.application.config.authentasaurus[:modules][:remote][self.name.underscore.gsub(/_sync/, "").to_sym][:session_element]
        self.sync = options[:sync] || Rails.application.config.authentasaurus[:modules][:remote][self.name.underscore.gsub(/_sync/, "").to_sym][:sync]
        self.sync_to = options[:sync_to].try(:to_s).try(:camelize).try(:constantize) || Rails.application.config.authentasaurus[:modules][:remote][self.name.underscore.gsub(/_sync/, "").to_sym][:sync_to].camelize.constantize
        
        
        # include authentication methods
        include Authentasaurus::Arel::ActsAsAuthenticatable
      end
    end
  end
end