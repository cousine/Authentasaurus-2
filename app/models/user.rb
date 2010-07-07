class User < ActiveRecord::Base
  authenticatable :strong_password, :validatable
end