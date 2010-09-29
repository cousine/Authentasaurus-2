# Loads the system configuration
# Usage: AUTHENTASAURUS[:section][:key]
AUTHENTASAURUS = YAML.load(File.read(Rails.root.join("config", "authentasaurus.yml")))[RAILS_ENV]
