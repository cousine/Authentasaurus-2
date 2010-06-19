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

  desc "Creates the default admin user"
  task :create_admin => :environment do
    User.create! :username=> "admin" ,:password => "Pass@123",:password_confirmation => "Pass@123",:name=> "admin",
      :email=> AUTHENTASAURUS[:mail][:email], :active => true
  end
end