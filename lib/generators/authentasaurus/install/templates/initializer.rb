# Loads the system configuration
# Usage: Rails.application.config.authentasaurus[:section][:key]
Rails.application.config.authentasaurus = YAML.load(File.read(Rails.root.join("config", "authentasaurus.yml")))[RAILS_ENV]
