class PermissionsController < Authentasaurus::PermissionsController
  require_read :index, :show
	require_write :new, :create, :edit, :update, :destroy
end