class AuthentasaurusGenerator < Rails::Generator::Base
  def manifest
    record do |m|
    	m.file "initializer.rb", File.join("config", "initializers", "authentasaurus.rb")
      m.file "defaults.yml", File.join("config", "authentasaurus.yml")
    end
  end
end