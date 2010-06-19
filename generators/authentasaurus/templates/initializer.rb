# Loads the system configuration
# Usage: AUTHENTASAURUS_CONFIGURATIONS[:section][:key]
AUTHENTASAURUS_CONFIGURATIONS = YAML.load(File.read(Rails.root.join("config", "authentasaurus.yml")))[RAILS_ENV]

# Load mail configuration
ActionMailer::Base.default_url_options = { :host => AUTHENTASAURUS_CONFIGURATIONS[:mail][:host] }
ActionMailer::Base.smtp_settings = {
  :address =>					AUTHENTASAURUS_CONFIGURATIONS[:mail][:address],
  :port =>						AUTHENTASAURUS_CONFIGURATIONS[:mail][:port],
  :domain =>					AUTHENTASAURUS_CONFIGURATIONS[:mail][:domain],
  :authentication =>	:login,
  :user_name =>				AUTHENTASAURUS_CONFIGURATIONS[:mail][:user_name],
  :password =>				AUTHENTASAURUS_CONFIGURATIONS[:mail][:password]
}
