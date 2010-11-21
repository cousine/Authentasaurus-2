class AreasController < ApplicationController
  acts_as_areas
	require_read :index, :show
	require_write :new, :create, :edit, :update, :destroy
end