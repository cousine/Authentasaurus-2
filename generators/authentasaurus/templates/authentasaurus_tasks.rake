namespace :authentasaurus do
  desc "Setup default data for authentasaurus"
  task :setup_defaults => :environment do
    puts "Setting default data"
    unless ENV["authorizable"] == "false"
      puts "- Creating Areas"
      area = Area.create! :name => "all"
      create_areas
      puts "- Creating Administrators group"
      group = Group.create! :name => "Administrators"
      puts "- Creating permissions"
      Permission.create! :area_id => area.id, :group_id => group.id, :write => true, :read => true
      puts "- Creating default user"
      User.create! :username=> "admin" ,:password => "Pass@123",:password_confirmation => "Pass@123",:name=> "admin",
      :email=> AUTHENTASAURUS[:mail][:email], :active => true, :group_id => group.id
    else
      puts "- Creating default user"
      User.create! :username=> "admin" ,:password => "Pass@123",:password_confirmation => "Pass@123",:name=> "admin",
      :email=> AUTHENTASAURUS[:mail][:email], :active => true
    end
    
    puts "Created admin user, you can now login with the following credentials:"
    puts ""
    puts "Username: admin"
    puts "Password: Pass@123"
  end
  
  desc "Finds and creates areas for use in authorization"
  task :create_areas => :environment do
    create_areas
  end
  
  def create_areas
    puts "-- Locating areas"
    controllers = Dir.new("#{RAILS_ROOT}/app/controllers").entries
    controllers.each do |controller|
      if controller =~ /_controller/ && !(controller =~ /application_controller/)
        cont = controller.gsub("_controller.rb","")
        puts "--- Creating #{cont} area"
        Area.find_or_create_by_name cont
        unless Area.errors.empty?
          puts Area.errors.full_messages
          raise "Could not create areas"
        end
      end
    end
  end
end