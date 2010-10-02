module Authentasaurus
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    def install
      copy_file "defaults.yml", "config/authentasaurus.yml"
      copy_file "authentasaurus_tasks.rake", "lib/tasks/authentasaurus_tasks.rake"
      copy_file "initializer.rb", "config/initializers/authentasaurus.rb"
    end
  end
end
