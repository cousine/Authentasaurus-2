def self.require_from_engine(engine_name, file)
  file_path = file.split('/')
  location = if file =~ /_helper$/
                "helpers"
             elsif file =~ /_controller$/
                "controllers"
             end
  file = File.join([ "app", location||"models" ] + file_path)
  file_name = File.join(Rails.root.to_s, "vendor", "plugins", engine_name, file)
  if RAILS_ENV =~ /development/
    load (file_name + ".rb")
  else
    require file_name
  end
end