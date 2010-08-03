module Authentasaurus::Models::Group
  def self.included(base) # :nodoc:
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
    
    base.send :has_many, :permissions, :dependent => :destroy
    base.send :has_many, :areas, :through => :permissions
    
    base.send :validates_presence_of, :name
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
  end
end
