class UsersController < ApplicationController
  acts_as_users
  require_read :index, :show
	require_write :new, :create, :edit, :update, :destroy
end