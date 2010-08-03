class GroupsController < ApplicationController
  include Authentasaurus::GroupsController
	require_read :index, :show
	require_write :new, :create, :edit, :update, :destroy
end