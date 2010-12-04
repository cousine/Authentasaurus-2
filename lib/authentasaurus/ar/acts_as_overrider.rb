module Authentasaurus::Ar
  Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
  
  module ActsAsOverrider
    def self.included(base)
      base.send :extend, ClassMethods
    end
    
    module ClassMethods
      def acts_as_area        
        unloadable
      
        has_many :permissions, :dependent => :destroy
        has_many :groups, :through => :permissions
      
        validates_presence_of :name
      end
      
      def acts_as_group
        has_many :permissions, :dependent => :destroy
        has_many :areas, :through => :permissions
        
        validates_presence_of :name
      end
      
      def acts_as_permission
        unloadable
      
        belongs_to :group
        belongs_to :area
        
        # Check that everything is there
        validates_presence_of :group_id, :area_id
        # Check foreign keys
        validates_associated :group, :area
      end
      
      def acts_as_recovery
        include Authentasaurus::Ar::Models::Recovery
      end
      
      def acts_as_user_invitation
        include Authentasaurus::Ar::Models::UserInvitation
      end
      
      def acts_as_validation
        include Authentasaurus::Ar::Models::Validation
      end
    end
  end
end