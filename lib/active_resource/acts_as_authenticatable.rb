module ActiveResource::ActsAsAuthenticatable
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end
  
  module ClassMethods
    ## Authenticates the username and password
    def authenticate(username, password, remember = false)
      case(self.format)
      when ActiveResource::Formats::XmlFormat
        user = self.new Hash.from_xml(self.post(:signin,:username => username, :password => password, :remember => remember).body).values.first
      when ActiveResource::Formats::JsonFormat
        user = self.new ActiveSupport::JSON.decode(self.post(:signin,:username => username, :password => password, :remember => remember).body)
      else
        user = self.new Hash.from_xml(self.post(:signin,:username => username, :password => password, :remember => remember).body).values.first
      end
      
      unless user.nil?
        if self.sync && !self.sync_to.nil?
          last_update = user.attributes.delete "updated_at"
          local_user = self.sync_to.find_or_initialize_by_username user.username, user.attributes
          
          unless local_user.new_record?
            last_update_datetime = (last_update.kind_of?(String)) ? (DateTime.parse(last_update)) : (last_update)
            
            if local_user.updated_at < last_update_datetime
              
              local_user.update_attributes user.attributes            
            end
          else
            local_user.password = password
            local_user.hashed_password = user.hashed_password
            local_user.password_seed = user.password_seed
            local_user.save
          end
        end
      end
      return user
    end
  end
  
  module InstanceMethods
    def sync
      if self.class.sync && !self.class.sync_to.nil?
        user = self.dup
        last_update = user.attributes.delete "updated_at"
        local_user = self.class.sync_to.find_or_initialize_by_username user.username, user.attributes
        
        unless local_user.new_record?
          local_user.update_attributes user.attributes            
        else
          local_user.save
        end
      else
        false
      end
    end
  end
end