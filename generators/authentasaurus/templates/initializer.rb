# Loads the system configuration
# Usage: AUTHENTASAURUS_CONFIGURATIONS[:section][:key]
AUTHENTASAURUS = YAML.load(File.read(Rails.root.join("config", "authentasaurus.yml")))[RAILS_ENV]
