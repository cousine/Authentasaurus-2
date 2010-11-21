class PermissionsController < ApplicationController
  acts_as_permissions
  require_read :index, :show
	require_write :new, :create, :edit, :update, :destroy
end