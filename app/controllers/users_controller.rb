class UsersController < ApplicationController
  include Authentasaurus::UsersController
  require_read :index, :show
	require_write :new, :create, :edit, :update, :destroy
end