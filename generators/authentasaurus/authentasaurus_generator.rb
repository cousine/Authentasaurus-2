class AuthentasaurusGenerator < Rails::Generator::Base
  def manifest
    record do |m|
    	m.file "initializer.rb", File.join("config", "initializers", "authentasaurus.rb")
      m.file "defaults.yml", File.join("config", "authentasaurus.yml")
      m.file "authentasaurus_tasks.rake", File.join("lib","tasks","authentasaurus.rake")
    end
  end
end