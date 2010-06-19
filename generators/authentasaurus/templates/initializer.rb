# Loads the system configuration
# Usage: AUTHENTASAURUS_CONFIGURATIONS[:section][:key]
AUTHENTASAURUS_CONFIGURATIONS = YAML.load(File.read(Rails.root.join("config", "authentasaurus.yml")))[RAILS_ENV]
