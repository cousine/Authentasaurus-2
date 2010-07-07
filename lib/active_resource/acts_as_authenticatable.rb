module ActiveResource::ActsAsAuthenticatable
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end
  
  module ClassMethods
    ## Authenticates the username and password
    def authenticate(username, password)
      
      if self.sync_to
        user = self.new Hash.from_xml(self.post(:signin,:username => username, :password => password).body).values.first
      end
      
      unless user.nil?
        if self.sync && !self.sync_to.nil?
          last_update = user.attributes.delete "updated_at"
          local_user = self.sync_to.find_or_initialize_by_username user.username, user.attributes
          
          if local_user.updated_at < last_update
            local_user.update_attributes user.attributes            
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
        
        local_user.update_attributes user.attributes            
      else
        false
      end
    end
  end
end