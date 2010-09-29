module Authentasaurus::Models
  module Area
    def self.included(base) # :nodoc:
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      
      base.send :unloadable
      
      base.send :has_many, :permissions, :dependent => :destroy
      base.send :has_many, :groups, :through => :permissions
      
      base.send :validates_presence_of, :name
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
    end
  end
end
