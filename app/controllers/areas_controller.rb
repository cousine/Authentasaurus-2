class AreasController < ApplicationController
  include Authentasaurus::AreasController
	require_read :index, :show
	require_write :new, :create, :edit, :update, :destroy
end