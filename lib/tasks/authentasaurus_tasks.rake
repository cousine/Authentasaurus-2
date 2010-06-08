namespace :authentasaurus do
  desc "Finds and creates areas for use in authorization"
  task :create_areas => :environment do
    controllers = Dir.new("#{RAILS_ROOT}/app/controllers").entries
    controllers.each do |controller|
      if controller =~ /_controller/ && !(controller =~ /application_controller/)
       cont = controller.gsub("_controller.rb","")
       Area.create! :name => cont
      end
    end
  end
end