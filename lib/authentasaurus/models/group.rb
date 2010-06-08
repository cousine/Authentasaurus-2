class Authentasaurus::Models::Group < ActiveRecord::Base
  has_many :permissions, :dependent => :destroy
  has_many :areas, :through => :permissions

  # Check that everything is there
  validates_presence_of :name
  
end
