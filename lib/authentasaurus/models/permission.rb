class Authentasaurus::Models::Permission < ActiveRecord::Base
  belongs_to :group
  belongs_to :area

  # Check that everything is there
  validates_presence_of :group_id,:area_id,:read,:write
  # Check foreign keys
  validates_associated :group, :area
end
