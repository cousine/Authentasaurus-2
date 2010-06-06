class User < ActiveRecord::Base
  authenticatable_with true, :validation
end