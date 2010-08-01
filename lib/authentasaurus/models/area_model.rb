class Authentasaurus::Models::AreaModel < ActiveRecord::Base
  has_many :permissions, :dependent => :destroy
  has_many :groups, :through => :permissions

  # Check that everything is there
  validates_presence_of :name
  
end
