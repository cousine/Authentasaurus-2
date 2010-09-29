module Authentasaurus::Models
  module Permission
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      
      base.send :unloadable
      
      base.send :belongs_to, :group
      base.send :belongs_to, :area
      
      # Check that everything is there
      base.send :validates_presence_of, :group_id, :area_id
      # Check foreign keys
      base.send :validates_associated, :group, :area
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
    end
  end
end
